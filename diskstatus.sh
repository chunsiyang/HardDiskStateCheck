#!/bin/bash
flag=0
for var in c d e f g h 
do	
	diskStatus=`hdparm -C /dev/sd"$var"|grep standby`
	if [ -z "$diskStatus" ];
	then 
		flag=1
		echo "/dev/sd"$var" is running"
		temp="$var"1
		work=`lsof /dev/sd"$temp"`
		if [ -z "$work" ];
		then
			echo "not working standby soon"
		else 
			lsof /dev/sd"$temp"
		fi
	fi 
done
if [ $flag -eq "0" ];
then 
	echo "all disk is standby"
fi
