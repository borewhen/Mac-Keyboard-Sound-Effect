#!/bin/bash

# Build script for MacKeyTalk

echo "Building MacKeyTalk..."

# Build the app
swift build -c release

if [ $? -eq 0 ]; then
    echo "Build successful!"
    echo ""
    echo "To run the app:"
    echo "  .build/release/MacKeyTalk"
    echo ""
    echo "Note: The app will request accessibility permissions on first run."
    echo "Please grant permissions in System Preferences > Security & Privacy > Privacy > Accessibility"
else
    echo "Build failed!"
    exit 1
fi 