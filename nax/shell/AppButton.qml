// AppButton.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

// A single pinned/running app icon in the dock.
// Lives in the same directory as Launcher.qml and AppLauncher.qml, so
// QML resolves them as types automatically -- no imports needed.
//
// This component is intentionally dumb: it just displays state and
// forwards clicks. All "is this running / focus vs launch" logic lives
// in the AppLauncher singleton, so every button style shares it.
Item {
    id: root

    // ---- Public API -----------------------------------------------------

    property string desktopId: ""
    property real iconSize: 28
    property real buttonWidth: 48

    signal rightClicked()

    readonly property bool running: AppLauncher.isRunning(root.desktopId)
    readonly property bool active: AppLauncher.isActive(root.desktopId)

    // Attached Layout properties -- works whether this is placed directly
    // in a RowLayout, or as a Repeater delegate inside one.
    Layout.preferredWidth: buttonWidth
    Layout.fillHeight: true
    implicitWidth: buttonWidth

    MouseArea {
        id: hitbox
        // Hitbox extends 4px beyond the visual bounds, same as the launcher icon.
        width: buttonWidth
        height: parent.height + 4
        anchors.centerIn: parent

        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton)
                root.rightClicked();
            else
                AppLauncher.launchOrFocus(root.desktopId);
        }

        IconImage {
            id: icon
            anchors.centerIn: parent
            implicitSize: root.iconSize
            opacity: root.running ? 1.0 : 0.5
            source: AppLauncher.iconPath(root.desktopId, root.fallbackIcon)

            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        // Active indicator bar (2px, blue, shown for the focused app)
        Rectangle {
            id: activeBar
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            width: 8
            height: 2
            radius: 13
            color: "#668cff"
            visible: root.active
        }
    }
}
