#!/bin/bash

function bas() {

    if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then

	echo "Usage: bas <path> [options...]"
	echo ""
	echo "Arguments:"
	echo " <path>             The path to the .db file"
	echo ""
	echo "Options:"
	echo " -d, <device>       Specifies the device/emulator to target"
	echo " -t, <table>        Specifies the table to perform subsequent actions on"
	echo " -s,                Prints the schema of the table; requires -t"
	echo " -c,                Deletes all rows in the table; requires -t"
	echo " -a,                Prints all tables in the database"
	echo " -p,                Prints all rows in the table; requires -t"
	echo " --destroy,         Deletes everything, all files"

	return 1
    fi

    if [ $# -lt 1 ]; then 
	echo "bas: try 'bas -h' or 'bas --help' for more information"
	return 1
    fi

    declare DB_PATH=$1

    declare HAS_D_FLAG="false"
    declare D_FLAG=""
    declare HAS_T_FLAG="false"
    declare T_FLAG=""
    declare HAS_S_FLAG="false"
    declare HAS_C_FLAG="false"
    declare HAS_A_FLAG="false"
    declare HAS_P_FLAG="false"
    declare HAS_DESTROY_FLAG="false"

    declare I="2"
    while [ $I -le $# ]; do
	case ${!I} in
	    "-d")
		I=$[$I + 1]
		HAS_D_FLAG="true"
		D_FLAG=${!I}
		;;
	    "-t")
		I=$[$I + 1]
		HAS_T_FLAG="true"
		T_FLAG=${!I}
		;;
	    "-s")
		HAS_S_FLAG="true"
		;;
	    "-c")
		HAS_C_FLAG="true"
		;;
	    "-a")
		HAS_A_FLAG="true"
		;;
	    "-p")
		HAS_P_FLAG="true"
		;;
	    "--destroy")
		HAS_DESTROY_FLAG="true"
		;;
	    *)
		echo "warning: "${!I}" does not match any supported flags."
		;;
	esac
	I=$[$I + 1]
    done

    if [ "${HAS_D_FLAG}" == "true" ] && [ "${D_FLAG}" == "" ]; then
	echo "error: no device was given"
	return 1
    fi

    if [ "${HAS_T_FLAG}" == "true" ] && [ "${T_FLAG}" == "" ]; then
	echo "error: no table was given"
	return 1
    fi
    
    declare REQUIRES_T_FLAG="false"

    if [ "${HAS_S_FLAG}" == "true" ]; then
	REQUIRES_T_FLAG="true"
    elif [ "${HAS_C_FLAG}" == "true" ]; then
	REQUIRES_T_FLAG="true"
    elif [ "${HAS_P_FLAG}" == "true" ]; then
	REQUIRES_T_FLAG="true"
    fi

    if [ "${REQUIRES_T_FLAG}" == "true" ] && [ "${HAS_T_FLAG}" == "false" ]; then
	echo "error: -t flag is missing"
	return 1
    fi

    declare COMMAND="adb shell"
    if [ "${HAS_D_FLAG}" == "true" ]; then
	COMMAND="adb -s ${D_FLAG} shell"
    fi

    if [ "${HAS_S_FLAG}" == "true" ]; then
	${COMMAND} "sqlite3 "${DB_PATH}" .schema ${T_FLAG}"
    fi

    if [ "${HAS_P_FLAG}" == "true" ]; then
	${COMMAND} "sqlite3 "${DB_PATH}" 'SELECT * FROM ${T_FLAG};'"
    fi

    if [ "${HAS_C_FLAG}" == "true" ]; then
	${COMMAND} "sqlite3 "${DB_PATH}" 'DELETE FROM ${T_FLAG};'"
	echo "info: table was cleared"
    fi

    if [ "${HAS_A_FLAG}" == "true" ]; then
	${COMMAND} "sqlite3 "${DB_PATH}" .tables"
    fi

    if [ "${HAS_DESTROY_FLAG}" == "true" ]; then
	${COMMAND} "rm -rf "${DB_PATH}
	echo "info: database was destroyed"
    fi

    return 0
}