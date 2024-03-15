#!/bin/sh
# This script has the purpose of maintaining your personal wiki. It performs the following tasks:
# Ask user if LocalSettings.php exists (first installation or update)
# if LocalSettings.php doesn't exist, start the install script (scripts/install.sh)
# if LocalSettings.php exists, start the update script (scripts/update.sh)
# Ask user if he wants to update the application
# if yes, start the update script (scripts/update.sh)
# if no, return to the menu
# Ask user if he wants to backup the database
# if yes, start the backup script (scripts/backup.sh)
# if no, return to the menu
# Ask user if he wants to delete old backups
# if yes, start the delete old backups script (scripts/delete_old_backups.sh)
# if no, return to the menu
# Ask user if he wants to exit the script
# if yes, exit the script

# Functions
install() {
    echo "Installing pedia"
    echo "=-=-=-=-=-=-=-=-=-=-="

    sh ./scripts/install.sh

    echo ""
    echo "Installation completed"
}

update() {
    echo "Updating pedia"
    echo "=-=-=-=-=-=-=-=-=-=-="
    
    sh ./scripts/update.sh

    echo ""
    echo "Update completed"
}

backup() {
    echo "Backing up the database"
    echo "=-=-=-=-=-=-=-=-=-=-="
    
    sh ./scripts/backup_database.sh

    echo ""
    echo "Backup completed"
}

delete_old_backups() {
    echo "Deleting old backups"
    echo "=-=-=-=-=-=-=-=-=-=-="
    
    # TODO: Implement

    echo ""
    echo "Deletion completed"
}

exit_script() {
    echo "End of script"
    exit 0
}

# Main
while true; do
    read -p "Press any key to continue..."
    

   
    echo "Welcome to the pedia maintenance script"
    echo "What do you want to do?"
    echo "1. Install/reinstall pedia"
    echo "2. Update pedia"
    echo "3. Backup the database"
    echo "4. Delete old backups"
    echo "0 Quit the script"
    read -p "Your choice: " choice

    case $choice in
        1)
            install
            ;;
        2)
            update
            ;;
        3)
            backup
            ;;
        4)
            delete_old_backups
            ;;
        0)
            exit_script
            ;;
        *)
            echo "Invalid choice"
            ;;
    esac
done
