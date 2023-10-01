#!/bin/bash

#Use set -e to force any errors at any point within the script to result in an exit
set -e

# It's recommended to store sensitive data, like a Bitlocker Recovery Key, in an encrypted file
# This script calls on such a file, decrypts its contents and pulls it into the script
# The gpg utility can be used to encrypt a file. In this example, create a text file with "bitlocker_password <Bitlocker Recovery Key>" on the first line
# Then run gpg -c <text file>
# Remove the original file

# Prompt the user for the password to decrypt the configuration file
read -s -p "Enter the password to decrypt the configuration file: " decryption_password

# Decrypt the configuration file and extract the BitLocker recovery key or password
password=$(gpg --batch --passphrase "$decryption_password" -d /path/to/<your-key>.gpg | grep "bitlocker_password" | awk '{print $2}')

# Use blkid to find the /dev/ name of the disk
# Use a disk identifier, such as:
# UUID
# PARTUUID
# Run `blkid` and look for an identifier in the string for your target. The following command only extracts the /dev/name minus the colon
devname=$(blkid | grep "<disk identifier>" | awk '{print $1}' | sed 's/://')

# Check if the /dev/ name was found
if [ -z "$devname" ]
then
    # /dev/ name was not found
    echo "Error: The disk is unavailable."
        exit 1
else
    # /dev/ name was found
    echo "$devname is available. Unlocking disk..."
fi

#Two mount points are needed
#One for the dislocker-file that's generated when unlocking the disk
#Another to actually mount the contents of the disk


# Unlock the drive using dislocker
sudo dislocker -v -V $devname -p$password -- /path/to/mount-point-1 && \
echo "Successfully unlocked the drive."

# Mount the unlocked drive
sudo mount -o loop /media/tmp/dislocker-file /path/to/mount-point-2 && \
echo "Successfully mounted the drive."
