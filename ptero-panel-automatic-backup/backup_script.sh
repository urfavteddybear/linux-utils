#!/bin/bash

# Define variables
DB_USER="root"
DB_NAME="panel"
BACKUP_DIR="/root/backups"  # Change this to your desired backup directory
WEB_DIR="/var/www/pterodactyl"
DATE=$(date +"%Y%m%d")
REMOTE_USER="user"  # Remote server username
REMOTE_HOST="host"  # Remote server hostname or IP address
REMOTE_PORT="port"  # Custom port number for SFTP
REMOTE_DIR="remote_dir"  # Remote directory to upload the backups

# Ensure the backup directory exists
mkdir -p $BACKUP_DIR

# Create database backup
echo "Creating database backup..."
mysqldump -u $DB_USER --opt $DB_NAME > $BACKUP_DIR/panel.sql

# Check if the database backup was successful
if [ $? -ne 0 ]; then
    echo "Database backup failed!"
    exit 1
fi

# Copy .env file to backup directory
echo "Copying .env file..."
cp $WEB_DIR/.env $BACKUP_DIR

# Zip the backup files
echo "Creating zip archive..."
ZIP_FILE="$BACKUP_DIR/panel_backup_$DATE.zip"
zip -j $ZIP_FILE $BACKUP_DIR/panel.sql $BACKUP_DIR/.env

# Check if the zip creation was successful
if [ $? -ne 0 ]; then
    echo "Failed to create zip archive!"
    exit 1
fi

# Clean up temporary files
echo "Cleaning up temporary files..."
rm $BACKUP_DIR/panel.sql
rm $BACKUP_DIR/.env

# Delete backups older than 3 days
echo "Deleting old backups..."
find $BACKUP_DIR -type f -name "panel_backup_*.zip" -mtime +3 -exec rm {} \;

# Upload the backup zip file to the remote server via SFTP
echo "Uploading backup to remote server..."
sftp -P $REMOTE_PORT $REMOTE_USER@$REMOTE_HOST <<EOF
cd $REMOTE_DIR
put $ZIP_FILE
bye
EOF

# Check if the upload was successful
if [ $? -ne 0 ]; then
    echo "Failed to upload backup to remote server!"
    exit 1
fi

echo "Backup completed successfully: $ZIP_FILE"
echo "Backup uploaded successfully to $REMOTE_HOST:$REMOTE_DIR"