arc=$(uname -a)
pcpu=$(lscpu | awk '$1 == "CPU(s):" {print $2}')
vcpu=$(nproc --all)
tmem=$(free -m | awk '$1 == "Mem:" {print $2}')
umem=$(free -m | awk '$1 == "Mem:" {print $3}')
porcmem=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
tdisk=$(df -Bg | grep '^/dev' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
udisk=$(df -Bm | grep '^/dev' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
porcdisk=$(df -Bm | grep '^/dev' | grep -v '/boot$' | awk '{ft += $2} {ut += $3} END {printf("%.2f"), ut/ft*100}')
lcpu=$(top -bn1 | sed "1,7d" | awk '{n += $9} END {print n}')
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')
lvmcheck=$(lsblk | grep "lvm" | wc -l)
lvm=$(if [$lvmcheck -eq 0]; then echo no; else echo yes; fi)
tcp=$(ss -s | awk '$1 == "TCP:" {print $4}' | tr -d ",")
users=$(users | wc -w)
ip=$(hostname -I)
MAC=$(ip link show | awk '$1 == "link/ether" {print $2}')
sudo=$(cat /var/log/sudo/logs | grep "COMMAND" | wc -l)
wall "  #Architecture: $arc
        #CPU physical: $pcpu
        #vCPU: $vcpu
        #Memory Usage: $umem/${tmem}MB ($porcmem%)
        #Disk Usage: $udisk/${tdisk}Gb ($porcdisk%)
        #CPU load: $lcpu%
        #Last boot: $lb
        #LVM use: $lvm
        #TCP: $tcp ESTABLISHED
        #User log: $users
        #Network IP: $ip ($MAC)
        #Sudo: $sudo cmd
"
