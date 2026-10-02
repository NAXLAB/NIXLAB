// LaunchButton.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Item {
    id: root
    Layout.preferredWidth: 64
    Layout.fillHeight: true

    signal clicked()

    // Extends 4px toward the top-left only -- that's the one direction
    // where a real gap (and real window surface, per LauncherBar.qml)
    // actually exists. Extending right/bottom too wouldn't cause a bug,
    // but there's no gap there for it to usefully reach.
    MouseArea {
        id: launchHitbox
        hoverEnabled: true

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: -4
        }

        onClicked: root.clicked()

        Image {
            id: launchImage
            source: launchHitbox.containsMouse ? "assets/launch-hover.svg" : "assets/launch.svg"
            width: 22
            height: 22
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
