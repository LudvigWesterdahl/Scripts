#!/bin/bash

readonly PROG_PATH=${0}
readonly PROG_DIR=${0%/*}
readonly PROG_NAME=$(basename $0)

print_usage() {

    echo "Usage: ${PROG_NAME} <path> [options...]"
    echo
    echo "Arguments:"
    echo " <path>             The path to the .db file"
    echo
    echo "Options:"
    echo " -d, <device>       Specifies the device/emulator to target"
    echo " -t, <table>        Specifies the table to perform subsequent actions on"
    echo " -s,                Prints the schema of the table; requires -t"
    echo " -c,                Deletes all rows in the table; requires -t"
    echo " -a,                Prints all tables in the database"
    echo " -p,                Prints all rows in the table; requires -t"
    echo " --destroy,         Deletes everything, all files"
    
    return 0
}

main() {

    declare -ri NUM_ARGS=1

    if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
	print_usage
	return 1
    fi

    if [ $# -lt ${NUM_ARGS} ]; then 
	echo "${PROG_NAME}: try '${PROG_NAME} -h' or '${PROG_NAME} --help' for more information"
	return 1
    fi

    if [ $# -le ${NUM_ARGS} ]; then 
	echo "${PROG_NAME}: no default behaviour without any options"
	return 0
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
		echo "${PROG_NAME}: "${!I}" does not match any supported flags."
		;;
	esac
	I=$[$I + 1]
    done

    if [ "${HAS_D_FLAG}" == "true" ] && [ "${D_FLAG}" == "" ]; then
	echo "${PROG_NAME}: no device was given"
	return 1
    fi

    if [ "${HAS_T_FLAG}" == "true" ] && [ "${T_FLAG}" == "" ]; then
	echo "${PROG_NAME}: no table was given"
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
	echo "${PROG_NAME}: -t flag is missing"
	return 1
    fi

    declare COMMAND="adb shell"
    if [ "${HAS_D_FLAG}" == "true" ]; then
	COMMAND="adb -s ${D_FLAG} shell"
    fi

    if [ "${HAS_S_FLAG}" == "true" ]; then
	${COMMAND} "sqlite3 ${DB_PATH} '.schema ${T_FLAG}'"
    fi

    if [ "${HAS_P_FLAG}" == "true" ]; then
	${COMMAND} "sqlite3 ${DB_PATH} 'SELECT * FROM ${T_FLAG};'"
    fi

    if [ "${HAS_C_FLAG}" == "true" ]; then
	${COMMAND} "sqlite3 ${DB_PATH} 'DELETE FROM ${T_FLAG};'"
	echo "${PROG_NAME}: table was cleared"
    fi

    if [ "${HAS_A_FLAG}" == "true" ]; then
	${COMMAND} "sqlite3 ${DB_PATH} '.tables'"
    fi

    if [ "${HAS_DESTROY_FLAG}" == "true" ]; then
	${COMMAND} "rm -rf ${DB_PATH}"
	echo "${PROG_NAME}: database was destroyed"
    fi

    return 0
}

main "${@}"