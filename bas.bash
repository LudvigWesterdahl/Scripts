#!/bin/bash

# Dumps all rows from table "merchant"
function basm() {
    bas com.datategy.octomobile merchant
}

# Dumps all rows from table "salesman"
function bass() {
    bas com.datategy.octomobile salesman
}

# Dumps all rows from table "voucher"
function basv() {
    bas com.datategy.octomobile voucher emulator-5554
}

function bas() {
    if [ $# -ne 2 ] && [ $# -ne 3 ]; then
	echo "######################"
	echo "Browse Android Sqlite3"
	echo "######################"
	echo ""
	echo "Usage: bas <package> <table> <device (optional)>"
	echo "<device> is only required if multiple devices exist."
	echo "Check the possible devices by running: adb devices"
	echo ""

	return 1
    fi

    PACKAGE=$1
    TABLE=$2
    DEVICE=$3
    COMMAND="adb shell"

    if [ $# -eq 3 ]; then
	COMMAND="adb -s ${DEVICE} shell"
    fi
    
    ${COMMAND} "sqlite3 /data/data/"${PACKAGE}"/databases/db 'select * from ${TABLE};'"
}