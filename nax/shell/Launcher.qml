// Launcher.qml
import Quickshell
import Quickshell.Io
import QtQuick

Scope {
  id: root

  Variants {
    model: Quickshell.screens

        PanelWindow {

            required property var modelData
            screen: modelData

            implicitHeight: 48
            implicitWidth: childrenRect.width
            color: "transparent"

            anchors {
                bottom: true
                left: true
            }

            //Launcher Bar
            Rectangle {
                id: launcher

                anchors {
                    left:true
                    verticalCenter:parent.verticalCenter
                }

                margin: 4

                width: childrenRect.width
                height: 40
                radius: 8

                color: "#0e0f11"

                //State Handling for launcher
                states: [
                State {
                    name: "bar"
                    PropertyChanges { target: shelf; visible: false }
                    PropertyChanges { target: search; visible: false }
                    PropertyChanges { target: controls; visible: false }
                },
                State {
                    name: "launcher"
                    PropertyChanges { target: shelf; visible: true }
                    PropertyChanges { target: search; visible: true }
                    PropertyChanges { target: controls; visible: false }                    
                    PropertyChanges { target: root; width: 500; height: 300 }
                }
            ]

                //Column Layout stacks rows of items
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    //Dock Row
                    RowLayout {
                        id: dock-row
                        anchors.fill: parent
                        spacing: 8
                        
                        // Launcher Icon 
                        Item {
                            id: launchericon
                            Layout.preferredWidth: 42
                            Layout.fillHeight: true

                            // Hitbox extends by 4px
                            MouseArea {
                                id: launch-hitbox
                                hoverEnabled: true

                                width: parent.width + 4   
                                height: parent.height + 4

                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter

                                onClicked: { /* open launcher */ }
                            
                                Image {
                                    source: containsMouse ? "assets/launch-hover.svg" : "assets/launch.svg"

                                    width: 24
                                    height: 24

                                    sourceSize: Qt.size(24, 24)

                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }

                        // Divider
                        Rectangle {
                            Layout.preferredWidth: 1
                            Layout.preferredHeight: 24
                            Layout.alignment: Qt.AlignVCenter
                            color: "#353540"
                        }

                        // App Icon Buttons
                        
                        Item {
                            id: appbutton
                            implicitWidth: 48
                            Layout.fillHeight: true

                            MouseArea {
                                width: parent.width + 4   
                                height: parent.height + 4
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter

                                // Active indicator bar (2px, blue, shown when app is active)
                                Rectangle {
                                    id: activeBar1
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.bottom
                                    width: 8
                                    height: 2
                                    radius: 13
                                    color: "#668cff"
                                    visible: true   // toggle per app state
                                }

                                // App icon — swap source for your real icon
                                Image {
                                    anchors.centerIn: parent
                                    width: 24
                                    height: 24
                                    source: ""      // e.g. "icons/firefox.svg"
                                    fillMode: Image.PreserveAspectFit
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: { /* focus / launch app 1 */ }
                                }
                            }
                        }

                        Item {
                            id: appIcon2
                            Layout.preferredWidth: 42
                            Layout.fillHeight: true

                            Item {
                                width: 42
                                height: 44
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter

                                Rectangle {
                                    id: activeBar2
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.bottom
                                    width: 8
                                    height: 2
                                    radius: 13
                                    color: "#668cff"
                                    visible: true
                                }

                                Image {
                                    anchors.centerIn: parent
                                    width: 24
                                    height: 24
                                    source: ""
                                    fillMode: Image.PreserveAspectFit
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: { /* focus / launch app 2 */ }
                                }
                            }
                        }

                        Item {
                            id: appIcon3
                            Layout.preferredWidth: 42
                            Layout.fillHeight: true

                            Item {
                                width: 42
                                height: 44
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter

                                // No active bar on this slot (third icon had none in the HTML)

                                Image {
                                    anchors.centerIn: parent
                                    width: 24
                                    height: 24
                                    source: ""
                                    fillMode: Image.PreserveAspectFit
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: { /* focus / launch app 3 */ }
                                }
                            }
                        }

                        Item {
                            id: appIcon4
                            Layout.preferredWidth: 42
                            Layout.fillHeight: true

                            Item {
                                width: 42
                                height: 44
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter

                                Image {
                                    anchors.centerIn: parent
                                    width: 24
                                    height: 24
                                    source: ""
                                    fillMode: Image.PreserveAspectFit
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: { /* focus / launch app 4 */ }
                                }
                            }
                        }

                        // ── Divider ─────────────────────────────────────────────────────
                        Rectangle {
                            Layout.preferredWidth: 1
                            Layout.preferredHeight: 25
                            Layout.alignment: Qt.AlignVCenter
                            color: "#353540"
                        }

                        // ── Search bar (fills remaining space) ──────────────────────────
                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.topMargin: 4
                            Layout.bottomMargin: 4
                            Layout.rightMargin: 4

                            Rectangle {
                                id: searchBar
                                anchors.fill: parent
                                color: "#292a33"
                                radius: 4

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 8
                                    anchors.rightMargin: 8
                                    spacing: 8

                                    // Search / magnifier icon
                                    Canvas {
                                        id: searchIcon
                                        Layout.preferredWidth: 16
                                        Layout.preferredHeight: 16
                                        Layout.alignment: Qt.AlignVCenter
                                        onPaint: {
                                            var ctx = getContext("2d");
                                            ctx.clearRect(0, 0, width, height);
                                            ctx.strokeStyle = "#9C9DBF";
                                            ctx.lineWidth = 1.2;
                                            ctx.lineCap = "round";
                                            ctx.lineJoin = "round";
                                            // circle
                                            ctx.beginPath();
                                            ctx.arc(8.667, 8, 5.333, 0, Math.PI * 2);
                                            ctx.stroke();
                                            // handle
                                            ctx.beginPath();
                                            ctx.moveTo(1.999, 14.667);
                                            ctx.lineTo(4.899, 11.767);
                                            ctx.stroke();
                                        }
                                    }

                                    // Placeholder text — replace with TextInput for real input
                                    Text {
                                        id: searchPlaceholder
                                        Layout.fillWidth: true
                                        text: "nax@lab"
                                        color: "#9c9dbf"
                                        font.pixelSize: 14
                                        verticalAlignment: Text.AlignVCenter
                                        elide: Text.ElideRight
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: { /* open search / focus input */ }
                                }
                            }
                        }
                    }

                }

            }
        }
    }
}
