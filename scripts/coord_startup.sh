#!/bin/bash

service sdbcm start

if [[ ! -f /.init_done ]]
then
  sleep  5
  INIT_COMMAND="/init.sh --coord=$COORD --catalog=$CATALOG --data=$DATA"
  echo "COMMAND: $INIT_COMMAND"
  $INIT_COMMAND
  RV=$?
  if [[ $RV -eq 2 ]]; then
    echo "ERROR: Failed to SDB Cluster, error"
  else
    echo "SDB Cluster successfully created."
  fi

  touch /.init_done
fi

# sleep indefinitely
while true; do sleep 1000000; done
