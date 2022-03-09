#!/bin/bash
CountDate=`date -d yesterday +%Y-%m-%d`
Data=`echo "hlen bbs:statisticsTemp:$CountDate:app:uv" | /usr/bin/redis-cli -h '172.30.xx.xx' -p 6379 -a 'xxxpasswdxxxx'`
echo $CountDate
echo $Data
