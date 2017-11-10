#!/bin/bash
cd ~/broeval
./broeval.py runs/bro/10KB/src2-tgt1/icmp-par-noids-iter00100.cfg.py
./broeval.py runs/bro/10KB/src2-tgt1/icmp-par-noids-iter00200.cfg.py
./broeval.py runs/bro/10KB/src2-tgt1/icmp-par-noids-iter00500.cfg.py
