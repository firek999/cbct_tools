#!/bin/bash
delname=$1
for i in `cat ip.txt`
do
ssh  $i "userdel -r $delname"
done
