#!/bin/bash
if [[ $# -ne 5 ]]
then
echo "Usage: ./icmp.sh <SOURCE> <TARGET> <ITER> <SIZE> <MODE>"
echo "par Times an icmp flood attack for \$iter * 10 milliseconds. seq pings sequentially \$iter-times(waits for response)"
exit
fi

SOURCE=$1
TARGET=$2
ITER=$3
SIZE=$(echo "10^$4" | bc)
MODE=$5

#Add IPs of used VMs into helpers/VMs.txt
if grep -q -x $SOURCE ~/broeval/helpers/VMs.txt;
then
SOURCEFINAL="ubuntu@$SOURCE"
#Add IPs of physical machines into helpers/Physicals.txt
elif grep -q -x $SOURCE ~/broeval/helpers/Physicals.txt;
then
SOURCEFINAL=$SOURCE
else 
echo "Entered \"IP\" not specified in helpers/VMs.txt or helpers/Physicals.txt" 
SOURCEFINAL=$SOURCE
exit 1
fi
if [ $MODE == 'par' ]; 
then					
#HPING3 used as ICMP Traffic generator. -1 = icmp mode, --faster = 100 packets/sec, -q = quiet, -c = packet count....parallel issues a flood attack without waiting, sequential issues single pings
ssh $SOURCEFINAL "/usr/bin/time -f \"%e\" sudo timeout --preserve-status -s KILL $(($ITER/100)) bash -c \"sudo hping3 -1 --flood -q $TARGET > /dev/null\""
elif [ $MODE == 'seq' ]; 
then
ssh $SOURCEFINAL "/usr/bin/time -f \"%e\" bash -c \"for i in {1..$ITER}; do sudo hping3 -1 --fast -q -c 1 $TARGET > /dev/null; done\""
else
echo "Please specify MODE (5th)Parameter"
fi
