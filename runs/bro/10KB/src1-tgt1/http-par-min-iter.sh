#!/bin/bash
cd ~/broeval
./broeval.py runs/bro/10KB/src1-tgt1/http-par-min-iter00100.cfg.py
./broeval.py runs/bro/10KB/src1-tgt1/http-par-min-iter00200.cfg.py
./broeval.py runs/bro/10KB/src1-tgt1/http-par-min-iter00500.cfg.py
