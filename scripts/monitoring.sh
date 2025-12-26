#!/bin/bash

LOG_FILE="cpu_usage.log"

echo "-----------------------------" >> $LOG_FILE
echo "Timestamp: $(date)" >> $LOG_FILE
top -bn1 | grep "Cpu(s)" >> $LOG_FILE
