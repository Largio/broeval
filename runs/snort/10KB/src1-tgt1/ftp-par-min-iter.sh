#!/bin/bash
cd ~/broeval
./broeval.py runs/snort/10KB/src1-tgt1/ftp-par-min-iter00100.cfg.py
./broeval.py runs/snort/10KB/src1-tgt1/ftp-par-min-iter00200.cfg.py
./broeval.py runs/snort/10KB/src1-tgt1/ftp-par-min-iter00500.cfg.py
