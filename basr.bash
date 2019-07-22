#!/bin/bash

# A version of "bas.bash" using run-as <package>.
function basr() {

    declare -ri NUM_ARGS=2

    if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then

	echo "Usage: basr <package> <path> [options...]"
	echo ""
	echo "Arguments:"
	echo " <package>          The package to start from"
	echo " <path>             The path to the .db file"
	echo ""
	echo "Options:"
	echo " -d, <device>       Specifies the device/emulator to target"
	echo " -t, <table>        Specifies the table to perform subsequent actions on"
	echo " -s,                Prints the schema of the table; requires -t"
	echo " -c,                Deletes all rows in the table; requires -t"
	echo " -a,                Prints all tables in the database"
	echo " -p,                Prints all rows in the table; requires -t"
	echo " --destroy,         Deletes the <path> file."

	return 0
    fi

    if [ $# -lt $NUM_ARGS ]; then 
	echo "basr: try 'basr -h' or 'basr --help' for more information"
	return 1
    fi

    if [ $# -le $NUM_ARGS ]; then 
	echo "basr: no default behaviour without any options"
	return 0
    fi
    
    declare ARG_PACKAGE=$1
    declare ARG_PATH=$2

    declare HAS_D_FLAG="false"
    declare D_FLAG=""
    declare HAS_T_FLAG="false"
    declare T_FLAG=""
    declare HAS_S_FLAG="false"
    declare HAS_C_FLAG="false"
    declare HAS_A_FLAG="false"
    declare HAS_P_FLAG="false"
    declare HAS_DESTROY_FLAG="false"

    declare -i I=3
    while [ $I -le $# ]; do
	case ${!I} in
	    "-d")
		I=I+1
		HAS_D_FLAG="true"
		D_FLAG=${!I}
		;;
	    "-t")
		I=I+1
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
		echo "warning: "${!I}" does not match any supported flags"
		;;
	esac
	I=I+1
    done

    if [ "${HAS_D_FLAG}" == "true" ] && [ "${D_FLAG}" == "" ]; then
	echo "error: missing -d argument"
	return 1
    fi

    if [ "${HAS_T_FLAG}" == "true" ] && [ "${T_FLAG}" == "" ]; then
	echo "error: missing -t argument"
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
	echo "error: -t option is required for the specified options"
	return 1
    fi

    declare COMMAND="adb shell run-as ${ARG_PACKAGE}"
    if [ "${HAS_D_FLAG}" == "true" ]; then
	COMMAND="adb -s ${D_FLAG} shell run-as ${ARG_PACKAGE}"
    fi

    if [ "${HAS_S_FLAG}" == "true" ]; then
	${COMMAND} "sqlite3 ${ARG_PATH} .schema ${T_FLAG}"
    fi

    if [ "${HAS_P_FLAG}" == "true" ]; then
	${COMMAND} "sqlite3 ${ARG_PATH} 'SELECT * FROM ${T_FLAG};'"
    fi

    if [ "${HAS_C_FLAG}" == "true" ]; then
	${COMMAND} "sqlite3 ${ARG_PATH} 'DELETE FROM ${T_FLAG};'"
	echo "info: table was cleared"
    fi

    if [ "${HAS_A_FLAG}" == "true" ]; then
	${COMMAND} "sqlite3 ${ARG_PATH} .tables"
    fi

    if [ "${HAS_DESTROY_FLAG}" == "true" ]; then
	${COMMAND} "rm ${ARG_PATH}"
	echo "info: database was destroyed"
    fi

    return 0
}