#!/bin/bash

# Script to automate server and API updates

# Configuration
API_DIR="/home/ubuntu/node-student-api"  # Replace with your API directory
WEB_SERVER_SERVICE="apache2"  # Or "nginx" if you're using Nginx
GIT_REPO_DIR="/home/ubuntu/node-student-api" # Replace if different from API_DIR

# Log file
LOG_FILE="/home/ubuntu/bash_scripts/update.log"

# Timestamp function
timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

# Update Ubuntu packages
apt update && apt upgrade -y
if [ $? -ne 0 ]; then
  echo "$(timestamp) - ERROR: Failed to update Ubuntu packages." >> $LOG_FILE
  exit 1
fi
echo "$(timestamp) - Ubuntu packages updated." >> $LOG_FILE

# Pull latest changes from Git
cd "$GIT_REPO_DIR"
git pull origin main  # Or your main branch name
GIT_PULL_STATUS=$?

if [ "$GIT_PULL_STATUS" -ne 0 ]; then
  echo "$(timestamp) - ERROR: Git pull failed. Aborting web server restart." >> $LOG_FILE
  exit 1
else
  echo "$(timestamp) - Git pull successful." >> $LOG_FILE
fi

# Restart web server
systemctl restart "$WEB_SERVER_SERVICE"
if [ $? -ne 0 ]; then
  echo "$(timestamp) - ERROR: Failed to restart $WEB_SERVER_SERVICE." >> $LOG_FILE
  exit 1
fi
echo "$(timestamp) - Web server ($WEB_SERVER_SERVICE) restarted." >> $LOG_FILE

echo "$(timestamp) - Update process completed." >> $LOG_FILE
