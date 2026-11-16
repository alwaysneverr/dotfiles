#!/bin/sh
f="$HOME/.config/themes/current/quotes.txt"
if [ -s "$f" ]; then shuf -n1 "$f" | fold -s -w 46; else echo "welcome back, $USER"; fi
