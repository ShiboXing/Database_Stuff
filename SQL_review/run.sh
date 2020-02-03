#!/bin/bash

if [[ -z $1 ]]; then
	echo "Usage: $0 pittid"
	exit
fi

rlwrap sqlplus $1 @run.sql
