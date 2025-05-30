#!/usr/bin/env bash
#
# capture_screenshots.sh — App Store-style screenshots of every demo screen.
#
# Usage:
#   Scripts/capture_screenshots.sh ["iPhone 17"]
#
# Builds the app (Debug), then uses the DEBUG-only SCREENSHOT_SECTION launch hook
# in ContentView to open each screen directly and grab a clean screenshot via
# simctl. Output: .github/screenshots/.
#
set -euo pipefail

DEVICE_NAME="${1:-iPhone 17}"
SCHEME="SFSymbolLab"
PROJECT="SFSymbolLab.xcodeproj"
BUNDLE="com.blerdfoniqi.SFSymbolLab"
OUT=".github/screenshots"
DEST="platform=iOS Simulator,name=${DEVICE_NAME},OS=latest"

echo "▸ Building ${SCHEME} (Debug) for ${DEVICE_NAME}…"
xcodebuild build -project "$PROJECT" -scheme "$SCHEME" -configuration Debug \
  -destination "$DEST" CODE_SIGNING_ALLOWED=NO >/dev/null

DEV="$(xcrun simctl list devices available | grep -m1 "${DEVICE_NAME} (" | grep -oE '[0-9A-F-]{36}')"
APP="$(find ~/Library/Developer/Xcode/DerivedData -maxdepth 6 -name "${SCHEME}.app" -path '*Debug-iphonesimulator*' | head -1)"
[ -n "$DEV" ] && [ -n "$APP" ] || { echo "✗ Could not locate simulator or built app." >&2; exit 1; }

echo "▸ Booting ${DEVICE_NAME} (${DEV})…"
xcrun simctl boot "$DEV" 2>/dev/null || true
xcrun simctl bootstatus "$DEV" >/dev/null
xcrun simctl install "$DEV" "$APP"
xcrun simctl status_bar "$DEV" override --time "9:41" --batteryState charged \
  --batteryLevel 100 --cellularBars 4 --wifiBars 3 --dataNetwork wifi 2>/dev/null || true

mkdir -p "$OUT"

shoot() { # shoot <output-name> [section-rawValue]
  local name="$1" section="${2:-}"
  xcrun simctl terminate "$DEV" "$BUNDLE" >/dev/null 2>&1 || true
  if [ -z "$section" ]; then
    xcrun simctl launch "$DEV" "$BUNDLE" >/dev/null
  else
    SIMCTL_CHILD_SCREENSHOT_SECTION="$section" xcrun simctl launch "$DEV" "$BUNDLE" >/dev/null
  fi
  sleep 2
  xcrun simctl io "$DEV" screenshot "$OUT/$name.png" >/dev/null
  echo "  ✓ $name"
}

shoot home
shoot rendering-modes  renderingModes
shoot color-variations colorVariations
shoot animations       symbolAnimations
shoot variable-symbols variableSymbols
shoot transformations  symbolTransformations
shoot playground       playground
shoot best-practices   bestPractices

xcrun simctl status_bar "$DEV" clear 2>/dev/null || true
echo "▸ Done → ${OUT}"
