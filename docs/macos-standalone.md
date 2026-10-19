# Standalone UxPlay installers for macOS

Once a successful GitHub Actions build finishes, download its installer
artifact from the **Standalone macOS installers** workflow. Version-tagged
releases publish the actual .pkg and .dmg files to **Releases**.

**Supported CPU/OS targets**

- Intel x86_64: macOS 10.15 Catalina and later.
- Apple Silicon arm64: macOS 11 Big Sur and later (Catalina cannot run on ARM Macs).

Install the .pkg to place UxPlay.app into /Applications, or open the .dmg
and drag UxPlay.app to Applications. These builds bundle GStreamer and
link OpenSSL/libplist statically, so the recipient does not need Homebrew,
GStreamer, Xcode, or a compiler.

Open **UxPlay** in Applications, keep your Mac and the sending iPhone,
iPad or Mac on the same Bonjour/mDNS-capable network, then choose the
UxPlay receiver in Screen Mirroring. Grant macOS local-network permission
and incoming connection/firewall permission when asked.

**Gatekeeper:** The public GitHub Actions build uses an **ad-hoc
signature, not Apple notarization**. On macOS, Finder may block the .pkg
or .app at first launch. From a trusted download, control-click → Open,
or allow the blocked app in System Settings → Privacy & Security. Fully
frictionless double-click distribution requires Developer ID signing and
Apple notarization, which are not possible without the owner's credentials.

For help, troubleshooting output and PIN mode use Terminal:

    /Applications/UxPlay.app/Contents/MacOS/UxPlay -h
    /Applications/UxPlay.app/Contents/MacOS/UxPlay -pin

The app wrapper defaults to -vsync no (recommended for macOS), with
user CLI flags passed after it. To configure options used on each launch,
see upstream ~/.uxplayrc documentation.

## Build and test guarantees

The CI builds against macOS deployment target 10.15 (Intel) and 11.0
(Apple Silicon) with official universal GStreamer 1.26, plus target-built
OpenSSL and libplist static archives. It audits Mach-O architectures,
minimum deployment version, external dependencies, bundle signatures,
CLI launch and required runtime GStreamer plugins. GStreamer's official
macOS runtime itself supports versions back to macOS 10.13.

A green CI run is **not** a real Mac running Catalina: it cannot prove
AirPlay/mDNS connectivity, video playback, audio, or OS compatibility
on real Catalina hardware. These need an end-to-end device test.

## Release

After merging and checking the CI results, push a tag like
v1.74.0-macos.1. The workflow publishes both architectures' .pkg
and .dmg installers in GitHub Releases.

UxPlay is GPL-3.0; see LICENSE and upstream source. Bundled GStreamer
components have additional open-source licenses; review these when
redistributing binaries.
