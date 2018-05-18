#!/bin/bash
#定义巡检的硬盘盘符
declare -A map=(["c"]="" ["d"]="" ["e"]="" ["f"]="" ["g"]="" ["h"]="")
#硬盘休眠标志
diskStandby=0
while true
do
    time=$(date)
    #硬盘正在工作标志
    flag=0
    #清空目前进行工作输出文件
    > runningJob.txt
    #在for中填写需要检测的硬盘盘符
    for var in c d e f g h 
    do
        #硬盘物理分区
        diskLable="$var"1
        #获取当前操作硬盘的任务信息
        job=`lsof /dev/sd"$diskLable"`
        #将正在进行的工作状态输出到runningJob.txt
        lsof /dev/sd"$diskLable">>runningJob.txt
        #如果有程序正在操作硬盘
        if [ -n "$job" ];
        then
            #重置标志位
            flag=1
            diskStandby=0
            #如果目前进行的工作与map中存储的上一个工作不一致，说明有新的任务对硬盘进行读写
            if [ "${map["$var"]}" != "$job" ];
            then
                #更新map信息
                map["$var"]=$job
                #输出新的工作信息 
                echo  "${time}">>diskStatus.txt
                echo  "/dev/sd"$var" is running">>diskStatus.txt
                lsof /dev/sd"$diskLable">>diskStatus.txt
            fi
        #如果硬盘休眠标志位为0 并且目前进行的工作与map中存储的上一个工作不一致（此时没有程序读写硬盘）
        elif [ $diskStandby -eq "0" ] && [ "${map["$var"]}" != "$job" ];
        then     
            #更新map信息
            map["$var"]=$job 
            #输出硬盘无工作即将休眠
            echo  "${time}">>diskStatus.txt
            echo  "/dev/sd"$var" is running">>diskStatus.txt
            echo  "not working standby soon">>diskStatus.txt              
        fi
    done
    #如果硬盘休眠标志位为0 且 硬盘工作标志位为0
    if [ $diskStandby -eq 0 ] && [ $flag -eq 0 ];
    then 
        #硬盘正在运转标志位
        isRunning=0
        #睡眠40S 避免使用 hdparm -C 命令过于频繁
        sleep 40
        #使用hdparm -C 命令检测硬盘是否在旋转
        for var in c d e h 
        do
            diskStatus=`hdparm -C /dev/sd"$var"|grep standby`
	        #如果硬盘旋转将硬盘正在标志位置1
            if [ -z "$diskStatus" ];
	        then 
		        isRunning=1
            fi
        done
        #若硬盘正在旋转标志位为0	
        if [ $isRunning -eq 0 ];
        then
            #输出全部硬盘以休眠
            echo  "${time}">>diskStatus.txt
            echo  -e "all disk is standby\n">>diskStatus.txt
            diskStandby=1
        fi
    fi
    #休眠20s 
    sleep 20
done