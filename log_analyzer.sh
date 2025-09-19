#!/usr/bin/env bash

# ==============================
# Web Server Log Analyzer Script
# ==============================

# Default log file (can be overridden by user argument)
LOGFILE=${1:-/var/log/nginx/access.log}

# Check if log file exists
if [ ! -f "$LOGFILE" ]; then
    echo "Error: Log file $LOGFILE not found!"
    exit 1
fi

echo "Analyzing log file: $LOGFILE"
echo "============================="

# 1) Number of 404 errors
echo "🔹 Number of 404 errors:"
grep " 404 " "$LOGFILE" | wc -l
echo

# 2) Top 10 requested pages (URLs)
echo "🔹 Top 10 requested pages:"
awk '{print $7}' "$LOGFILE" | sort | uniq -c | sort -nr | head -10
echo

# 3) Top 10 client IP addresses
echo "🔹 Top 10 client IPs:"
awk '{print $1}' "$LOGFILE" | sort | uniq -c | sort -nr | head -10
echo

echo "============================="
echo "Report generated successfully."
