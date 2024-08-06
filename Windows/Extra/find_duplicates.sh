#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename=$1

if [ ! -r "$filename" ]; then
    echo "Error: File '$filename' not found or not readable."
    exit 1
fi

awk 'BEGIN { red = "\033[0;31m"; green = "\033[0;32m"; yellow = "\033[0;33m"; nc = "\033[0m" }
{
    if (length($0) > 0) {
        if (!seen[$0]++) {
            print
        }
        count[$0]++
        lines[$0] = lines[$0] ? lines[$0] "," NR : NR
    } else {
        print
    }
}
END {
    for (line in count) {
        if (count[line] > 1) {
            printf "%s%d duplicate(s)%s of: %s\"%s\"%s found at line(s): %s%s%s\n", red, count[line]-1, nc, green, line, nc, yellow, lines[line], nc > "/dev/stderr"
        }
    }
}' "$filename" >temp_file && mv temp_file "$filename"
