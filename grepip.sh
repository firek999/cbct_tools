#!/bin/bash
rm -rf ./grepip.txt
for i in `cat allip.txt`
do
  grep $i ./adminip.txt

    if [ $? == 1 ]; then
       echo $i >> ./grepip.txt
    fi

done
