#!/bin/bash
echo > all.log
echo > timegrep.log
time1=$1
#time2=$2
for i in `cat ip.txt`
do
scp ${i}:/var/log/nginx/access.log ./${i}.log
cat ${i}.log >> all.log
done

#grep -v "192.144.193" all.log |grep -E "2020:14|2020:15|2020:16|2020:17|2020:18|2020:19" >>timegrep.log
grep -v "192.144.193" all.log  >>timegrep.log
awk '{a[$1]+=1;}END{for(i in a){print a[i]" " i;}}' timegrep.log |sort -rg > sortip.txt
head -100 sortip.txt |awk '{print $NF}' > allip.txt
