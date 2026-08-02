// AppLauncher.qml
pragma Singleton

import Quickshell
import Quickshell.Wayland   // ToplevelManager / Toplevel (zwlr-foreign-toplevel-management)

// Single source of truth for "how do I launch or focus an app" across
// the whole shell. Lives in the project root next to shell.qml, so
// every neighboring file can reference it directly as `AppLauncher`
// with no import -- same as the Quickshell docs' Time.qml pattern.
//
// Widgets (AppButton, a future bigger start-menu tile, a taskbar, etc.)
// should only read from this and call launchOrFocus(). They shouldn't
// touch DesktopEntries or ToplevelManager directly -- that keeps the
// window-matching logic in exactly one place.
Singleton {
    id: root

    // ---- Desktop entry / icon lookup -------------------------------

    function desktopEntryFor(desktopId) {
        if (!desktopId) return null;
        return DesktopEntries.heuristicLookup(desktopId);
    }

    function nameFor(desktopId) {
        const entry = root.desktopEntryFor(desktopId);
        return entry ? entry.name : desktopId;
    }

    function iconPath(desktopId, fallback) {
        const entry = root.desktopEntryFor(desktopId);
        if (!entry || !entry.icon) return "";
        return Quickshell.iconPath(entry.icon, fallback || "image-missing");
    }

    // ---- Running-window lookup --------------------------------------

    // Every open window that belongs to `desktopId`, if any. appId
    // strings aren't perfectly standardized across toolkits (GTK, Qt,
    // Electron all do it slightly differently), so this compares
    // against both the desktop id and startupWmClass, with a couple of
    // loose fallbacks for reverse-DNS style ids (e.g. "org.mozilla.firefox").
    function toplevelsFor(desktopId) {
        if (!desktopId) return [];

        const wanted = desktopId.toLowerCase();
        const entry = root.desktopEntryFor(desktopId);
        const wmClass = (entry && entry.startupWmClass)
            ? entry.startupWmClass.toLowerCase() : "";

        const matches = [];
        for (const tl of ToplevelManager.toplevels.values) {
            const appId = (tl.appId || "").toLowerCase();
            if (!appId) continue;

            if (appId === wanted
                || (wmClass.length > 0 && appId === wmClass)
                || appId.endsWith("." + wanted)
                || wanted.endsWith("." + appId)) {
                matches.push(tl);
            }
        }
        return matches;
    }

    function isRunning(desktopId) {
        return root.toplevelsFor(desktopId).length > 0;
    }

    function isActive(desktopId) {
        return root.toplevelsFor(desktopId).some((tl) => tl.activated);
    }

    // ---- The behavior every launcher-style button wants -------------
    //
    // - 0 windows  -> launch a new instance.
    // - 1 window   -> focus it.
    // - 2+ windows -> alt-tab-style cycling: focus the window after the
    //   currently active one (wrapping around). If none of this app's
    //   windows are currently active, focus the first one.
    function launchOrFocus(desktopId) {
        const wins = root.toplevelsFor(desktopId);

        if (wins.length === 0) {
            const entry = root.desktopEntryFor(desktopId);
            if (entry) entry.execute();
            return;
        }

        if (wins.length === 1) {
            wins[0].activate();
            return;
        }

        const activeIndex = wins.findIndex((tl) => tl.activated);
        const nextIndex = activeIndex === -1 ? 0 : (activeIndex + 1) % wins.length;
        wins[nextIndex].activate();
    }
}
