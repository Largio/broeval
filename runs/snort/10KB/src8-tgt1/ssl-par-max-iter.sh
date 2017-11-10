#!/bin/bash
cd ~/broeval
./broeval.py runs/snort/10KB/src8-tgt1/ssl-par-max-iter00100.cfg.py
./broeval.py runs/snort/10KB/src8-tgt1/ssl-par-max-iter00200.cfg.py
./broeval.py runs/snort/10KB/src8-tgt1/ssl-par-max-iter00500.cfg.py
