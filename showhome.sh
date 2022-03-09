#!/bin/bash

for i in `cat ip.txt`
do
host=`ssh $i "hostname"`
echo "show all $host home directory:"&& ssh $i "ls /home"
echo -e "\n\n"

done
