#!/usr/bin/env python

import sys
import imp
import os
import subprocess
import re
from datetime import datetime
import csv
import tempfile

# 1 Argument is expected (configfile)
def main():
    if len(sys.argv) != 2:
        print 'Usage: ./broeval.py <configfile>'
        return
#TOTO create variables to determine which IDS is going to be used

#store path and filename(with extension) of configfile(argument) in different variables
    (cfgpath, cfgname) = os.path.split(sys.argv[1])
#Find out which IDS is used by taking the name of the folder the script is in 
    idsname = cfgpath.split('/')
    idsname = str(idsname[1])
#store filename and extension in different variables
    (cfgname, cfgext) = os.path.splitext(cfgname)
#find module in filesystem by given path- and name-variable
    (cfgfile, cfgfilename, cfgdata) = imp.find_module(cfgname, [cfgpath])
#load given config. this returns the module object, on failure it returns an exception (input error)
    config = imp.load_module(cfgname, cfgfile, cfgfilename, cfgdata)
#TODO Lars close the file argument. found at:https://docs.python.org/2/library/imp.html

    if str(config.IDSMODE) == 'noids':
        sources = map(lambda (i, s): (s, False), enumerate(config.SOURCE))
        targets = map(lambda (i, s): (s, False), enumerate(config.TARGET))
    else:
        sources = map(lambda (i, s): (s, True), enumerate(config.SOURCE)) 
        targets = map(lambda (i, s): (s, True), enumerate(config.TARGET))    
    
    
#    for index, sour in enumerate(config.SOURCE):
#        sources = [(i, j) for i, j in 

    print 'Welcome to broeval.py'
    print ''
#    print 'cfgpath: %s' % cfgpath 
    print 'Used IDS: %s' % idsname
    print 'Config: %s' % sys.argv[1]
    for src, srcb in sources:
        print 'Source: %s (with %s %s)' % (src, idsname, 'ENABLED' if srcb else 'DISABLED')
    for tgt, tgtb in targets:
        print 'Target: %s (with %s %s)' % (tgt, idsname, 'ENABLED' if tgtb else 'DISABLED')
    print "C'Mode: %s" % config.MODE
    print 'Epochs: %i' % config.EPOCHS
    print "Iter's: %i" % config.ITER
    print 'Size  : 10^%i bytes' % config.SIZE
    print 'Result: %s' % config.OUTFILE
    print 'Protocol: %s' % config.PROTOCOL
    print 'IDS-Mode: %s' % config.IDSMODE
    print ''
    idsmode = str(config.IDSMODE)
    # 1. Reset the environment (terminate IDS if still running)
    #Note the absence of a third param. 2 Params make idsstart.sh behave just as the killer(not the logger as with 3 params[for ids summary])
    for src, srcb in sources:
        print 'Terminating %s on source machine %s' % (idsname, src)
        print os.popen('./helpers/idskill.sh %s %s' % (src, idsname)).read()
    for tgt, tgtb in targets:
        print 'Terminating %s on target machine %s' % (idsname, tgt)
        print os.popen('./helpers/idskill.sh %s %s' % (tgt, idsname)).read()
    csvfile = open(config.OUTFILE, 'wb')
    csvwriter = csv.writer(csvfile)
    csvwriter.writerow(['SOURCE', 'TARGET', 'IDS_MODE', 'MODE', 'EPOCHS', 'ITER', 'SIZE', 'PROTOCOL', 'seconds', 'sourcecpu', 'sourcemem', 'targetcpu', 'targetmem'])

    # 2. Start IDS (if requested)
    for src, srcb in sources:
        if srcb:
            print 'Starting %s on source machine %s' % (idsname, src)
            print os.popen('./helpers/idsstart.sh %s %s %s %s' % (src, idsname, idsmode, config.OUTFILE)).read()
    for tgt, tgtb in targets:
        if tgtb:
            print 'Starting %s on target machine %s' % (idsname, tgt)
            print os.popen('./helpers/idsstart.sh %s %s %s %s' % (tgt, idsname, idsmode, config.OUTFILE)).read()

    for epoch in range(config.EPOCHS):
        print '---- %s - EPOCH %i - %s ----' % (sys.argv[1], epoch, datetime.now().time())
        sourcestat = [None] * len(sources)
        targetstat = [None] * len(targets)

        # If IDS is enabled, start collecting CPU / mem statistics
        for i, (src, srcb) in enumerate(sources):
            if srcb:
#                print "%s %s" % (src, idsname)
                sourcestat[i] = subprocess.Popen(['./helpers/idsstat.sh', src, idsname], stdout=subprocess.PIPE)
        for i, (tgt, tgtb) in enumerate(targets):
            if tgtb:
                targetstat[i] = subprocess.Popen(['./helpers/idsstat.sh', tgt, idsname], stdout=subprocess.PIPE)

        # Run the data transfer
        processes = []
        tempfiles = []
        seconds = []
        for i, (src, srcb) in enumerate(sources):
            processes.append([])
            tempfiles.append([])
            seconds.append([])
            for j, (tgt, tgtb) in enumerate(targets):
                processes[i].append(None)
                tempfiles[i].append(None)
                seconds[i].append(.0)
                filed, filename = tempfile.mkstemp()
                tempfiles[i][j] = [os.fdopen(filed), filename]
                processes[i][j] = subprocess.Popen(['./helpers/%s.sh' % config.PROTOCOL, src, tgt, str(config.ITER), str(config.SIZE), str(config.MODE)], stdout=subprocess.PIPE, stderr=tempfiles[i][j][0])


        for i, (src, srcb) in enumerate(sources):
            for j, (tgt, tgtb) in enumerate(targets):
                processes[i][j].wait()
                tempfiles[i][j][0].close()
                tempfiles[i][j][0] = open(tempfiles[i][j][1], 'r')
	#readlines() liest jede Zeile einzeln und [-1] liest das allerletzte Element, also die letzte Zeile
	#strip() schneidet leerzeichen ab
                seconds[i][j] = float(tempfiles[i][j][0].readlines()[-1].strip())
                tempfiles[i][j][0].close()
                os.remove(tempfiles[i][j][1])
                print 'source %s, target %s: %.2f seconds.' % (src, tgt, seconds[i][j])

        # If IDS is enabled, stop collecting CPU / mem statistics
        sourcecpu = [.0] * len(sources)
        sourcemem = [.0] * len(sources)
        targetcpu = [.0] * len(targets)
        targetmem = [.0] * len(targets)
        for i, (src, srcb) in enumerate(sources):
            if srcb:
                sourcestat[i].kill()
                outs, errs = sourcestat[i].communicate()
                lines = outs.split('\n')
                linecount = 0
                for line in lines:
                    if line and line.split()[0] != '%CPU':
                        linecount += 1
                        sourcecpu[i] += float(line.split()[0].replace(',', '.'))
                        sourcemem[i] += float(line.split()[1])
                sourcecpu[i] /= linecount
                sourcemem[i] /= linecount
                print '%s @ source %s took on average %.2f%% CPU and %.0f KB of physical memory.' % (idsname, src, sourcecpu[i], sourcemem[i])
        for i, (tgt, tgtb) in enumerate(targets):
            if tgtb:
                targetstat[i].kill()
                outs, errs = targetstat[i].communicate()
                lines = outs.split('\n')
                linecount = 0
                for line in lines:
                    if line and line.split()[0] != '%CPU':
                        linecount += 1
                        targetcpu[i] += float(line.split()[0].replace(',', '.'))
                        targetmem[i] += float(line.split()[1])
                targetcpu[i] /= linecount
                targetmem[i] /= linecount
                ##%.2f%% runden auf 2 kommstellen und escape prozentzeichen
                print '%s @ target %s took on average %.2f%% CPU and %.0f KB of physical memory.' % (idsname, tgt, targetcpu[i], targetmem[i])

        for i, (src, srcb) in enumerate(sources):
            for j, (tgt, tgtb) in enumerate(targets):
                csvwriter.writerow([src, tgt, config.IDSMODE, config.MODE, config.EPOCHS, config.ITER, config.SIZE, config.PROTOCOL, seconds[i][j], sourcecpu[i], sourcemem[i], targetcpu[j], targetmem[j]])
        print '\n'

    # Terminate IDS
    #Note that other than before, we use 3 params. This makes idskill.sh the killer AND the logger (of ids summary)
    csvfile.close()
    for src, srcb in sources:
        if srcb:
            print 'Terminating %s on source machine %s' % (idsname, src)
            print os.popen('./helpers/idskill.sh %s %s %s' % (src, idsname, config.OUTFILE)).read()
    for tgt, tgtb in targets:
        if tgtb:
            print 'Terminating %s on target machine %s' % (idsname, tgt)
            print os.popen('./helpers/idskill.sh %s %s %s' % (tgt, idsname, config.OUTFILE)).read()

if __name__ == '__main__':
    main()

