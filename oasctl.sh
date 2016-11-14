#!/bin/sh
# This script covers the oas, infra, grid and oai
# You must have an enviroment script called
# <target>.env for each tartget you want to
# administrate, e.g.  oas.env and infra.env

# Setting local enviroment variables
TARGET=$1
ACTION=$2
CDIR=$PWD; export CDIR
# This must point to the directory where you have
# oasctl and your enviroment scripts
# This directory should also be in path
SDIR=/opt/oracle/bin; export SDIR

# Building functions
show_help() {
	echo "Usage:   $0 oas|infra|omr|oms|oma|ocsapps|ocsinfra|db start|stop|status"
	echo "Example: oasctl oas status"
}

cleanup() {
	. $SDIR/$TARGET.env
	ps -ef | grep "$ORACLE_HOME" | sed "s/  */ /g" | cut -d ' ' -f2 | while read pid; do
  	echo "killing $pid"
  	kill -9 $pid
	done
}

start_oms() {
	echo "Starting Oracle 10g Management Server OPMN processes"
	opmnctl startall
	echo "Starting Oracle 10g Application Server Control"
	emctl start iasconsole
}

stop_oms() {
	echo "Stopping Oracle 10g Application Server Control"
	emctl stop iasconsole
	echo "Stopping Oracle 10g Management Server OPMN processes"
	opmnctl stopall
#	cleanup
}

status_oms() {
	echo "Status Oracle 10g Application Server Control"
	emctl status iasconsole
	echo "Status Oracle 10g Management Server OPMN processes"
	opmnctl status
}

start_omr() {
	echo "Starting TNS Listener"
	lsnrctl start
	echo "Starting Repository database"
	sqlplus "/ as sysdba" << EOF
startup
exit
EOF
}

stop_omr() {
	echo "Stopping Repository database"
	sqlplus "/ as sysdba" << EOF
shutdown immediate
exit
EOF
	echo "Stopping TNS Listener"
	lsnrctl stop
}

status_omr() {
	echo "Status TNS Listener"
	lsnrctl status
	echo "Status Repository Database"
	sqlplus "/ as sysdba" << EOF
select instance,status,open_time from v\$thread;
select * from v\$version;
exit
EOF
}

start_oma() {
	echo "Starting Management Agent"
	emctl start agent
}

stop_oma() {
	echo "Stopping Management Agent"
	emctl stop agent
}

status_oma() {
	echo "Status Management Agent"
	emctl status agent
}

start_oas() {
	echo "Starting Oracle 10g Application Server OPMN processes"
	opmnctl startall
	echo "Starting Oracle 10g Application Server Control"
	emctl start iasconsole
}

stop_oas() {
	echo "Stopping Oracle 10g Application Server Control"
	emctl stop iasconsole
	echo "Stopping Oracle 10g Application Server OPMN processes"
	opmnctl stopall
#	cleanup
}

status_oas() {
	echo "Status Oracle 10g Application Server Control"
	emctl status iasconsole
	echo "Status Oracle 10g Application Server OPMN processes"
	opmnctl status
}

start_db() {
	echo "Starting TNS Listener"
	lsnrctl start
	echo "Starting Infrastructure database"
	sqlplus "/ as sysdba" << EOF
startup
exit
EOF
}

stop_db() {
	echo "Stopping Infrastructure database"
	sqlplus "/ as sysdba" << EOF
shutdown immediate
exit
EOF
	echo "Stopping TNS Listener"
	lsnrctl stop
}

status_db() {
	echo "Status TNS Listener"
	lsnrctl status
	echo "Status Infrastructure Database"
	sqlplus "/ as sysdba" << EOF
select instance,status,open_time from v\$thread;
select * from v\$version;
exit
EOF
}

start_infra() {
	echo "Starting TNS Listener"
	lsnrctl start
	echo "Starting Infrastructure database"
	sqlplus "/ as sysdba" << EOF
startup
exit
EOF
  sleep 30
	echo "Starting Oracle 10g Application Server OPMN processes"
	opmnctl startall
	echo "Starting Oracle 10g Application Server Control"
	emctl start iasconsole
}

stop_infra() {
  echo "Stopping Oracle 10g Application Server Control"
	emctl stop iasconsole
	echo "Stopping Oracle 10g Application Server OPMN processes"
	opmnctl stopall
	sleep 30
	echo "Stopping Infrastructure database"
	sqlplus "/ as sysdba" << EOF
shutdown immediate
exit
EOF
	echo "Stopping TNS Listener"
	lsnrctl stop
}

status_infra() {
	echo "Status TNS Listener"
	lsnrctl status
	echo "Status Infrastructure Database"
	sqlplus "/ as sysdba" << EOF
select instance,status,open_time from v\$thread;
select * from v\$version;
exit
EOF
  echo "Status Oracle 10g Application Server Control"
	emctl status iasconsole
	echo "Status Oracle 10g Application Server OPMN processes"
	opmnctl status
}

start_ocsapps() {
	echo "Starting Oracle 10g OCS OPMN processes"
	opmnctl startall
	echo "Starting Oracle 10g OCS Control"
	emctl start iasconsole
	echo "Starting OCAS"
	$ORACLE_HOME/ocas/bin/ocasctl -start
	$ORACLE_HOME/ocas/bin/ocasctl -start -t ochecklet
}

stop_ocsapps() {
	echo "Stopping Oracle 10g OCS Control"
	emctl stop iasconsole
	echo "Stopping OCAS"
	$ORACLE_HOME/ocas/bin/ocasctl -stopall
	echo "Stopping Oracle 10g OCS OPMN processes"
	opmnctl stopall
	cleanup
}

status_ocsapps() {
	echo "Status Oracle 10g OCS Control"
	emctl status iasconsole
	echo "Status OCAS"
	$ORACLE_HOME/ocas/bin/ocasctl -status
	echo "Status Oracle 10g OCS OPMN processes"
	opmnctl status
	echo "Status LISTENER_ES"
	lsnrctl status listener_es
}

start_ocsinfra() {
	echo "Starting TNS Listener"
	lsnrctl start
	echo "Starting Infrastructure database"
	sqlplus "/ as sysdba" << EOF
startup
exit
EOF
  sleep 30
	echo "Starting OCS DBConsole"
	emctl start dbconsole
	echo "Starting Oracle 10g OCS OPMN processes"
	opmnctl startall
	echo "Starting Oracle 10g OCS Control"
	emctl start iasconsole
}

stop_ocsinfra() {
  echo "Stopping Oracle 10g Application Server Control"
	emctl stop iasconsole
	echo "Stopping OCS DBConsole"
	emctl stop dbconsole
	echo "Stopping Oracle 10g Application Server OPMN processes"
	opmnctl stopall
	sleep 30
	echo "Stopping Infrastructure database"
	sqlplus "/ as sysdba" << EOF
shutdown immediate
exit
EOF
	echo "Stopping TNS Listener"
	lsnrctl stop
}

status_ocsinfra() {
	echo "Status TNS Listener"
	lsnrctl status
	echo "Status Infrastructure Database"
	sqlplus "/ as sysdba" << EOF
select instance,status,open_time from v\$thread;
select * from v\$version;
exit
EOF
  echo "Status Oracle 10g Application Server Control"
	emctl status iasconsole
	echo "Status OCS DBConsole"
	emctl status dbconsole
	echo "Status Oracle 10g Application Server OPMN processes"
	opmnctl status
}

case "$TARGET" in
	omr|oms|oma|oas|db|infra|ocsapps|ocsinfra)
	;;
	*)
		show_help
		exit 1
	;;
esac

case "$ACTION" in
	start|stop|status)
	;;
	*)
		show_help
		exit 1
	;;
esac

case "$TARGET" in
	"oas")
		. $SDIR/oas.env
		case "$ACTION" in
			"start")
				start_oas
			;;
			"stop")
				stop_oas
			;;
			"status")
				status_oas
			;;
		esac
	;;
	"db")
		. $SDIR/db.env
		case "$ACTION" in
			"start")
				start_db
			;;
			"stop")
				stop_db
			;;
			"status")
				status_db
			;;
		esac
	;;
	"infra")
		. $SDIR/infra.env
		case "$ACTION" in
			"start")
				start_infra
			;;
			"stop")
				stop_infra
			;;
			"status")
				status_infra
			;;
		esac
	;;
	"ocsapps")
		. $SDIR/ocsapps.env
		case "$ACTION" in
			"start")
				start_ocsapps
			;;
			"stop")
				stop_ocsapps
			;;
			"status")
				status_ocsapps
			;;
		esac
	;;
	"ocsinfra")
		. $SDIR/ocsinfra.env
		case "$ACTION" in
			"start")
				start_ocsinfra
			;;
			"stop")
				stop_ocsinfra
			;;
			"status")
				status_ocsinfra
			;;
		esac
	;;
	"omr")
		. $SDIR/omr.env
		case "$ACTION" in
			"start")
				start_omr
			;;
			"stop")
				stop_omr
			;;
			"status")
				status_omr
			;;
		esac
	;;
	"oms")
		. $SDIR/oms.env
		case "$ACTION" in
			"start")
				start_oms
			;;
			"stop")
				stop_oms
			;;
			"status")
				status_oms
			;;
		esac
	;;
	"oma")
		. $SDIR/oma.env
		case "$ACTION" in
			"start")
				start_oma
			;;
			"stop")
				stop_oma
			;;
			"status")
				status_oma
			;;
		esac
	;;
esac
