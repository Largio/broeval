#!/bin/bash
if [[ $# -ne 2 ]]
then
echo "Usage: ./idsstat.sh <MACHINE><IDS>"
echo "Collects statistics on IDS on the given machine (specified by IP address or hostname)"
exit
fi

MACHINE=$1
IDS=$2

# Note: To enable automatic SSH login execute on the source machine:
# ssh-keygen -t rsa -b 4096 (Enter, Enter, Enter)
# ssh-copy-id $MACHINE

# Note: To enable sudo w/o password execute on the target machine:
# sudo visudo
# And add the following line at the end (without #):
# %sudo ALL=(ALL:ALL) NOPASSWD:   /usr/local/bro/bin/bro * 


#Add IPs of used VMs into helpers/VMs.txt
if grep -q -x $MACHINE ~/broeval/helpers/VMs.txt;
then
MACHINEFINAL="ubuntu@$MACHINE"
#Add IPs of physical machines into helpers/Physicals.txt
elif grep -q -x $MACHINE ~/broeval/helpers/Physicals.txt;
then
MACHINEFINAL=$MACHINE
else 
echo "Entered \"IP\" not specified in helpers/VMs.txt or helpers/Physicals.txt" 
MACHINEFINAL=$MACHINE
exit 1
fi

#pidstat -r page faults and memory utilization, -u cpu utilization, -h all results hotizotal in 1 line
#pidstat -C only tasks with command name including "^bro$", displays 1 report every 1 second interval.
#tail -n 1 only last 1 line, tr -s " " combine many same characters and replace by " ".
#cut -d " " -f 8,13 delimiter " " (read until next " "), and -f 8,13 only 1st and 13th position.

if [ $IDS == 'bro' ]; 
then
while :
do
ssh $MACHINEFINAL 'pidstat -ruh -p `pgrep "^bro$"` 1 1 | tail -n 1 | tr -s " " | cut -d " " -f 8,13'
done
elif [ $IDS == 'snort' ]; 
then
while :
do
ssh $MACHINEFINAL 'pidstat -ruh -p `pgrep "^snort$"` 1 1 | tail -n 1 | tr -s " " | cut -d " " -f 8,13'
done
else
echo "Please specify IDS (2nd)Parameter"
exit 1
fi
