#ifndef FASTABR_H
#define FASTABR_H

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

char* fastabr(char* path);
void set_home(char* path);
void display_help(void);
int main(int argc, char** argv);

#endif
