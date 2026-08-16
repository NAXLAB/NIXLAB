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

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: -4
        anchors.bottomMargin: -4
        anchors.topMargin: -4
        anchors.rightMargin: -4

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