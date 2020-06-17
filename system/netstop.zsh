#!/bin/zsh

function netstop() {
    PID=$(lsof -i :$1 -t)
    if [ -z "$PID" ]
  	then
    	echo "This port is not used. Exiting..."
    else
        echo "Stopping pid $PID"
    	kill -9 $PID
	fi
}