#!/bin/sh
# Xcode Cloud — runs after the repository is cloned. Installs Flutter and CocoaPods deps.
# Configure the workflow in Xcode: Report navigator → Cloud, or https://developer.apple.com/xcode-cloud/
set -e

cd "${CI_PRIMARY_REPOSITORY_PATH:-.}"

# Install Flutter SDK (stable).
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "${HOME}/flutter"
export PATH="${PATH}:${HOME}/flutter/bin"

flutter precache --ios
flutter pub get

# CocoaPods (Xcode Cloud macOS images).
export HOMEBREW_NO_AUTO_UPDATE=1
if ! command -v pod >/dev/null 2>&1; then
  brew install cocoapods
fi

cd ios
pod install --repo-update

exit 0
