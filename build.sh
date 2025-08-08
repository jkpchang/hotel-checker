#!/bin/bash

# Build script for hotel checker
echo "Building hotel checker binary..."

# Check if Go is available
if ! command -v go &> /dev/null; then
    echo "ERROR: Go is not installed or not in PATH"
    exit 1
fi

# Build the binary
echo "Running: go build -o hotel_checker main.go"
if go build -o hotel_checker main.go; then
    echo "✅ Binary built successfully: hotel_checker"
    echo "File size: $(ls -lh hotel_checker | awk '{print $5}')"
    echo "Permissions: $(ls -l hotel_checker | awk '{print $1}')"
else
    echo "❌ Build failed"
    exit 1
fi

echo ""
echo "To test the binary:"
echo "./hotel_checker"
