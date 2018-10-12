#ifndef NOWALL_H
#define NOWALL_H

/* #define _POSIX_C_SOURCE 200112L */
#define _DEFAULT_SOURCE 1

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#define SAFE_ALLOC_COLOR(disp, cmap, color) \
	if (XAllocColor(disp, cmap, color) == 0) { \
		fprintf(stderr, "FATAL: failed to allocate color\n"); \
		exit(1); \
	}

#define NOWALL_TIMESTAMP_MAXLEN 128
#define NOWALL_MESSAGE_MAXLEN 512
#define NOWALL_HISTORY_LEN 25
#define NOWALL_HISTORY_BAR_WIDTH 1
#define NOWALL_HISTORY_BAR_SEP 18
#define NOWALL_HORIZ_PIX_PER_CHAR 6
#define NOWALL_INTERVAL 5

char* get_time(char* fmt);
double get_memory_usage();
char* generate_message();
float calculate_score();
void draw_frame(Display* disp, int screen_num, float* history,
		XColor bg_color, XColor fg_color, XColor text_color);
int main(void);

#endif
