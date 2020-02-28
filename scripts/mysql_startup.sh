#!/bin/bash

service sequoiasql-mysql start

sleep 1

if [[ ! -f /.init_done ]]
then
  apt install netcat  -y > /dev/null
  sleep 1
fi

while ! nc -z $COORD_IP $COORD_PORT &>/dev/null
do
  echo ">>> Waiting for COORD node to come up at ($COORD_IP:$COORD_PORT)..."
  sleep 5
done
echo "Successfully reached COORD node at ($COORD_IP:$COORD_PORT)"
sleep 1

if [[ ! -f /.init_done ]]
then
  sed -i 's/PROCESS_WAIT_TIME=.*/PROCESS_WAIT_TIME=60/'  /opt/sequoiasql/mysql/bin/sdb_sql_ctl
  INIT_COMMAND="/init.sh --port=$MYSQL_PORT --coord=${COORD_IP}:${COORD_PORT}"
  echo "COMMAND: $INIT_COMMAND"
  $INIT_COMMAND
  RV=$?
  echo "Init command returned: $RV"
  touch /.init_done
else
  /opt/sequoiasql/mysql/bin/sdb_sql_ctl startall
  echo "MySql instance is started"
fi

# sleep indefinitely
while true; do sleep 1000000; done
