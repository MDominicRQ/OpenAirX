#!/usr/bin/env bash
set -euo pipefail
# package-app.sh <compiled-openairx> <arch> <minimum-macos>
binary="$1"
arch="$2"
minimum="$3"
version="1.74.0"
fw="/Library/Frameworks/GStreamer.framework"
out="$PWD/dist"
name="OpenAirX-$version-macos-$arch"
app="$out/OpenAirX.app"
test -f "$binary"
test -d "$fw/Versions/Current/lib/gstreamer-1.0"
test -f "$fw/Versions/Current/libexec/gstreamer-1.0/gst-plugin-scanner"
mkdir -p "$out"
rm -rf "$app"
mkdir -p "$app/Contents/MacOS" "$app/Contents/Frameworks" "$app/Contents/Resources"
ditto "$fw" "$app/Contents/Frameworks/GStreamer.framework"
ditto "$binary" "$app/Contents/MacOS/openairx-bin"

# Strip only SDK material from the copied official runtime.
bundled="$app/Contents/Frameworks/GStreamer.framework"
rm -rf "$bundled/Headers" "$bundled/Versions/Current/include"
find "$bundled" -type f \( -name '*.a' -o -name '*.la' -o -name '*.pc' \) -delete
clang -std=c11 -Wall -Wextra -Werror -O2 \
  -mmacosx-version-min="$minimum" scripts/macos/launcher.c \
  -o "$app/Contents/MacOS/OpenAirX"

# Generate a complete macOS .icns from the bundled logo.
logo="$PWD/assets/openairx-logo.jpg"
iconset="$out/OpenAirX.iconset"
rm -rf "$iconset"
mkdir -p "$iconset"
for spec in "16:icon_16x16.png" "32:icon_16x16@2x.png" "32:icon_32x32.png" "64:icon_32x32@2x.png" "128:icon_128x128.png" "256:icon_128x128@2x.png" "256:icon_256x256.png" "512:icon_256x256@2x.png" "512:icon_512x512.png" "1024:icon_512x512@2x.png"; do
  dimension="${spec%%:*}"
  icon_file="${spec#*:}"
  sips -s format png -z "$dimension" "$dimension" "$logo" \
    --out "$iconset/$icon_file" >/dev/null
done
iconutil -c icns -o "$app/Contents/Resources/OpenAirX.icns" "$iconset"
rm -rf "$iconset"
test -s "$app/Contents/Resources/OpenAirX.icns"

cp LICENSE "$app/Contents/Resources/LICENSE-OpenAirX.txt"
cp docs/macos-standalone.md "$app/Contents/Resources/README-macOS.md"
APP_PLIST="$app/Contents/Info.plist" APP_VERSION="$version" APP_MIN_OS="$minimum" \
  python3 - <<'PY'
import os, plistlib
from pathlib import Path
info = {
    "CFBundleDevelopmentRegion": "en",
    "CFBundleExecutable": "OpenAirX",
    "CFBundleIdentifier": "com.mdominicrq.openairx",
    "CFBundleInfoDictionaryVersion": "6.0",
    "CFBundleName": "OpenAirX",
    "CFBundleDisplayName": "OpenAirX",
    "CFBundleIconFile": "OpenAirX.icns",
    "CFBundlePackageType": "APPL",
    "CFBundleShortVersionString": os.environ["APP_VERSION"],
    "CFBundleVersion": os.environ["APP_VERSION"],
    "LSMinimumSystemVersion": os.environ["APP_MIN_OS"],
    "NSHighResolutionCapable": True,
    "NSLocalNetworkUsageDescription": "OpenAirX receives AirPlay video and audio from devices on your local network.",
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
ditto "$app" "$root/OpenAirX.app"
pkgbuild --root "$root" --install-location "/Applications" \
  --identifier "com.mdominicrq.openairx" --version "$version" "$out/$name.pkg"
rm -rf "$root"
# A conventional drag-to-Applications disk image; do not use the .app
# as -srcfolder, as that can expose only its Contents directory.
dmg_root="$out/dmg-root"
rm -rf "$dmg_root"
mkdir -p "$dmg_root"
ditto "$app" "$dmg_root/OpenAirX.app"
ln -s /Applications "$dmg_root/Applications"
hdiutil create -quiet -volname OpenAirX -srcfolder "$dmg_root" \
  -ov -format UDZO "$out/$name.dmg"
rm -rf "$dmg_root"
(cd "$out" && shasum -a 256 "$name.pkg" "$name.dmg" > "$name.sha256")
ls -lh "$out/$name.pkg" "$out/$name.dmg"
