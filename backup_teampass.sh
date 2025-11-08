#!/bin/bash

BACKUP_DIR="/mnt/backup_disk/teampass_backups"
DATE=$(date +%Y-%m-%d)
DB_NAME="teampass"
mkdir -p "$BACKUP_DIR"
chmod 777 "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/teampass_backup_$DATE.sql"
LOG_FILE="$BACKUP_DIR/backup_log.txt"

# Create directory
mkdir -p "$BACKUP_DIR"
chmod 777 "$BACKUP_DIR"

# Start log
echo "[$(date)] START mysqldump for $DB_NAME" >> "$LOG_FILE"

# Dump (password from /root/.my.cnf)
mysqldump -u root --single-transaction "$DB_NAME" > "$BACKUP_FILE" 2>> "$LOG_FILE"

# Check and log
if [ -f "$BACKUP_FILE" ] && [ -s "$BACKUP_FILE" ]; then
    echo "[$(date)] SUCCESS: Backup created: $BACKUP_FILE (size: $(du -h "$BACKUP_FILE" | cut -f1))" >> "$LOG_FILE"
    chmod 666 "$BACKUP_FILE"
else
    echo "[$(date)] ERROR: Backup failed! See mysqldump errors above." >> "$LOG_FILE"
fi
chmod 666 "$LOG_FILE"

# Delete old backups (older than 14 days)
find "$BACKUP_DIR" -name "teampass_backup_*.sql" -mtime +14 -delete

