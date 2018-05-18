#!/bin/bash
flag=0
time=$(date)
echo -e "\n${time}">>diskStatus.txt
for var in c d e h 
do	
	diskStatus=`hdparm -C /dev/sd"$var"|grep standby`
	if [ -z "$diskStatus" ];
	then 
		flag=1
		echo  "/dev/sd"$var" is running">>diskStatus.txt
		temp="$var"1
		work=`lsof /dev/sd"$temp"`
		if [ -z "$work" ];
		then
			echo  "not working standby soon">>diskStatus.txt
		else 
			lsof /dev/sd"$temp">>diskStatus.txt
		fi
	fi 
done
if [ $flag -eq "0" ];
then 
	echo  "all disk is standby">>diskStatus.txt
fi
