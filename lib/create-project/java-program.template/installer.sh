#!/bin/sh
printf "INFO: creating project file... "
PROJECT_NAME="$1"
AUTHOR_NAME="$2"
MAIN_FILE="$PROJECT_NAME"
echo "public class $MAIN_FILE {" > "$MAIN_FILE.java"
cat main_file.java >> "$MAIN_FILE.java"
rm main_file.java
echo "DONE"

printf "INFO: generating makefile... "
echo "MAIN_FILE=$MAIN_FILE" > Makefile
cat Makefile.tmp >> Makefile
rm Makefile.tmp
echo "DONE"
exit 0