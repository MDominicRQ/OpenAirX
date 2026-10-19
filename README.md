# OpenAirX

![OpenAirX macOS app icon](assets/OpenAirX-macos.svg)

**OpenAirX** is an open-source AirPlay screen-mirroring and audio receiver, developed as a **modified derivative of [UxPlay](https://github.com/FDH2/UxPlay)**. It is a separately branded project, not an official release of UxPlay or Apple.

OpenAirX provides downloadable, self-contained macOS applications. The receiver is based on UxPlay 1.74; its underlying AirPlay capabilities and limitations still apply.

## Download for macOS

Get the latest build from **[Releases](https://github.com/MDominicRQ/OpenAirX/releases)**:

| Mac | Minimum supported OS target | Files |
| --- | --- | --- |
| Intel (x86_64) | macOS 10.15 Catalina | `OpenAirX-*-macos-x86_64.pkg` or `.dmg` |
| Apple Silicon (arm64) | macOS 11 Big Sur | `OpenAirX-*-macos-arm64.pkg` or `.dmg` |

Use the `.pkg` to install into Applications, or open the `.dmg` and drag **OpenAirX.app** to Applications. These packages embed GStreamer, so no Homebrew or other developer tools are needed on the receiving Mac.

**Important:** CI builds with these deployment targets and checks binary dependencies and startup; it does **not** replace a real AirPlay test on a Catalina Mac. CI builds are **not notarized** by Apple. macOS Gatekeeper may require **Open Anyway** for a trusted download.

## Use

1. Open **OpenAirX** in Applications.
2. Put the Mac and sending iPhone/iPad/Mac on a network supporting Bonjour/mDNS.
3. Open **Screen Mirroring** on the sending device and select **OpenAirX**.
4. Allow incoming connections and local-network access if macOS asks.

To see command-line options or require a PIN:

```sh
/Applications/OpenAirX.app/Contents/MacOS/OpenAirX -h
/Applications/OpenAirX.app/Contents/MacOS/OpenAirX -pin
```

AirPlay discovery and playback depend on the network and codecs. Copy-protected/DRM media is not guaranteed to work. See [macOS installation and troubleshooting](docs/macos-standalone.md).

## Build from source

```sh
git clone https://github.com/MDominicRQ/OpenAirX.git
cd OpenAirX
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel
./build/OpenAirX -h
```

CMake requires development packages for GStreamer, OpenSSL and libplist; available packages vary by platform. The [.github/workflows](.github/workflows) directory contains tested CI build recipes. The precompiled macOS bundle is assembled by [scripts/macos/package-app.sh](scripts/macos/package-app.sh).

## Project, licenses and attribution

OpenAirX is **a derivative work of UxPlay**, which itself builds on RPiPlay. Original copyright and license notices remain applicable. **OpenAirX's program source is available under GPL-3.0-or-later**, with differently licensed third-party components identified separately. Redistributing binaries requires complying with those licenses and providing the corresponding source.

Read [LEGAL.md](LEGAL.md) and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) before redistribution. [The original upstream README](docs/README-UxPlay-upstream.md) is retained for historical attribution and more detailed UxPlay behavior; it is not OpenAirX's installation guide.

**Not affiliated with or endorsed by Apple Inc. or the UxPlay maintainers.** AirPlay, Apple and macOS are trademarks of Apple Inc.
