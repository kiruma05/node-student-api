#!/bin/bash

# Script to monitor server health and API status

# Log file
LOG_FILE="/home/ubuntu/bash_scripts/server_health.log"

# Timestamp function
timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

# Check CPU Usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*id: \([0-9.]*\)%,.*/\1/" | awk '{print 100 - $1}')
echo "$(timestamp) - CPU Usage: $CPU_USAGE%" >> $LOG_FILE

# Check Memory Usage
MEMORY_USAGE=$(free -h | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
echo "$(timestamp) - Memory Usage: $MEMORY_USAGE" >> $LOG_FILE

# Check Disk Space
DISK_USAGE=$(df -h / | awk 'NR==2{print $5}')
echo "$(timestamp) - Disk Usage: $DISK_USAGE" >> $LOG_FILE

# Check Web Server Status (Assuming Apache - Change if using Nginx)
if systemctl is-active apache2; then
  WEB_SERVER_STATUS="Running"
else
  WEB_SERVER_STATUS="Not Running"
  echo "$(timestamp) - WARNING: Web Server (Apache) is not running!" >> $LOG_FILE
fi
echo "$(timestamp) - Web Server Status: $WEB_SERVER_STATUS" >> $LOG_FILE

# Check API Endpoints
API_STUDENTS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://13.61.27.17/students)
API_SUBJECTS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://13.61.27.17/subjects)

echo "$(timestamp) - API /students Status: $API_STUDENTS_STATUS" >> $LOG_FILE
echo "$(timestamp) - API /subjects Status: $API_SUBJECTS_STATUS" >> $LOG_FILE

if [ "$API_STUDENTS_STATUS" -ne 200 ] || [ "$API_SUBJECTS_STATUS" -ne 200 ]; then
  echo "$(timestamp) - WARNING: One or more API endpoints returned a non-200 status!" >> $LOG_FILE
fi

echo "$(timestamp) - Health check completed." >> $LOG_FILE
