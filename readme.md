README
===========================
本脚本用来为OMV等运行linux系统的nas提供硬盘活动检测记录

****
	
|Author|chunsiyang|
|---|---
|E-mail|chunsi.yang@gmail.com

##版本说明
|文件名|说明|
|----|-----|
|diskstatus.sh|运行脚本可获得当前的硬盘运行状态并输出正在读写硬盘的作业|
|checkDisk.sh|运行脚本检测硬盘运行状态和正在读写硬盘的操作，并将结果输出到diskStatus.txt中|
|checkDiskStatus.sh|checkDisk.sh的全自动版本，不在需要添加到计划任务|
|checkDiskStatusPlus.sh|checkDiskStatusPlus.sh的代码优化版本|
|checkDiskStatusPlusPlus.sh|更改了巡检逻辑使读取硬盘信息操作减少|
|checkDiskStatusSharp.sh|增加一个目前正在进行的任务输出存放在runningJob.txt文件中|

###使用方法
        cd 到脚本所在目录
        nohup ./checkDiskStatusSharp.sh &