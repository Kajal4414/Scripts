#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename=$1

# Check if the file exists and is readable
if [ ! -r "$filename" ]; then
    echo "Error: File '$filename' not found or not readable."
    exit 1
fi

# Using awk to find and count duplicate lines along with their line numbers
awk '
{
    if (length($0) > 0) {
        count[$0]++
        lines[$0] = lines[$0] ? lines[$0] "," NR : NR
    }
}
END {
    for (line in count) {
        if (count[line] > 1) {
            print count[line] " duplicates of: \"" line "\" at lines: " lines[line]
        }
    }
}' "$filename"
