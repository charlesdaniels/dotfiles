#!/bin/bash
# generate a password of five random words
shuf --random-source=/dev/urandom -n 5 $HOME/lib/words | tr '\n' ' ';echo""