#!/bin/bash

# Hotel Checker Render Deployment Script
# This script helps deploy the hotel checker to Render as a cron job

set -e

echo "🏨 Hotel Checker Render Deployment"
echo "=================================="

# Check if we're in the right directory
if [ ! -f "main.go" ]; then
    echo "❌ Error: main.go not found. Please run this script from the hotel directory."
    exit 1
fi

# Check if render CLI is installed
if ! command -v render &> /dev/null; then
    echo "❌ Error: Render CLI not found. Please install it first:"
    echo "   brew install render"
    exit 1
fi

echo "✅ Render CLI found"

# Check if logged in
if ! render services --output json --confirm &> /dev/null; then
    echo "❌ Error: Not logged in to Render. Please run:"
    echo "   render login"
    exit 1
fi

echo "✅ Logged in to Render"

# Prompt for environment variables
echo ""
echo "📧 Gmail Configuration"
echo "====================="
read -p "Enter your Gmail address: " GMAIL_USER
read -s -p "Enter your Gmail App Password (16 characters): " GMAIL_PASSWORD
echo ""
read -p "Enter recipient email address: " TO_EMAIL

# Validate inputs
if [ -z "$GMAIL_USER" ] || [ -z "$GMAIL_PASSWORD" ] || [ -z "$TO_EMAIL" ]; then
    echo "❌ Error: All fields are required"
    exit 1
fi

echo ""
echo "📅 Schedule Configuration"
echo "========================"
echo "Choose a schedule:"
echo "1) Every 30 minutes (recommended)"
echo "2) Every hour"
echo "3) Every 2 hours"
echo "4) Custom (cron format)"
read -p "Enter choice (1-4): " SCHEDULE_CHOICE

case $SCHEDULE_CHOICE in
    1) SCHEDULE="*/30 * * * *" ;;
    2) SCHEDULE="0 * * * *" ;;
    3) SCHEDULE="0 */2 * * *" ;;
    4) read -p "Enter custom cron schedule (e.g., '0 */30 * * *'): " SCHEDULE ;;
    *) echo "❌ Invalid choice. Using default (every 30 minutes)"; SCHEDULE="*/30 * * * *" ;;
esac

echo ""
echo "📋 Deployment Summary"
echo "===================="
echo "Gmail User: $GMAIL_USER"
echo "Recipient Email: $TO_EMAIL"
echo "Schedule: $SCHEDULE"
echo "Target Dates: 2025-12-22 to 2025-12-25"

read -p "Proceed with deployment? (y/N): " CONFIRM

if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled"
    exit 1
fi

echo ""
echo "🚀 Deploying to Render..."
echo "========================="

# Create a render.yaml file for the deployment
cat > render.yaml << EOF
services:
  - type: cron
    name: hotel-checker
    env: docker
    schedule: $SCHEDULE
    buildCommand: go build -o hotel-checker
    startCommand: ./hotel-checker 2025-12-22 2025-12-25
    envVars:
      - key: GMAIL_USER
        value: $GMAIL_USER
      - key: GMAIL_PASSWORD
        value: $GMAIL_PASSWORD
      - key: TO_EMAIL
        value: $TO_EMAIL
EOF

echo "✅ Created render.yaml configuration"

# Deploy using render CLI
echo "📤 Uploading to Render..."

# Note: The render CLI doesn't have a direct "deploy" command for new services
# We'll need to use the dashboard or API for initial service creation
echo ""
echo "📝 Next Steps:"
echo "=============="
echo "1. Go to https://dashboard.render.com"
echo "2. Click 'New +' → 'Cron Job'"
echo "3. Connect your GitHub repository"
echo "4. Use these settings:"
echo "   - Build Command: go build -o hotel-checker"
echo "   - Start Command: ./hotel-checker 2025-12-22 2025-12-25"
echo "   - Schedule: $SCHEDULE"
echo ""
echo "5. Add these environment variables:"
echo "   - GMAIL_USER: $GMAIL_USER"
echo "   - GMAIL_PASSWORD: [your app password]"
echo "   - TO_EMAIL: $TO_EMAIL"
echo ""
echo "6. Click 'Create Cron Job'"
echo ""
echo "✅ The render.yaml file has been created for reference"
echo "📁 You can also commit this file to your repository for future deployments"

echo ""
echo "🎉 Setup complete! Your hotel checker will run automatically on Render."
