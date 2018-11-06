#include "fastabr.h"

char* fastabr(char* path) {
	char* abr;
	char* ptr;
	char* ap;
	char* prev;

	if (((abr  = (char*) calloc(PATH_MAX, sizeof(char))) == NULL) ||
	    ((prev = (char*) calloc(PATH_MAX, sizeof(char))) == NULL)   ) {
		err(1, "calloc()");
	}

	memset(abr, '\0', PATH_MAX);
	memset(prev, '\0', PATH_MAX);

	/* we will advance ptr through the string abr - this is cleaner than
	 * using [] notation, since ptr is also guaranteed to be a valid string
	 * */
	ptr = abr;

	/* read until we're out of data in the input string */
	while((ap = strsep(&path, PATHSEP)) != NULL) {
		/* field is empty, ignore it */
		if (*ap == '\0') { continue; }

		/* insert separator */
		*ptr = PATHSEP[0]; ptr++;

		/*  copy at least the first character of the input, possibly
		 *  more (until we hit something not a . - this makes dot-dirs
		 *  look right, as opposed to just showing up as /./ */
		do { *ptr = *ap; ap++; ptr++; } while (*(ap-1) == '.');

		/* We want to keep a copy of the previous path element, since
		 * if we end on the next iteration, ap will be NULL */
		strlcpy(prev, ap, PATH_MAX);
	}

	/* copy the full text of the last (non-NULL) field */
	while (*prev != '\0') { *ptr = *prev ; prev++; ptr++; }

	/* handle case where output path is relative to ~ by stripping the
	 * leading separator */
	if (abr[1] == '~') { abr++;}

	return abr;
}

void set_home(char* path) {
	char* homedir;
	char* rcursor;
	char* wcursor;
	size_t homelen;


	if ((homedir = getenv("HOME")) == NULL) {
		homedir = getpwuid(getuid())->pw_dir;
	}
	homelen = strnlen(homedir, PATH_MAX);

	if (strnlen(path, PATH_MAX) < homelen) {
		return;
	}

	if (strncmp(path, homedir, homelen) != 0) {
		return;
	}

	/* path to user home is present, overwrite with ~ */

	/* shift everything in path over to account for ~ being shorter
	 * than homelen */
	wcursor = path;
	*wcursor = '~'; wcursor++;
	rcursor = path + homelen;

	while (*rcursor != '\0') {
		*wcursor = *rcursor;
		wcursor ++; rcursor++;
	}

	/* null terminate */
	*wcursor = '\0';

}

void display_help(void) {
	printf("fastabr [-vHhn] [-p PATH]");
}

int main(int argc, char** argv) {
	char* path;
	char* normalized;
	int c, option_index;
	int flag_disable_home, flag_disable_normalize, flag_version, flag_help;

	flag_disable_home = 0;
	flag_disable_normalize = 0;
	flag_version = 0;
	flag_help = 0;

	if (((path = (char*) calloc(PATH_MAX, sizeof(char))) == NULL)) {
		err(1, "calloc()");
	}
	memset(path, '\0', PATH_MAX);

	if (((normalized = (char*) calloc(PATH_MAX, sizeof(char))) == NULL)) {
		err(1, "calloc()");
	}

	while (1) {
		struct option long_options[] = {
			{"disable-home"      , no_argument       , &flag_disable_home      , 1  },
			{"disable-normalize" , no_argument       , &flag_disable_normalize , 1  },
			{"version"           , no_argument       , &flag_version           , 1  },
			{"help"              , no_argument       , &flag_help              , 1  },
			{"path"              , required_argument , 0                       , 'p'},
			{0, 0, 0, 0}
		};

		option_index = 0;

		c = getopt_long (argc, argv, "vhHnp:",
				long_options, &option_index);

		/* Detect the end of the options. */
		if (c == -1)
			break;

		switch (c) {
			case 0:
				/* If this option set a flag, do nothing else now. */
				if (long_options[option_index].flag != 0)
					break;
				break;

			case 'p':
				strlcpy(path, optarg, PATH_MAX);
				break;

			case 'h':
				flag_disable_home = 1;
				break;

			case 'n':
				flag_disable_normalize = 1;

			case 'v':
				flag_version = 1;

			case 'H':
				flag_help = 1;

			case '?':
				/* getopt_long already printed an error message. */
				break;

			default:
				abort ();
		}
	}

	if (flag_version == 1) {
		printf(FASTABR_VERSION);
		printf("\n");
		return 0;
	}

	if (flag_help == 1) {
		display_help();
		return 0;
	}

	/* path was not specified, use cwd */
	if (strlen(path) == 0) {
		getcwd(path, PATH_MAX);
	}

	/* normalize path */
	if (flag_disable_normalize != 1) {
		if (realpath(path, normalized) == NULL) {
			err(1, "realpath()");
		}
	} else {
		strlcpy(normalized, path, PATH_MAX);
	}

	/* strip home and replace with ~ */
	if (flag_disable_home != 1) {
		set_home(normalized);
	}

	printf("%s\n", fastabr(normalized));

	return 0;

}
