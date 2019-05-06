#!/bin/bash

function swap() {
    if [ $# -ne 2 ]; then
	echo "swap <file 1> <file 2>"
	return 1
    fi
    

    FIRST=$1
    SECOND=$2
    TEMP="TEMP"
    
    mv ${FIRST} ${TEMP}
    mv ${SECOND} ${FIRST}
    mv ${TEMP} ${SECOND}
    return 0
}