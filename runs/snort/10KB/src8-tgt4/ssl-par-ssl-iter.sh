#!/bin/bash
cd ~/broeval
./broeval.py runs/snort/10KB/src8-tgt4/ssl-par-ssl-iter00100.cfg.py
./broeval.py runs/snort/10KB/src8-tgt4/ssl-par-ssl-iter00200.cfg.py
./broeval.py runs/snort/10KB/src8-tgt4/ssl-par-ssl-iter00500.cfg.py
