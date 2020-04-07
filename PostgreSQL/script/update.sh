#!/bin/bash

PSQL=`which psql`
PGPASSWORD="<password>"
HOST="<hostname>"
USER="<username>"
DBNAME="<database>"

for i in cod_tom-*.sql; do
echo "$i :"
echo 
$PSQL -h $HOST -U $USER -d $DBNAME -f $i
echo
done
