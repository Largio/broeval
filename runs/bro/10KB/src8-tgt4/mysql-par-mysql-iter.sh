#!/bin/bash
cd ~/broeval
./broeval.py runs/bro/10KB/src8-tgt4/mysql-par-mysql-iter00100.cfg.py
./broeval.py runs/bro/10KB/src8-tgt4/mysql-par-mysql-iter00200.cfg.py
./broeval.py runs/bro/10KB/src8-tgt4/mysql-par-mysql-iter00500.cfg.py
