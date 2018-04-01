#!/bin/sh

while read date; do 
    date -d@$date '+%F %T'
done
