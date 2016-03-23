#!/bin/bash

PID=`cat /var/run/unicorn.pid`
if ! kill -s USR2 $PID
then
	sv restart unicorn
else
	(sleep 10 && kill -s QUIT $PID) &
fi