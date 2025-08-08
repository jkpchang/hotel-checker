#!/bin/bash

# Hotel Availability Checker Cron Script
# This script runs the hotel availability checker with predefined dates

# Set the working directory to the script location
cd "$(dirname "$0")"

# Set up PATH for cron (cron runs with minimal environment)
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Set up Go environment for cron
export GOPATH="/Users/jchang/go"
export GOCACHE="/tmp/go-build"
export GOENV="off"

# The program now reads date ranges from date_ranges.txt file
# No need to set individual dates here

# Log file for cron output
LOG_FILE="$HOME/hotel_checker.log"

# Function to log messages with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log_message "Starting hotel availability check..."

# Check if the compiled binary exists
BINARY_PATH="$(dirname "$0")/hotel_checker"
if [ ! -f "$BINARY_PATH" ]; then
    log_message "ERROR: Compiled binary not found at $BINARY_PATH"
    log_message "Please run: go build -o hotel_checker main.go"
    exit 1
fi

log_message "Using compiled binary at: $BINARY_PATH"

# Check if environment variables are set
if [ -z "$GMAIL_USER" ] || [ -z "$GMAIL_PASSWORD" ] || [ -z "$TO_EMAIL" ]; then
    log_message "ERROR: Required environment variables not set. Please set GMAIL_USER, GMAIL_PASSWORD, and TO_EMAIL"
    log_message "For cron jobs, you need to set these in the crontab or in a separate config file"
    exit 1
fi

# Run the hotel checker
log_message "Running checker for all date ranges in date_ranges.txt"

# Export environment variables for the Go program
export GMAIL_USER
export GMAIL_PASSWORD
export TO_EMAIL

# Run the compiled binary (no longer needs date arguments)
if "$BINARY_PATH" >> "$LOG_FILE" 2>&1; then
    log_message "Hotel checker completed successfully"
else
    log_message "ERROR: Hotel checker failed"
    exit 1
fi
