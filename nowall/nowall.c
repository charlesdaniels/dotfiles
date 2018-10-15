#include "nowall.h"

/**
 * @brief Get the current time and run it through strftime with fmt as the
 * format string.
 *
 * https://www.tutorialspoint.com/c_standard_library/c_function_strftime.htm
 *
 * @param fmt
 *
 * @return
 */
char* get_time(char* fmt) {
	time_t rawtime;
	struct tm *info;
	char* buffer;

	buffer = (char*) malloc(NOWALL_TIMESTAMP_MAXLEN * sizeof(char));

	/* get the current time */
	time(&rawtime);
	info = localtime(&rawtime);

	strftime(buffer, NOWALL_TIMESTAMP_MAXLEN, fmt, info);

	return buffer;
}

/**
 * @brief Get current memory usage as a percentage (0 .. 1.0)
 *
 * @return
 */
double get_memory_usage() {
	/* sysconf(_SC_PAGE_SIZE); */
	return 1.0f - (1.0f * sysconf(_SC_AVPHYS_PAGES)) / (1.0f * sysconf(_SC_PHYS_PAGES));
}

/**
 * @brief Generate the message string
 *
 * @return
 */
char* generate_message() {
	char* msg;
	double load_avg[3];
	double memory_usage;
	char* timestamp;

	msg = (char*) malloc(sizeof(char) * NOWALL_MESSAGE_MAXLEN);

	/* get load average */
	getloadavg(load_avg, 3);

	/* get memory usage */
	memory_usage = get_memory_usage() * 100.0f;

	timestamp = get_time("%m-%d");

	snprintf(
			msg,
			NOWALL_MESSAGE_MAXLEN,
			"%0.2f / %0.0f%% / %s",
			load_avg[0],
			memory_usage,
			timestamp
	);

	free(timestamp);

	return msg;

}

/**
 * @brief calculate the current score for the history vector
 *
 * @return
 */
float calculate_score() {
	double load_avg[3];
	double memory_usage;

	/* get load average */
	getloadavg(load_avg, 3);

	/* get memory usage */
	memory_usage = get_memory_usage();

	/* we normalize the load average by the number of CPU cores which
	 * are online at this moment */
	return 0.5 * memory_usage + \
		0.5 * load_avg[0] / sysconf(_SC_NPROCESSORS_ONLN);
}

void draw_frame(Display* disp, int screen_num, float* history,
		XColor bg_color, XColor fg_color, XColor text_color) {

	Window root;
	Screen* screen;
	Colormap cmap;
	Pixmap pmap;
	Atom prop;
	GC gc;
	unsigned int depth;
	char* msg;
	int history_index = 0;
	double x_base, y_base, x_centered, y_centered, horizontal_pos;
	double horizontal_offset, bar_height, msg_x;
	Cursor cursor;
	struct tm *info;
	time_t rawtime;
	double clock_center_x, clock_center_y;
	double minute_hand_x, minute_hand_y, hour_hand_x, hour_hand_y;

	/* gather information about the display and screen to manipulate */
	root   = RootWindow(disp, screen_num);		/* root window      */
	screen = ScreenOfDisplay(disp, screen_num);	/* screen "object"  */
	cmap   = DefaultColormap(disp, screen_num);	/* screen color map */
	depth  = DefaultDepth(disp, screen_num);	/* screen depth     */

	/* allocate provided color values or die */
	SAFE_ALLOC_COLOR(disp, cmap, &fg_color);
	SAFE_ALLOC_COLOR(disp, cmap, &bg_color);
	SAFE_ALLOC_COLOR(disp, cmap, &text_color);

	/* create the pixmap - this serves as the intermediary between our GC
	 * and the root window */
	pmap = XCreatePixmap(
			disp,			/* display */
			root,			/* drawable */
			screen->width,		/* width */
			screen->height,		/* height */
			depth			/* depth */
	);

	/* create the graphics context for us to draw into */
	gc = XCreateGC(disp, pmap, 0, NULL);

	/* fill in the background */
	XSetForeground(disp, gc, bg_color.pixel);
	XFillRectangle(
			disp,		/* display */
			pmap,		/* drawable */
			gc,		/* graphics context */
			0,		/* x position */
			0,		/* y position */
			screen->width,	/* width */
			screen->height	/* height */
	);

	/* draw the text */
	XSetForeground(disp, gc, text_color.pixel);
	msg = generate_message();
	msg_x = screen->width / 2 - (strlen(msg) * NOWALL_HORIZ_PIX_PER_CHAR / 2);
	XDrawString(
			disp,			/* display */
			pmap,			/* drawable */
			gc,			/* graphics context */
			msg_x,			/* x position */
			screen->height / 1.8,	/* y position */
			msg,			/* string */
			strlen(msg)		/* string length */
	);
	free(msg);

	/* draw the history visualization */
	XSetForeground(disp, gc, fg_color.pixel);
	for (history_index = 0;
		history_index < NOWALL_HISTORY_LEN;
		history_index ++) {

		/* note that x, y identifies the upper left of the rectangle */

		horizontal_pos = history_index - (NOWALL_HISTORY_LEN / 2);
		horizontal_offset = \
			horizontal_pos * (NOWALL_HISTORY_BAR_WIDTH + \
					NOWALL_HISTORY_BAR_SEP);
		x_base = screen->width / 2 + horizontal_offset;
		y_base = screen->height / 2.2;
		bar_height = screen->height * 0.1 * history[history_index];
		x_centered = x_base + NOWALL_HISTORY_BAR_WIDTH / 2;
		y_centered = y_base - bar_height / 2;


		XFillRectangle(
				disp,		/* display */
				pmap,		/* drawable */
				gc,		/* graphics context */
				x_centered,	/* x position */
				y_centered,	/* y position */
				NOWALL_HISTORY_BAR_WIDTH,	/* width */
				bar_height	/* height */
		);
	}

	/* draw the clock */

	/* get the current time */
	time(&rawtime);
	info = localtime(&rawtime);

	/* clock center */
	clock_center_x = screen->width / 2.0f;
	clock_center_y = screen->height / 4.0f;

	/* hour hand */
	hour_hand_x = clock_center_x + HOUR_HAND_LENGTH * sin(
			((12 - (info->tm_hour % 12)) / 12.0f) * 2 * 3.14159 - 3.14159 );
	hour_hand_y = clock_center_y + HOUR_HAND_LENGTH * cos(
			((12 - (info->tm_hour % 12)) / 12.0f) * 2 * 3.14159 - 3.14159 );
	XDrawLine(
			disp,		/* display */
			pmap,		/* drawable */
			gc,		/* graphics context */
			clock_center_x,	/* x1 */
			clock_center_y, /* y1 */
			hour_hand_x,	/* x2 */
			hour_hand_y	/* y2 */
	);

	/* minute hand */
	minute_hand_x = clock_center_x + MINUTE_HAND_LENGTH * sin(
			((60 - info->tm_min) / 60.0f) * 2 * 3.14159 - 3.14159 );
	minute_hand_y = clock_center_y + MINUTE_HAND_LENGTH * cos(
			((60 - info->tm_min) / 60.0f) * 2 * 3.14159 - 3.14159 );
	XDrawLine(
			disp,		/* display */
			pmap,		/* drawable */
			gc,		/* graphics context */
			clock_center_x,	/* x1 */
			clock_center_y, /* y1 */
			minute_hand_x,	/* x2 */
			minute_hand_y	/* y2 */
	);


	/* setup the cursor settings */
	cursor = XCreateFontCursor(disp, XC_top_left_arrow);
	XDefineCursor(disp, root, cursor);

	/* set the root window background to what we just drew */
	XSetWindowBackgroundPixmap(disp, root, pmap);

	/* do the right magic to keep what we draw persistent even after
	 * we exit */
	prop = XInternAtom(disp, "_XROOTPMAP_ID", False);
	XChangeProperty(
			disp,				/* display    */
			root,				/* window     */
			prop,				/* properties */
			XA_PIXMAP,			/* type       */
			32,				/* format     */
			PropModeReplace,		/* mode       */
			(unsigned char *) &pmap,	/* data       */
			1				/* nelements  */
	);

	/* tidy up */
	XFreeGC(disp, gc);
	XClearWindow(disp, root);
	XSetCloseDownMode(disp, RetainPermanent);


}

int main(void) {
	Display *dpy;
	int screen;
	XColor bg_color;
	XColor fg_color;
	XColor text_color;
	float history[NOWALL_HISTORY_LEN];
	int history_index;

	/* detect xorg information */
	dpy = XOpenDisplay(NULL);
	if (!dpy) {
		fprintf(stderr, "failed to open display!\n");
		exit (2);
	}
	screen = DefaultScreen(dpy);

	/* setup colors */
	bg_color.red   = 0 << 8;
	bg_color.blue  = 0 << 8;
	bg_color.green = 0 << 8;

	text_color.red   = 128 << 8;
	text_color.blue  = 128 << 8;
	text_color.green = 128 << 8;

	fg_color.red   = 128 << 8;
	fg_color.blue  = 128 << 8;
	fg_color.green = 128 << 8;

	/* initialize the history vector */
	for (history_index = 0 ;
		history_index < NOWALL_HISTORY_LEN;
		history_index ++) {
		history[history_index] = 0;
	}

	while (1) {
		/* update history vector */
		history[NOWALL_HISTORY_LEN-1] = calculate_score();
		for (history_index = 0 ;
			history_index < (NOWALL_HISTORY_LEN - 1);
			history_index ++) {
			history[history_index] = history[history_index + 1];
		}

		/* update rendering */
		draw_frame(dpy, screen, history,
			bg_color, fg_color, text_color);

		sleep(NOWALL_INTERVAL);
	}

	XCloseDisplay(dpy);

	return 0;
}
