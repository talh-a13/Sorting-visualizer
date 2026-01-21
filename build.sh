#!/bin/bash
# Vercel build script for Flutter Web

# Exit on error
set -e

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "Flutter not found. Installing Flutter..."
    
    # Clone Flutter
    git clone https://github.com/flutter/flutter.git -b stable --depth 1 /tmp/flutter
    export PATH="$PATH:/tmp/flutter/bin"
    
    # Run Flutter doctor
    flutter doctor -v
fi

# Build the web app
flutter build web --release

echo "Build complete!"
