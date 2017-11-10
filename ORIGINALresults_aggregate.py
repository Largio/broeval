#!/usr/bin/env python

import sys
import os
import csv
from scipy import stats

def main():
    if len(sys.argv) < 3 or not len(sys.argv) % 2:
        print 'Usage: ./results_aggregate.py <resultfile_noids_1, resultfile_noids_2, ..., resultfile_ids_1, resultfile_ids_2, ...>'
        print 'e.g. ./results_aggregate.py runs/seq-noids-iter*.result.csv runs/seq-ids-iter*.result.csv'
        return
    firstlen = len(sys.argv[1:]) / 2
    resultfns = [(sys.argv[1:][i], sys.argv[1:][firstlen+i]) for i in range(firstlen)]
    print 'lars' + str(len(sys.argv[1:]))
    print 'lars' + str([(sys.argv[1:][i], sys.argv[1:][firstlen+i]) for i in range(firstlen)])
#    print 'lars2' + str(sys.argv[1])+str(sys.argv[2])
    print "file_ids, total_noids, total_ids, avgsec_noids, avgsec_ids, avgsec_diff, statistic, pvalue, avgsrccpu, avgsrcmem, avgtgtcpu, avgtgtmem"
    for resultfn in resultfns:
        resultf_noids = open(resultfn[0])
        resultf_ids = open(resultfn[1])
        reader_noids = csv.DictReader(resultf_noids)
        reader_ids = csv.DictReader(resultf_ids)
        total_ids = 0
        total_noids = 0
        avgsec_noids = .0
        avgsec_ids = .0
        avgsrccpu = .0
        avgsrcmem = .0
        avgtgtcpu = .0
        avgtgtmem = .0
        a = []
        b = []
        for row in reader_noids:
            total_noids += 1
            avgsec_noids += float(row['seconds'])
            a.append(float(row['seconds']))
        for row in reader_ids:
            total_ids += 1
            avgsec_ids += float(row['seconds'])
            b.append(float(row['seconds']))
            avgsrccpu += float(row['sourcecpu'])
            avgsrcmem += float(row['sourcemem'])
            avgtgtcpu += float(row['targetcpu'])
            avgtgtmem += float(row['targetmem'])
        avgsec_noids /= total_noids
        avgsec_ids /= total_ids
        avgsrccpu /= total_ids
        avgsrcmem /= total_ids
        avgtgtcpu /= total_ids
        avgtgtmem /= total_ids
        statistic, pvalue = stats.ttest_ind(a, b, equal_var=False)
        print "%s, %i, %i, %.2f, %.2f, %.2f, %.2f, %.5f, %.2f, %.2f, %.2f, %.2f" % (resultfn[1], total_noids, total_ids, avgsec_noids, avgsec_ids, (avgsec_ids-avgsec_noids), statistic, pvalue, avgsrccpu, avgsrcmem, avgtgtcpu, avgtgtmem)

        resultf_noids.close()
        resultf_ids.close()

if __name__ == '__main__':
    main()

