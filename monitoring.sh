#!/bin/bash

#ARCHITECHTURE OF OS AND ITS KERNEL VERSION
arch=$(uname -a)

#NUMBER OF PHYSICAL PROCESSORS
pcpu=$(grep "physical id" /proc/cpuinfo | wc -l)

#NUMBER OF VIRTUAL PROCESSORS
vcpu=$(grep "processor" /proc/cpuinfo | wc -l)

#CURRENT AVAILABLE RAM AND ITS UTILIZATION
total_ram=$(free --mega | awk '$1 == "Mem:" {print $2}')
used_ram=$(free --mega | awk '$1 == "Mem:" {print $3}')
ram_use=$(free --mega | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

#CURRENT AVAILABLE MEMORY AND ITS UTILIZATION
tdisk=$(df -BG | grep "^/dev/" | grep -v "/boot" | awk '{total += $2} END {print total}')
udisk=$(df -m | grep '^/dev/' | grep -v '/boot$' | awk '{used += $3} END {print used}')
pdisk=$(df -m | grep '^/dev/' | grep -v '/boot$' | awk '{used += $3} {total += $2} END {printf("%d"), used/total*100}')

#CURRENT UTILIZATION OF PROCESSORS
cpu_load=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')

#DATE AND TIME OF LAST REBOOT
last_boot=$(who -b | cut -c 23-)

#LVM ACTIVITY
lvm_use=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)

#ACTIVE CONNECTIONS
tcp_con=$(ss -ta | grep ESTAB | wc -l)

#USERS ON SERVER
users_logged=$(users | wc -w)

#IPv4 ADDRESS AND ITS MAC ADDRESS
ip=$(hostname -I)
mac=$(ip link | grep ether | cut -c 16-32)

#NUMBER OF COMMANDS EXECUTED WITH THE SUDO PROGRAM
sucom=$(journalctl _COMM=sudo | grep COMMAND | wc -l)


wall "	#Architechture: $arch
	#CPU physical : $pcpu
	#vCPU : $vcpu
	#Memory Usage: $used_ram/${total_ram}MB ($ram_use%)
	#Disk Usage: $udisk/${tdisk}Gb ($pdisk%)
	#CPU load: $cpu_load
	#Last boot: $last_boot
	#LVM use: $lvm_use
	#Connections TCP : $tcp_con ESTABLISHED
	#User log: $users_logged
	#Network: IP $ip ($mac)
	#Sudo : $sucom cmd
	"
