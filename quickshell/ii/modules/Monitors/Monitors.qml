import qs.modules.common
import qs.modules.common.widgets
import qs.services
import qs
import qs.modules.common.functions
import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Effects
import Quickshell.Hyprland

Scope {
    id: root
    property bool visible: false
    readonly property real osdWidth: Appearance.sizes.osdWidth
    readonly property real widgetWidth: 250
    readonly property real widgetHeight: 120
    property real contentPadding: 13
    property real popupRounding: Appearance.rounding.screenRounding - Appearance.sizes.elevationMargin + 1

    Process { // monleft
        id: monleft
        command: [ "fish", "-c", "monleft" ]
        onExited: (exitCode, exitStatus) => {
            //nothing
        }
    }

    Process { // monright
        id: monright
        command: [ "fish", "-c", "monright" ]
        onExited: (exitCode, exitStatus) => {
            //nothing
        }
    }

    Process { // mondupe
        id: mondupe
        command: [ "fish", "-c", "mondupe" ]
        onExited: (exitCode, exitStatus) => {
            //nothing
        }
    }

    Loader {
        id: monitorSelectorLoader
        active: GlobalStates.monitorSelectOpen
        // onActiveChanged: {
            
        // }

        sourceComponent: PanelWindow {
            id: monitorSelectorRoot
            visible: true

            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0
            implicitWidth: root.widgetWidth
            implicitHeight: root.widgetHeight
            // color: ColorUtils.transparentize(Appearance.colors.colLayer1, 0.5)//"transparent"
            color: "transparent"
            
            WlrLayershell.namespace: "quickshell:monitorSelector"

            anchors {
                top: !Config.options.bar.bottom || Config.options.bar.vertical
                bottom: Config.options.bar.bottom && !Config.options.bar.vertical
                left: !(Config.options.bar.vertical && Config.options.bar.bottom)
                right: Config.options.bar.vertical && Config.options.bar.bottom
            }
            margins {
                top: Config.options.bar.vertical ? ((monitorSelectorRoot.screen.height / 2) - widgetHeight * 1.5) : Appearance.sizes.barHeight
                bottom: Appearance.sizes.barHeight
                left: Config.options.bar.vertical ? Appearance.sizes.barHeight : ((monitorSelectorRoot.screen.width) - 835)
                right: Appearance.sizes.barHeight
            }

            Rectangle { // Art background
                id: background
                Layout.fillHeight: true
                anchors.margins: Appearance.sizes.elevationMargin
                anchors.fill: parent
                implicitWidth: height
                radius: root.popupRounding
                color: ColorUtils.transparentize(Appearance.m3colors.term6, 0.8)

                RowLayout {
                    id: mainRow
                    anchors.fill: parent
                    anchors.margins: root.contentPadding
                    spacing: 15
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    RippleButton {
                        id: setLeft
                        // anchors.right: parent.right
                        // anchors.bottom: parent.top
                        // anchors.bottomMargin: 5

                        Layout.alignment: Qt.AlignLeft
                        
                        property real size: 44
                        // implicitWidth: size
                        // implicitHeight: size
                        implicitWidth: 60
                        implicitHeight: 80
                        onClicked: monleft.running = true;

                        buttonRadius: Appearance?.rounding.normal
                        colBackground: Appearance.colors.colPrimary
                        colBackgroundHover: Appearance.colors.colPrimaryHover
                        colRipple: Appearance.colors.colPrimaryActive

                        contentItem: MaterialSymbol {
                            iconSize: Appearance.font.pixelSize.huge
                            fill: 1
                            horizontalAlignment: Text.AlignHCenter
                            color: Appearance.colors.colOnPrimary
                            text: "left_panel_close"

                            Behavior on color {
                                animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
                            }
                        }
                    }
                    RippleButton {
                        id: setDupe
                        // anchors.right: parent.right
                        // anchors.bottom: parent.top
                        // anchors.bottomMargin: 5

                        Layout.alignment: Qt.AlignCenter
                        implicitWidth: 60
                        implicitHeight: 80
                        onClicked: mondupe.running = true;

                        buttonRadius: Appearance?.rounding.normal
                        colBackground: Appearance.colors.colPrimary
                        colBackgroundHover: Appearance.colors.colPrimaryHover
                        colRipple: Appearance.colors.colPrimaryActive

                        contentItem: MaterialSymbol {
                            iconSize: Appearance.font.pixelSize.huge
                            fill: 1
                            horizontalAlignment: Text.AlignHCenter
                            color: Appearance.colors.colOnPrimary
                            text: "screen_share"

                            Behavior on color {
                                animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
                            }
                        }
                    }
                    RippleButton {
                        id: setRight
                        Layout.alignment: Qt.AlignRight
                        implicitWidth: 60
                        implicitHeight: 80
                        onClicked: monright.running = true;

                        buttonRadius: Appearance?.rounding.normal
                        colBackground: Appearance.colors.colPrimary
                        colBackgroundHover: Appearance.colors.colPrimaryHover
                        colRipple: Appearance.colors.colPrimaryActive

                        contentItem: MaterialSymbol {
                            iconSize: Appearance.font.pixelSize.huge
                            fill: 1
                            horizontalAlignment: Text.AlignHCenter
                            color: Appearance.colors.colOnPrimary
                            text: "right_panel_close"

                            Behavior on color {
                                animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
                            }
                        }
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "monitorSelector"

        function toggle(): void {
            monitorSelectorLoader.active = !monitorSelectorLoader.active;
            if(monitorSelectorLoader.active) Notifications.timeoutAll();
        }

        function close(): void {
            monitorSelectorLoader.active = false;
        }

        function open(): void {
            monitorSelectorLoader.active = true;
            Notifications.timeoutAll();
        }
    }

    GlobalShortcut {
        name: "monitorSelectorToggle"
        description: "Toggles monitor selecter on press"

        onPressed: {
            GlobalStates.monitorSelectOpen = !GlobalStates.monitorSelectOpen;
        }
    }
    GlobalShortcut {
        name: "monitorSelectorOpen"
        description: "Opens monitor selecter on press"

        onPressed: {
            GlobalStates.monitorSelectOpen = true;
        }
    }
    GlobalShortcut {
        name: "monitorSelectorClose"
        description: "Closes monitor selecter on press"

        onPressed: {
            GlobalStates.monitorSelectOpen = false;
        }
    }
}