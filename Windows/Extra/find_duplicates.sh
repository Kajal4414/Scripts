#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename=$1

if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' not found."
    exit 1
fi

# Using awk to find and count duplicate lines
awk '{ count[$0]++ } END { for(line in count) if(count[line] > 1) print line }' "$filename"
