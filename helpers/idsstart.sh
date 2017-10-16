#!/bin/bash
if [ $# -lt 3 ] || [ $# -gt 4 ]
then
echo "Usage: ./snortstart.sh <MACHINE><IDS><IDSMODE> (OPTIONAL:)<Outfile>"
echo "Starts IDS on the given machine (specified by IP address or hostname) and creates Log-Dir and IDS-Summary-File"
echo "if outfile parameter is not set the Summary part is bypassed (e.g.for simple use of just the idskill.sh helper)"
echo "3rd param activates IDS summary and has to provide path and filename(will still be altered)."
exit
fi

MACHINE=$1
IDS=$2
IDSMODE=$3
OUTFILE=$4
: ${OUTFILE:=default}

# Note: To enable automatic SSH login execute on the source machine:
# ssh-keygen -t rsa -b 4096 (Enter, Enter, Enter)
# ssh-copy-id $MACHINE

# Note: To enable sudo w/o password execute on the target machine:
# sudo visudo
# And add the following line at the end (without #):
# %sudo ALL=(ALL:ALL) NOPASSWD:   /usr/local/bro/bin/bro *
# %sudo ALL=(ALL:ALL) NOPASSWD:   /usr/local/bin/snort * 


#Add IPs of used VMs into helpers/VMs.txt
if grep -q -x $MACHINE ~/broeval/helpers/VMs.txt;
then
MACHINEFINAL="ubuntu@$MACHINE"
# Change the network interface here if necessary:
# e.g. in my setting it is enp0s8 when using Vagrant VMs and enp0s25 without Vagrant
INTERFACE="enp0s8"
#Add IPs of physical machines into helpers/Physicals.txt
elif grep -q -x $MACHINE ~/broeval/helpers/Physicals.txt;
then
MACHINEFINAL=$MACHINE
# Change the network interface here if necessary:
# e.g. in my setting it is enp0s8 when using Vagrant VMs and enp0s25 without Vagrant
INTERFACE="enp0s25"
else 
echo "Entered \"IP\" not specified in helpers/VMs.txt or helpers/Physicals.txt" 
MACHINEFINAL=$MACHINE
INTERFACE="enp0s25"
exit 1
fi

if [[ $IDS == 'bro' ]]; 
then
ssh $MACHINEFINAL "mkdir -p ~/${IDS}log; sudo rm -r ~/${IDS}log/*; cd ~/${IDS}log; nohup sudo /usr/local/bro/bin/bro -i $INTERFACE $IDS$IDSMODE > /dev/null 2> /dev/null < /dev/null &"
if ! [[ $OUTFILE == 'default' ]];
then
: > ${OUTFILE}'-SUMMARY''-'${IDS};
fi
echo "Enabled $IDS on $MACHINE at the network interface $INTERFACE."
echo "Please ensure this is the right interface, e.g. by running ifconfig"
echo "and change the file 'helpers/idsstart.sh' accordingly."
sleep 10
elif [[ $IDS == 'snort' ]]; 
then	#default log (if not specified via e.g. -l ./log) is stored at /var/log/snort
		#-h argument is used to give a relation to how to put the log
ssh $MACHINEFINAL "mkdir -p ~/${IDS}log; sudo rm -r ~/${IDS}log/*; cd ~/${IDS}log; nohup sudo /usr/local/bin/snort -i ${INTERFACE} -d -l ~/${IDS}log -h 10.0.0.0/24 -c /etc/snort/$IDS$IDSMODE.conf > /dev/null 2> /dev/null < /dev/null &"
if ! [[ $OUTFILE == 'default' ]];
then
: |> ${OUTFILE}'-SUMMARY''-'${IDS};
fi
echo "Enabled $IDS on $MACHINE at the network interface $INTERFACE."
echo "Please ensure this is the right interface, e.g. by running ifconfig"
echo "and change the file 'helpers/idsstart.sh' accordingly."
sleep 15
else
echo "Please specify IDS (2nd)Parameter"
exit 1
fi
