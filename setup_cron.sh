#!/bin/bash

# Hotel Availability Checker Cron Setup Script
# This script helps set up the cron job and environment variables

echo "=== Hotel Availability Checker Cron Setup ==="
echo ""

# Get the absolute path to the run_checker.sh script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN_SCRIPT="$SCRIPT_DIR/run_checker.sh"

echo "Script location: $RUN_SCRIPT"
echo ""

# Check if the run script exists
if [ ! -f "$RUN_SCRIPT" ]; then
    echo "ERROR: run_checker.sh not found at $RUN_SCRIPT"
    exit 1
fi

# Check if the script is executable
if [ ! -x "$RUN_SCRIPT" ]; then
    echo "Making script executable..."
    chmod +x "$RUN_SCRIPT"
fi

# Check if environment variables are set
echo "Checking environment variables..."
if [ -z "$GMAIL_USER" ]; then
    echo "WARNING: GMAIL_USER is not set"
    echo "Please set it with: export GMAIL_USER='your-email@gmail.com'"
fi

if [ -z "$GMAIL_PASSWORD" ]; then
    echo "WARNING: GMAIL_PASSWORD is not set"
    echo "Please set it with: export GMAIL_PASSWORD='your-app-password'"
fi

if [ -z "$TO_EMAIL" ]; then
    echo "WARNING: TO_EMAIL is not set"
    echo "Please set it with: export TO_EMAIL='recipient@example.com'"
fi

echo ""
echo "=== Current Crontab ==="
crontab -l 2>/dev/null || echo "No crontab found"

echo ""
echo "=== Adding Cron Job ==="
echo "The following cron job will be added:"
echo "45 17 * * * $RUN_SCRIPT"
echo ""
echo "This will run the hotel checker every day at 5:45 PM"
echo ""

# Ask for confirmation
read -p "Do you want to add this cron job? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Create a temporary crontab file
    TEMP_CRON=$(mktemp)
    
    # Get existing crontab
    crontab -l 2>/dev/null > "$TEMP_CRON"
    
    # Add the new cron job
    echo "45 17 * * * $RUN_SCRIPT" >> "$TEMP_CRON"
    
    # Install the new crontab
    crontab "$TEMP_CRON"
    
    # Clean up
    rm "$TEMP_CRON"
    
    echo "Cron job added successfully!"
    echo ""
    echo "=== Updated Crontab ==="
    crontab -l
    
    echo ""
    echo "=== Next Steps ==="
    echo "1. Make sure your environment variables are set:"
    echo "   export GMAIL_USER='your-email@gmail.com'"
    echo "   export GMAIL_PASSWORD='your-app-password'"
    echo "   export TO_EMAIL='recipient@example.com'"
    echo ""
    echo "2. To make environment variables permanent, add them to your ~/.zshrc or ~/.bash_profile"
    echo ""
    echo "3. Check the logs at: ~/hotel_checker.log"
    echo ""
    echo "4. To test the script manually, run: $RUN_SCRIPT"
    echo ""
    echo "5. To remove the cron job, run: crontab -e"
else
    echo "Cron job not added. You can manually add it later with:"
    echo "crontab -e"
    echo "Then add this line:"
    echo "42 17 * * * $RUN_SCRIPT"
fi
