#!/bin/bash
cd ~/broeval
./broeval.py runs/bro/100KB/src2-tgt1/mysql-par-noids-iter00100.cfg.py
./broeval.py runs/bro/100KB/src2-tgt1/mysql-par-noids-iter00200.cfg.py
./broeval.py runs/bro/100KB/src2-tgt1/mysql-par-noids-iter00500.cfg.py
