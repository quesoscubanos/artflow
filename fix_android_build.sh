#!/bin/bash

# Script to fix Android build issues in Flutter project
# Accepts all pending Android SDK licenses and ensures required packages are installed

# Set Android SDK path (adjust if different)
export ANDROID_HOME=/home/yeferson/android-sdk

# Add Android SDK tools to PATH
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH

# Check if Java is available (required for sdkmanager)
if ! command -v java &> /dev/null; then
    echo "Java is not installed or not in PATH. Please install Java JDK 11 or higher."
    exit 1
fi

echo "Accepting all Android SDK licenses..."
# Automatically accept all licenses
yes | sdkmanager --licenses

echo "Checking and installing required Android SDK packages..."

# Install essential packages (adjust versions as needed)
sdkmanager "platform-tools"
sdkmanager "build-tools;34.0.0"
sdkmanager "platforms;android-34"
sdkmanager "ndk;27.0.12077973"

echo "Cleaning Flutter project cache..."
flutter clean

echo "Cleaning Gradle cache..."
cd android && ./gradlew clean && cd ..

echo "Pre-downloading dependencies..."
flutter pub get

echo "Android build setup complete. You can now try building your Flutter app."
echo "If issues persist, ensure ANDROID_HOME is set in your shell profile (e.g., ~/.bashrc):"
echo "export ANDROID_HOME=/home/yeferson/android-sdk"
echo "export PATH=\$ANDROID_HOME/cmdline-tools/latest/bin:\$PATH"