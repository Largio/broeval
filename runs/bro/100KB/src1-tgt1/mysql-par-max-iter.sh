#!/bin/bash
cd ~/broeval
./broeval.py runs/bro/100KB/src1-tgt1/mysql-par-max-iter00100.cfg.py
./broeval.py runs/bro/100KB/src1-tgt1/mysql-par-max-iter00200.cfg.py
./broeval.py runs/bro/100KB/src1-tgt1/mysql-par-max-iter00500.cfg.py
