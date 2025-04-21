#!/bin/bash

# Script to backup the API and its database (if any)

# Configuration
API_DIR="/home/ubuntu/node-student-api"
BACKUP_DIR="/home/ubuntu/backups"
DB_USER="root"
DB_NAME="students"

# Log file
LOG_FILE="/home/ubuntu/bash_scripts/backup.log"

# Timestamp function
timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Generate timestamp for backup filename
BACKUP_DATE=$(date "+%Y-%F")  # Use %Y-%m-%d for consistency

# Backup API files
API_BACKUP_FILE="$BACKUP_DIR/api_backup_$BACKUP_DATE.tar.gz"
tar -czvf "$API_BACKUP_FILE" "$API_DIR"
if [ $? -eq 0 ]; then
  echo "$(timestamp) - API files backed up successfully to $API_BACKUP_FILE" >> $LOG_FILE
else
  echo "$(timestamp) - ERROR: API files backup failed!" >> $LOG_FILE
fi

# Backup Database (MySQL example)
if [ -n "$DB_NAME" ]; then
  DB_BACKUP_FILE="$BACKUP_DIR/db_backup_$BACKUP_DATE.sql"
  mysqldump -u"$DB_USER" "$DB_NAME" > "$DB_BACKUP_FILE"
  if [ $? -eq 0 ]; then
    echo "$(timestamp) - Database backed up successfully to $DB_BACKUP_FILE" >> $LOG_FILE
  else
    echo "$(timestamp) - ERROR: Database backup failed!" >> $LOG_FILE
  fi
fi

# Delete old backups (older than 7 days)
find "$BACKUP_DIR" -type f -mtime +7 -delete
echo "$(timestamp) - Old backups deleted." >> $LOG_FILE

echo "$(timestamp) - Backup process completed." >> $LOG_FILE
