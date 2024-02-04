#!/bin/sh

# This script is used to update your personal wiki. It performs the following tasks:
# - Executes maintenance tasks for the MediaWiki application.
# - Creates a backup of the MySQL database.
# - Checks if the SQL backup file is empty and retries until it is not empty.
# - Renames the backup file with a timestamp.
# - Deletes old backup files, keeping only a specified number of recent backups.

# Variables
backup_dir="/root/personal_wiki/database_backups"
num_backups_to_keep=7
sql_file="$backup_dir/backup.sql"

docker-compose -f docker-compose.yml up -d

# Wait for containers to be up and running
sleep 10

docker-compose exec mediawiki php /var/www/html/maintenance/update.php

#docker-compose exec mediawiki php /var/www/html/maintenance/run.php update.php
docker-compose exec database mysqldump -u root -pPSWD --default-character-set=binary pw_db > "$sql_file"

#Check if the SQL backup file is empty and retry until it is not empty
while [ ! -s "$sql_file" ]; do
    echo "SQL backup file is empty. Retrying..."
    docker-compose exec database mysqldump -u root -pPSWD --default-character-set=binary pw_db > "$sql_file"
done

mv $sql_file "$backup_dir/backup_$(date +"%Y%m%d%H%M%S").sql"

# Change directory to the backup directory
cd "$backup_dir" || exit

# Get a list of backup files sorted by modification time
backup_files=$(ls -t backup_*.sql)
backup_array=""

# Create an array of backup file names
for file in $backup_files; do
    backup_array="$backup_array $file"
done

# Count the number of backup files
num_backups=$(ls -t "$backup_dir"/backup_*.sql | wc -l)

# Delete old backup files, keeping only a specified number of recent backups
if [ "$num_backups" -gt "$num_backups_to_keep" ]; then
    backups_to_delete=$((num_backups - num_backups_to_keep))
    i=0
    while [ $i -lt $backups_to_delete ]; do
        file_to_delete=$(echo "$backup_files" | tail -n 1)
        rm "$file_to_delete"
        backup_files=$(ls -t backup_*.sql)
        i=$((i + 1))
    done
fi
