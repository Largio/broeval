#!/bin/bash
cd ~/broeval
./broeval.py runs/snort/100KB/src2-tgt1/ssl-par-ssl-iter00100.cfg.py
./broeval.py runs/snort/100KB/src2-tgt1/ssl-par-ssl-iter00200.cfg.py
./broeval.py runs/snort/100KB/src2-tgt1/ssl-par-ssl-iter00500.cfg.py
