#!/bin/bash

if [ $# -lt 2 ] || [ $# -gt 3 ]
then
echo "Usage: ./idskill.sh <MACHINE><IDS> (OPTIONAL:) <Outfile>"
echo "Kills IDS on the given machine (specified by IP address or hostname and ids name) and writes IDS-Summary"
echo "if outfile parameter is not set the Summary part is bypassed (e.g.for simple use of just the idskill.sh helper)"
echo "3rd param activates IDS summary and has to provide path and filename(will still be altered)."
exit
fi

MACHINE=$1
IDS=$2
OUTFILE=$3
: ${OUTFILE:=default}

# Note: To enable automatic SSH login execute on the source machine:
# ssh-keygen -t rsa -b 4096 (Enter, Enter, Enter)
# ssh-copy-id $MACHINE

# Note: To enable sudo w/o password execute on the target machine:
# sudo visudo
# And add the following line at the end (without #):
# %sudo ALL=(ALL:ALL) NOPASSWD:   /usr/bin/killall /usr/local/bro/bin/bro
# %sudo ALL=(ALL:ALL) NOPASSWD:   /usr/bin/killall /usr/local/bin/snort

#Add IPs of used VMs into helpers/VMs.txt
if grep -q -x $MACHINE ~/broeval/helpers/VMs.txt;
then
MACHINEFINAL="ubuntu@$MACHINE"
USR="ubuntu"
#Add IPs of physical machines into helpers/Physicals.txt
elif grep -q -x $MACHINE ~/broeval/helpers/Physicals.txt;
then
MACHINEFINAL=$MACHINE
USR="jan"
else 
echo "Entered \"IP\" not specified in helpers/VMs.txt or helpers/Physicals.txt" 
MACHINEFINAL=$MACHINE
exit 1
fi

if [[ $IDS == 'bro' ]]; 
then
ssh $MACHINEFINAL 'sudo /usr/bin/killall /usr/local/bro/bin/bro'
if ! [[ $OUTFILE == 'default' ]];
then
sleep 3
echo "....................MACHINE: $MACHINE" >> ${OUTFILE}'-SUMMARY''-'${IDS};
ssh $MACHINEFINAL "sudo chown -R ${USR} ~/${IDS}log/*"
ssh $MACHINEFINAL "find ~/${IDS}log/ -maxdepth 1 -name \"reporter.log\" -exec cat {} \;" >> ${OUTFILE}'-SUMMARY''-'${IDS};
ssh $MACHINEFINAL "echo \"signatures.log Linecount:\"" >> ${OUTFILE}'-SUMMARY''-'${IDS};
ssh $MACHINEFINAL "find ~/brolog/ -maxdepth 1 -name \"signatures.log\" | xargs wc -l" >> ${OUTFILE}'-SUMMARY''-'${IDS};
fi
elif [[ $IDS == 'snort' ]]; 
then
ssh $MACHINEFINAL 'sudo /usr/bin/killall /usr/local/bin/snort'
if ! [[ $OUTFILE == 'default' ]];
then
sleep 3
echo "....................MACHINE: $MACHINE" >> ${OUTFILE}'-SUMMARY''-'${IDS};
ssh $MACHINEFINAL "sudo chown -R ${USR} ~/${IDS}log/*"
ssh $MACHINEFINAL "find ~/${IDS}log/ -maxdepth 1 -name \"rulesummary-*\" -exec cat {} \;" >> ${OUTFILE}'-SUMMARY''-'${IDS};
ssh $MACHINEFINAL "find ~/${IDS}log/ -maxdepth 1 -name \"preprocsummary-*\" -exec cat {} \;" >> ${OUTFILE}'-SUMMARY''-'${IDS};
fi
else
echo "Please specify IDS (2nd)Parameter"
fi
