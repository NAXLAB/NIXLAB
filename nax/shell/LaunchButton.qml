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

    // Hitbox extends by 4px
    MouseArea {
        id: launchHitbox
        hoverEnabled: true

        width: parent.width + 4
        height: parent.height + 4

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        onClicked: root.clicked()

        Image {
            source: parent.containsMouse ? "assets/launch-hover.svg" : "assets/launch.svg"

            width: 22
            height: 22

            sourceSize: Qt.size(22, 22)

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}