# Third-party components and notices

OpenAirX's core remains based on **UxPlay** and **RPiPlay** with the relevant original copyright statements kept in the sources.

| Component | Source | License and notice |
| --- | --- | --- |
| UxPlay (base work) | https://github.com/FDH2/UxPlay | GPL-3.0-or-later where indicated by upstream source headers; retain author notices and original history |
| RPiPlay (upstream lineage) | https://github.com/FD-/RPiPlay | Source copyright and applicable GPL conditions carried through UxPlay |
| llhttp | https://github.com/nodejs/llhttp | MIT; exact text at [lib/llhttp/LICENSE-MIT](lib/llhttp/LICENSE-MIT) |
| OpenSSL 3.5.8 | https://www.openssl.org/source/ | Apache-2.0; [license text](legal/licenses/OpenSSL-Apache-2.0.txt) |
| libplist 2.6.0 | https://github.com/libimobiledevice/libplist | Upstream includes LGPL-2.1 and GPL-2.0 notices; [LGPL-2.1](legal/licenses/libplist-LGPL-2.1.txt), [GPL-2.0](legal/licenses/libplist-GPL-2.0.txt). Verify file-level licensing. |
| GStreamer 1.26.11 and included plugins | https://gstreamer.freedesktop.org/ | Core LGPL-2.1; [license text](legal/licenses/GStreamer-LGPL-2.1.txt). **Individual plugins and dependencies may use different licenses**; inspect upstream packages and the exact macOS framework. |

The binary builds use macOS's native Bonjour and system libraries where available. Platform and transitive dependencies may require their own notices.

The CI packaging process copies these license texts into `OpenAirX.app/Contents/Resources/Licenses`; a source snapshot is attached to each new GitHub Release. Merely adding these notices is **not proof** that the redistributed GStreamer runtime, third-party code, codec patents or artwork have been completely cleared. See [LEGAL.md](LEGAL.md).
