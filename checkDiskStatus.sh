#!/bin/bash
declare -A map=(["c"]="" ["d"]="" ["e"]="" ["h"]="")
using=0
while true
do
    time=$(date)
    for var in c d e h 
    do	
        diskStatus=`hdparm -C /dev/sd"$var"|grep standby`
        if [ -z "$diskStatus" ];
        then 
            using=0
            temp="$var"1
            work=`lsof /dev/sd"$temp"`
            if [ "${map["$var"]}" != "$work" ];
            then
                map["$var"]=$work                
                if [ -z "$work" ];
                then 
                    echo  "${time}">>diskStatus.txt
                    echo  "/dev/sd"$var" is running">>diskStatus.txt
                    echo  "not working standby soon">>diskStatus.txt
                else
                    echo  "${time}">>diskStatus.txt
                    echo  "/dev/sd"$var" is running">>diskStatus.txt
                    lsof /dev/sd"$temp">>diskStatus.txt
                fi
            fi
        fi 
    done
    if [ $using -eq 0 ];
    then
        flag=0
        for var in c d e h 
        do
            diskStatus=`hdparm -C /dev/sd"$var"|grep standby`
            if [ -z "$diskStatus" ];
            then 
                flag=1
            fi    
        done
        if [ $flag=0 ];
        then 
            echo  "${time}">>diskStatus.txt
            echo  -e "all disk is standby\n">>diskStatus.txt
            using=1
        fi
    fi
    sleep 20
done

