#!/bin/sh
# where $1 ids the first parameter passed to the script
# in case either nothing or what
if [-z $1]
then
    echo "I CHANGED SOMETHING"
    exit
else
    echo "I FAILED"
fi