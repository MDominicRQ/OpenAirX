# Legal and redistribution information

OpenAirX is a modified derivative of **UxPlay** (https://github.com/FDH2/UxPlay), itself descended from **RPiPlay** (https://github.com/FD-/RPiPlay). This is not a clean-room rewrite or an official upstream release. The OpenAirX branding does not remove or replace any upstream copyright or license conditions.

## Source license and changes

- The OpenAirX program (the GPL-covered derived work) is licensed under **GNU GPL version 3 or, where the individual source headers permit, any later version**; refer to the existing [LICENSE](LICENSE) and each source header.
- Original upstream copyright statements must be kept, including RPiPlay authors and UxPlay's F. Duncanh and other contributors.
- **OpenAirX modifications (2026)** include app naming, GUI/launcher packaging on macOS, artwork, deployment-target and dependency build changes, release automation, and documentation. The Git history identifies modifications and dates.
- Files from external subprojects may have different compatible licenses; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). The macOS framework includes plugins and libraries not individually audited by this document.

## For anyone distributing binaries

The GPLv3 requires, among other things, preservation of notices, a copy of the license and access to **complete corresponding source for the precise binaries**, including build/install scripts. We publish an OpenAirX source snapshot with each new CI Release in addition to the public Git history. Do not assume a generic link to a newer upstream revision is equivalent to the source for the binary you are shipping.

Bundled LGPL libraries have additional license, source availability, and modification/relinking requirements. The macOS GStreamer framework is shipped as shared libraries; recipients can replace it, but may need to ad-hoc re-sign the changed app. See the LGPL text and the bundled framework's license notices.

The binary links OpenSSL 3 under **Apache-2.0**, compatible with GPLv3, and libplist, whose upstream release includes the LGPL-2.1 and GPL-2.0 license texts. The bundled GStreamer distribution contains numerous plugins and dependencies; their actual licenses and source obligations must be verified per distributed version. Patents or other rights in media codecs, and territorial legal requirements, are **separate from copyright licenses**.

## Distributor checklist

- Supply the exact OpenAirX source revision, building and packaging scripts, license texts and notices.
- Include license notices for each packaged third-party component (including GStreamer plugins and transitive libraries); verify actual packages and plugin licenses before release.
- Provide corresponding source and any required LGPL relinking information for bundled libraries. Verify precise version, patches and source availability.
- Check any codec patents, trademarks and artwork ownership/authorization applicable to your distribution.
- If you want a warning-free macOS installation, arrange Apple Developer ID signing and notarization; public CI releases are only ad-hoc signed.

## Marks and artwork

Apple, AirPlay and macOS are Apple Inc. trademarks. This project is independent of Apple and of the original UxPlay project.

The OpenAirX logo was supplied for this project and the macOS-style rounded artwork was subsequently adapted for its app. **Distribution rights to artwork cannot be independently verified by this repository**; the publisher must confirm permission to distribute and sublicense it under appropriate terms. Neither the original UxPlay authors nor Apple have endorsed this branding.

This document describes practical requirements, **not a certification of legal compliance or legal advice**. Especially before commercial redistribution, a qualified reviewer should inspect the exact GStreamer runtime contents and the complete corresponding sources.

## References

- https://www.gnu.org/licenses/gpl-3.0.html
- https://www.gnu.org/licenses/gpl-faq.html
- https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html
- https://gstreamer.freedesktop.org/documentation/frequently-asked-questions/licensing.html
- https://github.com/FDH2/UxPlay
- https://github.com/FD-/RPiPlay
