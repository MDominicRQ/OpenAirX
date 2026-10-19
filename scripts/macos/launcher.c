/*
 * Finder-compatible executable for self-contained UxPlay.app (GPL-3.0).
 */
#define _DARWIN_C_SOURCE 1
#include <mach-o/dyld.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static int join(char *dest, size_t cap, const char *base, const char *suffix) {
    int n = snprintf(dest, cap, "%s/%s", base, suffix);
    return n >= 0 && (size_t)n < cap ? 0 : -1;
}
static int bundle_env(const char *fw, const char *key, const char *suffix) {
    char value[PATH_MAX];
    if (join(value, sizeof(value), fw, suffix)) return -1;
    return setenv(key, value, 1);
}
int main(int argc, char **argv) {
    char path[PATH_MAX];
    uint32_t cap = sizeof(path);
    if (_NSGetExecutablePath(path, &cap) != 0) {
        fputs("UxPlay: executable path too long\n", stderr);
        return 1;
    }
    char *slash = strrchr(path, '/');
    if (!slash) return 1;
    *slash = 0;
    char fw[PATH_MAX], binary[PATH_MAX];
    if (join(fw, sizeof(fw), path, "../Frameworks/GStreamer.framework") ||
        join(binary, sizeof(binary), path, "uxplay-bin")) return 1;
    if (bundle_env(fw, "GST_PLUGIN_SYSTEM_PATH_1_0", "Versions/Current/lib/gstreamer-1.0") ||
        bundle_env(fw, "GST_PLUGIN_SCANNER", "Versions/Current/libexec/gstreamer-1.0/gst-plugin-scanner") ||
        bundle_env(fw, "GIO_EXTRA_MODULES", "Versions/Current/lib/gio/modules") ||
        bundle_env(fw, "GSETTINGS_SCHEMA_DIR", "Versions/Current/share/glib-2.0/schemas")) {
        perror("UxPlay: setenv");
        return 1;
    }
    if (setenv("GST_PLUGIN_PATH_1_0", "", 1)) return 1;
    /* macOS GStreamer works more reliably with this documented default.
       User-supplied arguments follow and can override it. */
    char **args = calloc((size_t)argc + 3, sizeof(*args));
    if (!args) return 1;
    args[0] = binary;
    args[1] = "-vsync";
    args[2] = "no";
    for (int i = 1; i < argc; ++i) args[i + 2] = argv[i];
    args[argc + 2] = NULL;
    execv(binary, args);
    perror("UxPlay: cannot execute uxplay-bin");
    free(args);
    return 1;
}
