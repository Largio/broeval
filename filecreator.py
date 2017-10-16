#!/usr/bin/env python

import sys
import imp
import os
import math

# 0 Argument is expected
def main():
    if len(sys.argv) != 1:
        print 'No argument expected.'

        return
# Type of Protocol (Available atm: http, ssl, ftp, mysql, icmp)
protocols = ('http', 'ssl', 'ftp', 'mysql', 'icmp')
# IDS MODE (Available atm: noids, min, max, prot1) noids=No IDS Loaded, min=Minimum config of IDS Rules, max= all IDS Rules, prot#=Protocol Specific Ruleset
idsmo = ('noids', 'min', 'max', 'prot1')
####################################################################################
#######################Variables in this box need to be set#########################
#Number of sources (atm used: "8s-4t" and "1s-1t")
num_sources = 1
#Number of targets
num_targets = 1
# IDS NAME. HAS TO BE EITHER 'snort' or 'bro'
ids_name = 'bro'
####################################################################################
fn = './runall'+ids_name+'-src'+str(num_sources)+'-tgt'+str(num_targets)+'.sh'
f2 = open(fn,"w+")
f2.write("#!/bin/bash\n")
f2.write("\necho \"Please edit this file and uncomment the experiments you intended to run.\"\n\n")
for index, prot in enumerate(protocols):
	for ind, idsmode in enumerate(idsmo):
		########################In Testbed Version 2 not needed to be changed manually###################
		if idsmode == 'prot1':
		    idsmode = protocol
	#	#ids is either 'ids' or 'noids' and just determines if any ids is enabled or not
	#	ids = 'ids'
		# Size of the file to be downloaded from target (in Bytes * 10^SIZE) [e.g. 10^5=100000/1000=100kb]
		size = 4
		#mode is either 'par' or  'seq' (for parallel or sequential)
		mode = 'par'
		############################
		#Number of evaluation repititions to run
		epochs = 100
		protocol = prot
		#consts
		iterations = ['00100', '00200', '00500']
		OLDiterations = ['00100', '00200', '00300',  '00400',  '00500',  '00600',  '00700',  '00800',  '00900',  '01000',  '01500',  '02000',  '02500',  '03000',  '03500',  '04000',  '04500',  '05000',  '05500',  '06000',  '06500',  '07000',  '07500',  '08000',  '08500',  '09000',  '09500',  '10000']
		iplist_vm = ['10.0.0.11', '10.0.0.12', '10.0.0.13', '10.0.0.14', '10.0.0.21', '10.0.0.22',  '10.0.0.23', '10.0.0.24', '10.0.0.31', '10.0.0.32', '10.0.0.33', '10.0.0.34']
		iplist_phys = ['10.0.0.1', '10.0.0.2', '10.0.0.3']
		filesize = (10**size)/1000

		#path to the file as seen from broeval.py position
		path = 'runs/'+str(ids_name)+'/'+str(filesize)+'KB/src'+str(num_sources)+'-tgt'+str(num_targets)+'/'

		#source ip adresses
		if num_sources == 8:
			sources = "'" + "', '".join(iplist_vm[:num_targets]) + "', '" + "', '".join(iplist_vm[num_sources:]) + "'"
		elif num_sources == 1:
			sources = "'" + "', '".join(iplist_phys[:num_sources]) + "'"
		else:
			sources = "'" + "', '".join(iplist_phys[:num_targets])+ "', '" +  "', '".join(iplist_phys[num_sources:num_sources+num_targets]) + "'"
		#target ip adresses
		if num_targets == 4:
			targets = "'" + "', '".join(iplist_vm[num_targets:num_sources]) + "'"
		elif num_targets == 1:
			targets = "'" + "', '".join(iplist_phys[num_sources:(num_sources+num_targets)]) + "'"
		else:
			targets = "'" + "', '".join(iplist_phys[num_sources:(num_sources+num_targets)]) + "'"
	

	#	# Automatically generated
	#	if ids == 'ids':
	#		ids_status_source = 'True'
	#		ids_status_target = 'True'
	#		filler = 'True'
	#	elif ids == 'noids':
	#		ids_status_source = 'False'
	#		ids_status_target = 'False'
	#		filler = 'False'
	#	for i in range(num_sources-1):
	#		ids_status_source = ids_status_source + ", " + filler
	#	for i in range(num_targets-1):
	#		ids_status_target = ids_status_target + ", " + filler

		filename_master = str(path)+str(protocol)+'-'+str(mode)+'-'+str(idsmode)+'-iter.sh'  
		f1 = open(filename_master,"w+")
		f1.write("#!/bin/bash\n")
		f1.write("cd ~/broeval\n")
		f2.write("./"+filename_master+"\n")

		for it in iterations:
			it_number = it.lstrip("0")
			filename = str(path)+str(protocol)+'-'+str(mode)+'-'+str(idsmode)+'-iter'+str(it)+'.cfg.py'
			f1.write("./broeval.py " + filename + "\n")

			f = open(filename, "w+") 
			f.write("\n# Write results to this file\n")
			f.write("OUTFILE = '"+str(path)+str(protocol)+'-'+str(mode)+'-'+str(idsmode)+'-iter'+str(it)+".result.csv'")
			f.write("\n\n# Source computers for the request\n")
			f.write("SOURCE = [%s]" % (sources))
	#		f.write("\n\n# Should IDS be enabled on the source machines?\n")
	#		f.write("SOURCE_IDS = [%s]" % (ids_status_source))
			f.write("\n\n# Target machines for the requests (aka server)\n")
			f.write("TARGET = [%s]" % (targets))
	#		f.write("\n\n# Should IDS be enabled on target machines?\n")
	#		f.write("TARGET_IDS = [%s]" % (ids_status_target)) 
			f.write("\n\n# IDS Mode. (ATM: noids, min, max, http, ssl, ftp, icmp, mysql)\n")
			f.write("IDSMODE = '%s'" % (str(idsmode)))
			f.write("\n\n# Connection mode (par = parallel, seq = sequential)\n")
			f.write("MODE = '%s'" % (mode))
			f.write("\n\n# Number of evaluation repititions to run\n")
			f.write("EPOCHS = %s" % (str(epochs)))
			f.write("\n\n# Number of iterations to be run in each evaluation repitition\n")
			f.write("ITER = %s" % (str(it_number)))
			f.write("\n\n# Size of the file to be downloaded from target (in Bytes * 10^SIZE)\n")
			f.write("SIZE = %s" % (str(size)))
			f.write("\n\n# Protocol to be used e.g. HTTP, SSL, FTP, MYSQL\n")
			f.write("PROTOCOL = '%s'" % (str(protocol)))
	#		f.write("\n\n# IDS Mode e.g. min, max, prot1, prot2,...\n")
	#		f.write("IDSMODE = '%s'" % (str(idsmode)))
			f.close
		f1.close
		os.chmod(filename_master, 0744)

f2.close
os.chmod(fn, 0744)

if __name__ == '__main__':
    main()
