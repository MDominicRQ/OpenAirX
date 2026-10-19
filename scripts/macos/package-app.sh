#!/usr/bin/env bash
set -euo pipefail
# package-app.sh <compiled-uxplay> <arch> <minimum-macos>
binary="$1"
arch="$2"
minimum="$3"
version="1.74.0"
fw="/Library/Frameworks/GStreamer.framework"
out="$PWD/dist"
name="UxPlay-$version-macos-$arch"
app="$out/UxPlay.app"
test -f "$binary"
test -d "$fw/Versions/Current/lib/gstreamer-1.0"
test -f "$fw/Versions/Current/libexec/gstreamer-1.0/gst-plugin-scanner"
mkdir -p "$out"
rm -rf "$app"
mkdir -p "$app/Contents/MacOS" "$app/Contents/Frameworks" "$app/Contents/Resources"
ditto "$fw" "$app/Contents/Frameworks/GStreamer.framework"
ditto "$binary" "$app/Contents/MacOS/uxplay-bin"

# Strip only SDK material from the copied official runtime.
bundled="$app/Contents/Frameworks/GStreamer.framework"
rm -rf "$bundled/Headers" "$bundled/Versions/Current/include"
find "$bundled" -type f \( -name '*.a' -o -name '*.la' -o -name '*.pc' \) -delete
clang -std=c11 -Wall -Wextra -Werror -O2 \
  -mmacosx-version-min="$minimum" scripts/macos/launcher.c \
  -o "$app/Contents/MacOS/UxPlay"

cp LICENSE "$app/Contents/Resources/LICENSE-UxPlay.txt"
cp docs/macos-standalone.md "$app/Contents/Resources/README-macOS.md"
APP_PLIST="$app/Contents/Info.plist" APP_VERSION="$version" APP_MIN_OS="$minimum" \
  python3 - <<'PY'
import os, plistlib
from pathlib import Path
info = {
    "CFBundleDevelopmentRegion": "en",
    "CFBundleExecutable": "UxPlay",
    "CFBundleIdentifier": "com.mdominicrq.uxplay",
    "CFBundleInfoDictionaryVersion": "6.0",
    "CFBundleName": "UxPlay",
    "CFBundleDisplayName": "UxPlay",
    "CFBundlePackageType": "APPL",
    "CFBundleShortVersionString": os.environ["APP_VERSION"],
    "CFBundleVersion": os.environ["APP_VERSION"],
    "LSMinimumSystemVersion": os.environ["APP_MIN_OS"],
    "NSHighResolutionCapable": True,
    "NSLocalNetworkUsageDescription": "UxPlay receives AirPlay video and audio from devices on your local network.",
    "NSBonjourServices": ["_airplay._tcp", "_raop._tcp"],
}
with Path(os.environ["APP_PLIST"]).open("wb") as stream:
    plistlib.dump(info, stream)
PY

python3 scripts/macos/audit-app.py "$app" "$arch" "$minimum"
# Ad-hoc signature: distribution notarization needs real Apple credentials.
codesign --force --deep --sign - "$app"
codesign --verify --deep --strict --verbose=2 "$app"

root="$out/package-root"
rm -rf "$root"
mkdir -p "$root"
ditto "$app" "$root/UxPlay.app"
pkgbuild --root "$root" --install-location "/Applications" \
  --identifier "com.mdominicrq.uxplay" --version "$version" "$out/$name.pkg"
rm -rf "$root"
hdiutil create -quiet -volname UxPlay -srcfolder "$app" \
  -ov -format UDZO "$out/$name.dmg"
(cd "$out" && shasum -a 256 "$name.pkg" "$name.dmg" > "$name.sha256")
ls -lh "$out/$name.pkg" "$out/$name.dmg"
