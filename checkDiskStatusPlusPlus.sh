#!/bin/bash
declare -A map=(["c"]="" ["d"]="" ["e"]="" ["f"]="" ["g"]="" ["h"]="")
diskStandby=0
while true
do
    time=$(date)
    flag=0
    for var in c d e f g h 
    do
        diskLable="$var"1
        job=`lsof /dev/sd"$diskLable"`
        if [ -n "$job" ];
        then
            flag=1
            diskStandby=0
            if [ "${map["$var"]}" != "$job" ];
            then
                map["$var"]=$job 
                echo  "${time}">>diskStatus.txt
                echo  "/dev/sd"$var" is running">>diskStatus.txt
                lsof /dev/sd"$diskLable">>diskStatus.txt
            fi
        elif [ $diskStandby -eq "0" ] && [ "${map["$var"]}" != "$job" ];
        then     
            map["$var"]=$job 
            echo  "${time}">>diskStatus.txt
            echo  "/dev/sd"$var" is running">>diskStatus.txt
            echo  "not working standby soon">>diskStatus.txt              
        fi
    done
    if [ $diskStandby -eq 0 ] && [ $flag -eq 0 ];
    then 
        isRunning=0
        sleep 40
        for var in c d e h 
        do
            diskStatus=`hdparm -C /dev/sd"$var"|grep standby`
	        if [ -z "$diskStatus" ];
	        then 
		        isRunning=1
            fi
        done	
        if [ $isRunning -eq 0 ];
        then
            echo  "${time}">>diskStatus.txt
            echo  -e "all disk is standby\n">>diskStatus.txt
            diskStandby=1
        fi
    fi
    sleep 20
done