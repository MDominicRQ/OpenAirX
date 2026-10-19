#!/usr/bin/env python3
"""Static packaging checks; real Catalina and AirPlay clients need live tests."""
import os
import plistlib
import re
import subprocess
import sys
from pathlib import Path

def cmd(*args):
    return subprocess.check_output(args, text=True, stderr=subprocess.STDOUT)

def audit(app, arch, minimum):
    contents = app / "Contents"
    framework = contents / "Frameworks/GStreamer.framework"
    main = contents / "MacOS/openairx-bin"
    launcher = contents / "MacOS/OpenAirX"
    assert framework.is_dir() and main.is_file() and launcher.is_file()
    with (contents / "Info.plist").open("rb") as source:
        info = plistlib.load(source)
        assert info["LSMinimumSystemVersion"] == minimum
        assert info["CFBundleExecutable"] == "OpenAirX"
        assert info["CFBundleIconFile"] == "OpenAirX.icns"
    assert (contents / "Resources/OpenAirX.icns").stat().st_size > 1024
    for file in (main, launcher):
        supported = cmd("lipo", "-archs", str(file)).split()
        assert arch in supported, (file, supported)
        build = cmd("vtool", "-show-build", "-arch", arch, str(file))
        versions = re.findall(r"^\s*minos\s+(\d+\.\d+(?:\.\d+)?)", build, re.M)
        if not versions:
            raise RuntimeError("No minos in vtool output for " + str(file) + "\n" + build)
        found = tuple(map(int, versions[0].split(".")))
        target = tuple(map(int, minimum.split(".")))
        if found > target:
            raise RuntimeError(f"{file} targets macOS {found} (> {target})")

    candidates = [main, launcher]
    for base, dirs, files in os.walk(framework):
        for filename in files:
            file = Path(base, filename)
            if file.is_symlink():
                continue
            if file.suffix in (".dylib", ".so") or filename in (
                "gst-plugin-scanner", "gst-inspect-1.0", "gst-launch-1.0"):
                candidates.append(file)
    errors = []
    for file in candidates:
        try:
            output = cmd("otool", "-L", str(file))
        except subprocess.CalledProcessError:
            if file in (main, launcher):
                raise
            continue
        for dep in re.findall(r"^\s+(\S+)\s+\(compatibility version", output, re.M):
            if dep.startswith(("/usr/lib/", "/System/Library/", "@")):
                continue
            if dep.startswith("/"):
                errors.append(f"{file}: external dependency {dep}")
    if errors:
        raise RuntimeError("Bundle is not standalone:\n" + "\n".join(errors[:60]))
    rpaths = cmd("otool", "-l", str(main))
    if "@executable_path/../Frameworks/GStreamer.framework/" not in rpaths:
        raise RuntimeError("Main binary has no embedded GStreamer LC_RPATH")
    print(f"Audit passed for {arch}, minimum macOS {minimum}, {len(candidates)} Mach-O files")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        sys.exit("usage: audit-app.py <app> <arch> <minimum>")
    audit(Path(sys.argv[1]), sys.argv[2], sys.argv[3])
