#!/usr/bin/env bash

# ==============================
# System Health Monitoring Script
# ==============================

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
PROC_THRESHOLD=300   # example limit for processes

# Log file
LOGFILE="/var/log/system_health.log"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Function to log messages
log_alert() {
    echo "[$TIMESTAMP] $1" | tee -a "$LOGFILE"
}

# 1) CPU Usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}') # idle% → used%
CPU_USAGE=${CPU_USAGE%.*}  # integer
if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    log_alert "ALERT: High CPU usage detected: ${CPU_USAGE}%"
else
    log_alert "CPU usage is normal: ${CPU_USAGE}%"
fi

# 2) Memory Usage
MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
MEM_USAGE=${MEM_USAGE%.*}
if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
    log_alert "ALERT: High Memory usage detected: ${MEM_USAGE}%"
else
    log_alert "Memory usage is normal: ${MEM_USAGE}%"
fi

# 3) Disk Usage (root partition)
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    log_alert "ALERT: High Disk usage detected on / : ${DISK_USAGE}%"
else
    log_alert "Disk usage is normal: ${DISK_USAGE}%"
fi

# 4) Process count
PROC_COUNT=$(ps -e --no-headers | wc -l)
if [ "$PROC_COUNT" -gt "$PROC_THRESHOLD" ]; then
    log_alert "ALERT: Too many processes running: $PROC_COUNT"
else
    log_alert "Process count is normal: $PROC_COUNT"
fi

log_alert "============================="
