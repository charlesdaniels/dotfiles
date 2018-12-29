#ifndef FASTABR_H
#define FASTABR_H

/* Make glibc on Linux give us the non-broken strsep(). */
#define _BSD_SOURCE /* for glibc < 2.19 */
#define _DEFAULT_SOURCE /* for glibc >= 2.19 */

#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <limits.h>
#include <err.h>
#include <stdio.h>
#include <sys/types.h>
#include <pwd.h>
#include <getopt.h>

#define PATHSEP "/"
#define FASTABR_VERSION "0.0.1"

#ifdef __linux__
#include <linux/limits.h>
#include <bsd/string.h>
#endif

char* fastabr(char* path);
void set_home(char* path);
void display_help(void);
int main(int argc, char** argv);

#endif
