#!/bin/sh
# init.d/oas-init.sh
#

case "$1" in
    start)
    su - oracle -c "/opt/oracle/bin/oasctl infra start"
    su - oracle -c "/opt/oracle/bin/oasctl oas start"
	;;
    stop)
	  su - oracle -c "/opt/oracle/bin/oasctl oas stop"
	  su - oracle -c "/opt/oracle/bin/oasctl infra stop"
	;;
    *)
	echo "Usage: $0 {start|stop}"
	exit 1
	;;
esac
