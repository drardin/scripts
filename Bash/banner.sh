#!/bin/bash

#This script can be ran on its own or placed into a user's bashrc file and acts as a pseudo login prompt.
#It's intended to be used with overthewire style terminal games / puzzles

echo "Logon script triggered by $USER" | (logger -t BANNER.SH -p 1)
# Ignore the SIGINT (Ctrl-C) and SIGTERM signals
trap 'typed_response_effect "Escape is not an option"' 2

##### Simulated typed response effect #####
typed_response_effect() {
  # Set the delay between characters (in seconds)
  delay=0.05

  # Set the message to be displayed
  message=$1

  # Determine string length
  length=${#message}

  # Loop through each character in the message
  for (( i=0; i<$length; i++ )); do
    # Extract the current character
    char=${message:$i:1}
    # Print the character and sleep for the specified delay
    echo -n "$char"
    sleep $delay
  done

  # Add a newline after the message is finished
  echo ""
}

##### Blinking Cursor Effect #####
blinking_cursor() {
  local seconds=$1

  # Blink the cursor for the specified number of seconds
  while [[ "$seconds" -gt 0 ]]; do
    echo -en "\033[5 q"
    sleep 0.5
    echo -en "\033[0 q"
    sleep 0.5
    seconds=$((seconds-1))
  done
}

#Static Variables
password="PASSWORD"
flash_time="3"

clear

# Display Banner
blinking_cursor "$flash_time"
typed_response_effect "Welcome..."
blinking_cursor "$flash_time"
typed_response_effect "This is a private system. Unauthorized access is prohibited."
blinking_cursor "$flash_time"
typed_response_effect "All activity is logged and monitored."

# Password prompt loop, exit on success
while true; do
  # Prompt user for password
  read -s -p "Enter Pre-Shared Key: " input

  # Check if password is correct
  if [ "$input" == "$password" ]; then
    # Correct Password: Carriage return and delay
    echo ""
    blinking_cursor "$flash_time"
    typed_response_effect "Valid Entry."
    blinking_cursor "1" 
    typed_response_effect "You're in..."
    echo "Successful Login for $USER" | (logger -t BANNER.SH -p 1)
    # Grant default shell access w/ successful exit code (default shell is set in user's profile)
    exit 0
  else
    # Incorrect Password
    echo ""
    blinking_cursor "$flash_time"
    typed_response_effect "Invalid Entry. Try again..."
    echo "Login Failure for $USER" | (logger -t BANNER.SH -p 1)
  fi
done
