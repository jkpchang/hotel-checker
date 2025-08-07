#!/bin/bash

# Test script for hotel availability checker
# This script helps you test the program with different date ranges

echo "🏨 Hotel Availability Checker Test Script"
echo "========================================"

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "❌ Go is not installed. Please install Go 1.21 or later."
    exit 1
fi

# Check if dependencies are installed
echo "📦 Installing dependencies..."
go mod tidy

# Check if environment variables are set
if [ -z "$TWILIO_ACCOUNT_SID" ] || [ -z "$TWILIO_AUTH_TOKEN" ] || [ -z "$TWILIO_FROM_NUMBER" ] || [ -z "$TWILIO_TO_NUMBER" ]; then
    echo "⚠️  Warning: Twilio environment variables not set."
    echo "   The program will fail when trying to send SMS."
    echo "   Set these variables:"
    echo "   export TWILIO_ACCOUNT_SID='your_account_sid'"
    echo "   export TWILIO_AUTH_TOKEN='your_auth_token'"
    echo "   export TWILIO_FROM_NUMBER='your_twilio_number'"
    echo "   export TWILIO_TO_NUMBER='408-460-4822'"
    echo ""
fi

# Function to run test
run_test() {
    local check_in=$1
    local check_out=$2
    local description=$3
    
    echo ""
    echo "🧪 Testing: $description"
    echo "   Check-in: $check_in"
    echo "   Check-out: $check_out"
    echo "   ----------------------------------------"
    
    go run main.go "$check_in" "$check_out"
    
    echo "   ----------------------------------------"
    echo "   Test completed for $description"
    echo ""
}

# Test cases
echo "🚀 Starting tests..."

# Test 1: Default dates (Dec 22-25, 2025)
run_test "2025-12-22" "2025-12-25" "Default dates (Dec 22-25, 2025)"

# Test 2: Different date range for testing
run_test "2025-01-15" "2025-01-18" "January dates (Jan 15-18, 2025)"

# Test 3: Another test range
run_test "2025-02-10" "2025-02-13" "February dates (Feb 10-13, 2025)"

echo "✅ All tests completed!"
echo ""
echo "💡 Tips:"
echo "   - If you see 'Room is not available', that's expected for test dates"
echo "   - The program will only send SMS if the room is actually available"
echo "   - Check the logs above for detailed information about each request"
echo "   - To test with your own dates, run: go run main.go YYYY-MM-DD YYYY-MM-DD"
