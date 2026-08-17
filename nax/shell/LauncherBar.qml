// LauncherBar.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland

Scope {
  id: root

  Variants {
    model: Quickshell.screens

        PanelWindow {

            required property var modelData
            screen: modelData

            implicitWidth: dockBar.x + dockBar.width
            implicitHeight: dockBar.y + dockBar.height
            color: "transparent"

            anchors {
                top: true
                left: true
                    }

            //Black Rectangle Background
            Rectangle {
                id: dockBar

                width: launchColumn.implicitWidth
                height: launchColumn.implicitHeight

                anchors { 
                    top: parent.top; 
                    left: parent.left; 
                    margins: 4 
                    }

                radius: 8

                color: "#0e0f11"

                state: "rest"

                //State Handling for the bar
                states: [
                State {
                    name: "rest"
                    PropertyChanges { target: shelf; visible: false }
                    PropertyChanges { target: controls; visible: false }
                },
                State {
                    name: "launch"
                    PropertyChanges { target: shelf; visible: true }
                    PropertyChanges { target: controls; visible: false }
                }
            ]

                //Column Layout stacks rows of items for launch view
                ColumnLayout {
                    
                id: launchColumn

                width: implicitWidth
                height: implicitHeight

                    //App Icon Shelf 
                    Item {
                        id: shelf
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: false
                    }

                    //Dock Row holds rest layout
                    RowLayout {
                        id: dockRow
                        Layout.preferredHeight: 44
                        spacing: 4
                        
                        LaunchButton {
                            onClicked: dockBar.state = (dockBar.state === "rest") ? "launch" : "rest"
                        }

                        // Divider
                        Rectangle {
                            Layout.preferredWidth: 1
                            Layout.preferredHeight: 24
                            Layout.alignment: Qt.AlignVCenter
                            color: "#353540"
                        }

                        // Open apps, deduped by appId
                            Repeater {
                                model: ScriptModel {
                                    values: {
                                        const seen = new Set();
                                        return ToplevelManager.toplevels.values.filter(t => {
                                            if (seen.has(t.appId)) return false;
                                            seen.add(t.appId);
                                            return true;
                                        });
                                    }
                                }

                                AppButton {
                                    required property Toplevel modelData
                                    desktopId: modelData.appId
                                    Layout.fillHeight: true
                                    onRightClicked: { /* context menu: quit, etc. */ }
                                }
                            }

                    }

                }

            }
        }
    }
}
