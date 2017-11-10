#!/usr/bin/env python

import sys
import os
import csv
from scipy import stats

def main():
    if len(sys.argv) < 4 or not len(sys.argv) % 3:
        print 'Usage: ./results_aggregate.py <resultfile_noids_1, resultfile_noids_2, ..., resultfile_bro_1, resultfile_bro_2, ..., resultfile_snort_1, resultfile_snort_2, ...>'
        print 'e.g. ./results_aggregate.py runs/bro/...par-noids-iter*.result.csv runs/bro/...par-min-iter*.result.csv runs/snort/...par-min-iter*.result.csv'
        return
    firstlen = len(sys.argv[1:]) / 3
    resultfns = [(sys.argv[1:][i], sys.argv[1:][firstlen+i], sys.argv[1:][firstlen+firstlen+i]) for i in range(firstlen)]
    print "filebro, filesnort, iter, totalnoids, totalbro, totalsnort, avgsecnoids, avgsecbro, avgsecsnort, statisticbro, pvaluebro, statisticsnort, pvaluesnort, avgsecdiffbro, avgsecdiffsnort, avgsrccpubro, avgsrcmembro, avgtgtcpubro, avgtgtmembro, avgsrccpusnort, avgsrcmemsnort, avgtgtcpusnort, avgtgtmemsnort"
    for resultfn in resultfns:
        resultf_noids = open(resultfn[0])
        resultf_bro = open(resultfn[1])
        resultf_snort = open(resultfn[2])
        reader_noids = csv.DictReader(resultf_noids)
        reader_bro = csv.DictReader(resultf_bro)
        reader_snort = csv.DictReader(resultf_snort)
        total_bro = 0
        total_noids = 0
        total_snort = 0
        avgsec_noids = .0
        avgsec_bro = .0
        avgsec_snort = .0
        avgsrccpu_bro = .0
        avgsrcmem_bro = .0
        avgtgtcpu_bro = .0
        avgtgtmem_bro = .0
        avgsrccpu_snort = .0
        avgsrcmem_snort = .0
        avgtgtcpu_snort = .0
        avgtgtmem_snort = .0
        a = []
        b = []
        c = []
        itera = 0
        for row in reader_noids:
            total_noids += 1
            avgsec_noids += float(row['seconds'])
            a.append(float(row['seconds']))
            itera = int(row['ITER'])
        for row in reader_bro:
            total_bro += 1
            avgsec_bro += float(row['seconds'])
            b.append(float(row['seconds']))
            avgsrccpu_bro += float(row['sourcecpu'])
            avgsrcmem_bro += float(row['sourcemem'])
            avgtgtcpu_bro += float(row['targetcpu'])
            avgtgtmem_bro += float(row['targetmem'])
        for row in reader_snort:
            total_snort += 1
            avgsec_snort += float(row['seconds'])
            c.append(float(row['seconds']))
            avgsrccpu_snort += float(row['sourcecpu'])
            avgsrcmem_snort += float(row['sourcemem'])
            avgtgtcpu_snort += float(row['targetcpu'])
            avgtgtmem_snort += float(row['targetmem'])
        avgsec_noids /= total_noids
        avgsec_bro /= total_bro
        avgsec_snort /= total_snort
        avgsrccpu_bro /= total_bro
        avgsrcmem_bro /= total_bro
        avgtgtcpu_bro /= total_bro
        avgtgtmem_bro /= total_bro
        avgsrccpu_snort /= total_snort
        avgsrcmem_snort /= total_snort
        avgtgtcpu_snort /= total_snort
        avgtgtmem_snort /= total_snort
        statistic_bro, pvalue_bro = stats.ttest_ind(a, b, equal_var=False)
        statistic_snort, pvalue_snort = stats.ttest_ind(a, c, equal_var=False)
        print "%s, %s, %i, %i, %i, %i, %.2f, %.2f, %.2f, %.2f, %.5f, %.2f, %.5f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f" % (resultfn[1], resultfn[2], itera, total_noids, total_bro, total_snort, avgsec_noids, avgsec_bro, avgsec_snort, statistic_bro, pvalue_bro, statistic_snort, pvalue_snort, (avgsec_bro-avgsec_noids), (avgsec_snort-avgsec_noids), avgsrccpu_bro, avgsrcmem_bro, avgtgtcpu_bro, avgtgtmem_bro, avgsrccpu_snort, avgsrcmem_snort, avgtgtcpu_snort, avgtgtmem_snort)

        resultf_noids.close()
        resultf_bro.close()
        resultf_snort.close()

if __name__ == '__main__':
    main()

