#!/bin/bash

# Update cron job with environment variables
echo "Updating crontab with environment variables..."

# Get the script path
SCRIPT_PATH="/Users/jchang/work/jc-checker/hotel/run_checker.sh"

# Create a new crontab with environment variables
cat << EOF | crontab -
# Environment variables for hotel checker
GMAIL_USER="your-email@gmail.com"
GMAIL_PASSWORD="your-app-password"
TO_EMAIL="recipient@example.com"

# Hotel availability checker - runs every day at 5:45 PM
45 17 * * * $SCRIPT_PATH
EOF

echo "Crontab updated with environment variables!"
echo ""
echo "IMPORTANT: You need to edit the crontab to set your actual Gmail credentials:"
echo "crontab -e"
echo ""
echo "Replace the placeholder values with your actual:"
echo "- GMAIL_USER"
echo "- GMAIL_PASSWORD" 
echo "- TO_EMAIL"
echo ""
echo "Current crontab:"
crontab -l
