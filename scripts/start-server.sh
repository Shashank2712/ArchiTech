#!/bin/bash
cd /home/ubuntu/pythonApp
nohup python3 /home/ubuntu/pythonApp/app.py > /home/ubuntu/pythonApp/nohup.out 2>&1 &
