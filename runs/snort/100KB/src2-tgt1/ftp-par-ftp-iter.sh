#!/bin/bash
cd ~/broeval
./broeval.py runs/snort/100KB/src2-tgt1/ftp-par-ftp-iter00100.cfg.py
./broeval.py runs/snort/100KB/src2-tgt1/ftp-par-ftp-iter00200.cfg.py
./broeval.py runs/snort/100KB/src2-tgt1/ftp-par-ftp-iter00500.cfg.py
