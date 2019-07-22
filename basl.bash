#!/bin/bash

# A version of "bas.bash" running locally as read-only.
function basl() {

    if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then

	echo "Usage: basl <package> <r_path> <l_path> <file> [options...]"
	echo ""
	echo "Arguments:"
	echo " <package>          The package of the application"
	echo " <r_path>           The path to the folder with <file> on the device"
	echo " <l_path>           The path to the folder to store <file> locally"
	echo " <file>             The name of the db file"
	echo ""
	echo "Options:"
	echo " -d, <device>       Specifies the device/emulator to target"
	echo " -t, <table>        Specifies the table to perform subsequent actions on"
	echo " -s,                Prints the schema of the table; requires -t"
	echo " -a,                Prints all tables in the database"
	echo " -p,                Prints all rows in the table; requires -t"
	echo " -u,                Cleans up afterwards, delets any downloaded files"
	return 1
    fi

    if [ $# -lt 4 ]; then 
	echo "basl: try 'basl -h' or 'basl --help' for more information"
	return 1
    fi


    declare PACKAGE=$1
    declare DB_R_PATH=$2
    declare DB_L_PATH=$3
    declare DB_FILE=$4

    declare HAS_D_FLAG="false"
    declare D_FLAG=""
    declare HAS_T_FLAG="false"
    declare T_FLAG=""
    declare HAS_S_FLAG="false"
    declare HAS_A_FLAG="false"
    declare HAS_P_FLAG="false"
    declare HAS_U_FLAG="false"

    declare -i I=5
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
	    "-a")
		HAS_A_FLAG="true"
		;;
	    "-p")
		HAS_P_FLAG="true"
		;;
	    "-u")
		HAS_U_FLAG="true"
		;;
	    *)
		echo "warning: "${!I}" does not match any supported flags."
		;;
	esac
	I=I+1
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

    declare COMMAND="adb"
    if [ "${HAS_D_FLAG}" == "true" ]; then
	COMMAND="adb -s "${D_FLAG}
    fi
    
    declare R_FILE=$DB_R_PATH$DB_FILE
    declare L_FILE=$DB_L_PATH$DB_FILE
    declare R_SHM_FILE=$DB_R_PATH$DB_FILE"-shm"
    declare L_SHM_FILE=$DB_L_PATH$DB_FILE"-shm"
    declare R_WAL_FILE=$DB_R_PATH$DB_FILE"-wal"
    declare L_WAL_FILE=$DB_L_PATH$DB_FILE"-wal"
    
    ${COMMAND} shell "run-as $PACKAGE cat "$R_FILE > $L_FILE
    ${COMMAND} shell "run-as $PACKAGE cat "$R_SHM_FILE > $L_SHM_FILE
    ${COMMAND} shell "run-as $PACKAGE cat "$R_WAL_FILE > $L_WAL_FILE

    if [ "${HAS_S_FLAG}" == "true" ]; then
	sqlite3 ${DB_L_PATH} .schema ${T_FLAG}
    fi

    if [ "${HAS_P_FLAG}" == "true" ]; then
        sqlite3 ${L_FILE} "SELECT * FROM ${T_FLAG};"
    fi

    if [ "${HAS_A_FLAG}" == "true" ]; then
	sqlite3 ${L_FILE} .tables
    fi
    
    if [ "${HAS_U_FLAG}" == "true" ]; then
	rm $L_FILE $L_SHM_FILE $L_WAL_FILE 2>/dev/null	
	echo "info: cleaned up"
    fi

    return 0
}