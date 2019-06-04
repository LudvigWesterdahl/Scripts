#!/bin/bash

function rename() {
    if [ $# -ne 3 ]; then
	echo "rename <path> <search string> <replace string>"
	return 1
    fi


    SEARCH_PATH=$1
    SEARCH=$2
    REPLACE=$3

    find ${SEARCH_PATH} -type f -name "*${SEARCH}*" | while read FILENAME ; do
	NEW_FILENAME="$(echo ${FILENAME} | sed -e "s/${SEARCH}/${REPLACE}/g")";
	mv "${FILENAME}" "${NEW_FILENAME}";
    done

    return 0
}