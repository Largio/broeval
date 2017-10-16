#!/bin/bash
if [[ $# -ne 5 ]]
then
echo "Usage: ./par.sh <SOURCE> <TARGET> <ITER> <SIZE> <MODE>"
echo "Times an ftp transfer of data."
exit
fi

SOURCE=$1
TARGET=$2
ITER=$3
SIZE=$4 
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
ssh $SOURCEFINAL "/usr/bin/time -f \"%e\" bash -c \"seq $ITER | parallel -n0 curl -s ftp://$TARGET/$SIZE.txt > /dev/null\""
elif [ $MODE == 'seq' ]; 
then
ssh $SOURCEFINAL "/usr/bin/time -f \"%e\" bash -c \"for i in {1..$ITER}; do curl -s ftp://$TARGET/$SIZE.txt > /dev/null; done\""
else
echo "Please specify MODE (5th)Parameter"
fi
