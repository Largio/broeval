#!/bin/bash
cd ~/broeval
./broeval.py runs/snort/10KB/src8-tgt4/icmp-par-icmp-iter00100.cfg.py
./broeval.py runs/snort/10KB/src8-tgt4/icmp-par-icmp-iter00200.cfg.py
./broeval.py runs/snort/10KB/src8-tgt4/icmp-par-icmp-iter00500.cfg.py
