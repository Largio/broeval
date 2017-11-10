#!/bin/bash
cd ~/broeval
./broeval.py runs/bro/100KB/src1-tgt1/icmp-par-icmp-iter00100.cfg.py
./broeval.py runs/bro/100KB/src1-tgt1/icmp-par-icmp-iter00200.cfg.py
./broeval.py runs/bro/100KB/src1-tgt1/icmp-par-icmp-iter00500.cfg.py
