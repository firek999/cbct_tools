#!/bin/bash
lastday=`date -d"$(date -d"1 month" +"%Y%m01") -1 day" +"%Y%m%d"`
firstday=`date -d"$(date -d "today" +"%Y%m01")" +"%w"`
echo "last:$lastday"
echo "${lastday:0-2}"
wnu=`echo "${lastday:0-2}/7" |bc`
mo=`echo "${lastday:0-2}%7" |bc`
ifday=$firstday


#数据库配置(已脱敏)
HOSTNAME="172.30.xx.xx"  #数据库信息
HOSTNAME2="172.30.xx.xx"
PORT="3306"
USERNAME="yunwei_rw"
PASSWORD="xxpasswdxx"
DBNAME="xxxxx"  #数据库名称
DBNAME2="xxxxxxx"

mysql -u $USERNAME -p$PASSWORD -h $HOSTNAME $DBNAME<<EOF |awk -v OFS="," '{print $0}'|tail -n +2  > ./program_time.csv 2>>./error.log
 SELECT programme_id,
        start_time,
        end_time,
        week,
        round(((SUBSTR(end_time,1,2)-SUBSTR(start_time,1,2))*60+(SUBSTR(end_time,4,2)-SUBSTR(start_time,4,2)))/60,2) time
 from big_area_programme_time
 where programme_id in (SELECT id
                        FROM big_area_programme
                        WHERE category = 1
                        AND is_del = 0
                        AND audit = 1)
EOF

#8进制计算
#echo "ibase=10;obase=7;12" | bc





monday=$wnu
tuesday=$wnu
wednesday=$wnu
thursday=$wnu
friday=$wnu
saturday=$wnu
sunday=$wnu

#echo "$monday,$tuesday,$wednesday,$thursday,$friday,$saturday,$sunday"
echo "mo:$mo"
#echo "ifday:$ifday"

while ((mo>0))
do
if [ $ifday == 0 ];then
((sunday++))
ifday=`echo "ibase=10;obase=7;$ifday+1" | bc |sed 's/\(.*\)\(.\)$/\2/'`
elif [ $ifday == 1 ];then
((monday++))
ifday=`echo "ibase=10;obase=7;$ifday+1" | bc |sed 's/\(.*\)\(.\)$/\2/'`
elif [ $ifday == 2 ];then
((tuesday++))
ifday=`echo "ibase=10;obase=7;$ifday+1" | bc |sed 's/\(.*\)\(.\)$/\2/'`
elif [ $ifday == 3 ];then
((wednesday++))
ifday=`echo "ibase=10;obase=7;$ifday+1" | bc |sed 's/\(.*\)\(.\)$/\2/'`
elif [ $ifday == 4 ];then
((thursday++))
ifday=`echo "ibase=10;obase=7;$ifday+1" | bc |sed 's/\(.*\)\(.\)$/\2/'`
elif [ $ifday == 5 ];then
((friday++))
echo $firday
ifday=`echo "ibase=10;obase=7;$ifday+1" | bc |sed 's/\(.*\)\(.\)$/\2/'`
elif [ $ifday == 6 ];then
((saturday++))
ifday=`echo "ibase=10;obase=7;$ifday+1" | bc |sed 's/\(.*\)\(.\)$/\2/'`
fi
#echo $mo
let mo-=1
done
echo "本月有$monday个星期一"
echo "本月有$tuesday个星期二"
echo "本月有$wednesday个星期三"
echo "本月有$thursday个星期四"
echo "本月有$friday个星期五"
echo "本月有$saturday个星期六"
echo "本月有$sunday个星期日"

awk '{if($4==0){print $1","$2","$3",星期天,"$5*"'$sunday'"}else if($4==1){print $1","$2","$3",星期一,"$5*"'$monday'"}else if($4==2){print $1","$2","$3",星期二,"$5*"'$tuesday'"}else if($4==3){print $1","$2","$3",星期三,"$5*"'$wednesday'"}else if ($4==4){print $1","$2","$3",星期四,"$5*"'$thursday'"}else if ($4==5){print $1","$2","$3",星期五,"$5*"'$friday'"}else if ($4==6){print $1","$2","$3",星期六,"$5*"'$saturday'"}}' program_time.csv > program_timex.csv

cat program_timex.csv |awk -F ',' 'BEGIN{print "节目ID,预计节目当月开播时长"}{a[$1]+=$5}END{for(i in a) printf "%s,%0.2f\n",i,a[i]}' > timedone.csv


iconv  -f utf-8 -t GB18030 timedone.csv -o "./yuebao/202101月报.csv"
echo "详情见附件" | mail -v -s "202101月报数据" -a "./yuebao/202101月报.csv" xxxxx@xx.com,sunfei@xxx.xxx