#!/bin/bash

function bas() {
    if [ $# -le 1 ] || [ ${1} == "-h" ] || [ ${1} == "--help" ]; then

	echo "Usage: bas <path> [options...]"
	echo ""
	echo "<package>     The path to the .db file"
	echo ""
	echo "Options:"
	echo " -d,          The device, required if multiple emulators/devices are connected"
	echo " -t,          Specifies the table to perform subsequent actions on"
	echo " -s,          Prints the schema of the table. Requires -t flag"
	echo " -c,          Deletes all rows in the table. Requires -t flag"
	echo " -a,          Prints all tables in the database"
	echo " -p,          Prints all rows in the table. Requires -t flag"
	echo " --destroy,   Deletes everything, all files"
	return 1
    fi

    PATH=$1
    HAS_D_FLAG="false"
    D_FLAG=""
    HAS_T_FLAG="false"
    T_FLAG=""
    HAS_S_FLAG="false"
    HAS_C_FLAG="false"
    HAS_A_FLAG="false"
    HAS_P_FLAG="false"
    HAS_DESTROY_FLAG="false"

    I="2"
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
	    "*")
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
    
    REQUIRES_T_FLAG="false"

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

    COMMAND="adb shell"
    if [ "${HAS_D_FLAG}" == "true" ]; then
	COMMAND="adb -s ${D_FLAG} shell"
    fi

    if [ "${HAS_S_FLAG}" == "true" ]; then
	${COMMAND} "sqlite3 ${PATH} .schema ${TABLE}"
    fi

    if [ "${HAS_P_FLAG}" == "true" ]; then
	${COMMAND} "sqlite3 ${PATH} 'SELECT * FROM ${T_FLAG};'"
    fi

    if [ "${HAS_C_FLAG}" == "true" ]; then
	${COMMAND} "sqlite3 ${PATH} 'DELETE FROM ${T_FLAG};'"
	echo "info: table was cleared"
    fi

    if [ "${HAS_A_FLAG}" == "true" ]; then
	${COMMAND} "sqlite3 ${PATH} .tables"
    fi

    if [ "${HAS_DESTROY_FLAG}" == "true" ]; then
	${COMMAND} "rm -rf ${PATH}"
	echo "info: database was destroyed"
    fi

    return 0
}