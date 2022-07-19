// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.0
import org.kde.kirigami 2.19 as Kirigami
import org.kde.WattaMark 1.0

Kirigami.ApplicationWindow {
    id: root

    title: i18n("WattaMark")

    minimumWidth: Kirigami.Units.gridUnit * 20
    minimumHeight: Kirigami.Units.gridUnit * 20

    onClosing: App.saveWindowGeometry(root)

    onWidthChanged: saveWindowGeometryTimer.restart()
    onHeightChanged: saveWindowGeometryTimer.restart()
    onXChanged: saveWindowGeometryTimer.restart()
    onYChanged: saveWindowGeometryTimer.restart()

    Component.onCompleted: App.restoreWindowGeometry(root)

    // This timer allows to batch update the window size change to reduce
    // the io load and also work around the fact that x/y/width/height are
    // changed when loading the page and overwrite the saved geometry from
    // the previous session.
    Timer {
        id: saveWindowGeometryTimer
        interval: 1000
        onTriggered: App.saveWindowGeometry(root)
    }
    globalDrawer: Kirigami.GlobalDrawer {
        title: i18n("WattaMark")
        titleIcon: "applications-graphics"
        isMenu: !root.isMobile
        actions: [
            Kirigami.Action {
                text: i18n("About WattaMark")
                icon.name: "help-about"
                onTriggered: pageStack.layers.push('qrc:About.qml')
            },
            Kirigami.Action {
                text: i18n("Quit")
                icon.name: "application-exit"
                onTriggered: Qt.quit()
            }
        ]
    }

    contextDrawer: Kirigami.ContextDrawer {
        id: contextDrawer
    }

    pageStack.initialPage: page
 FileDialog {
    id: fileDialog
    selectMultiple: true
    title: "Please choose a file"
    folder: shortcuts.home
    onAccepted: {
        console.log("You chose: " + fileDialog.fileUrls)
        fileDialog.close()
    }
    onRejected: {
        console.log("Canceled")
        fileDialog.close()
    }
    Component.onCompleted: visible = false
}
    Kirigami.Page {
        id: page

        Layout.fillWidth: true

        title: i18n("Main Page")
        actions.main: Kirigami.Action {
                text: i18n("Open File")
            icon.name: "list-add"
            tooltip: i18n("Open Files")
            onTriggered: fileDialog.open()
            }

        ColumnLayout {
            width: page.width
            anchors.centerIn: parent

            Kirigami.Heading {
                Layout.alignment: Qt.AlignCenter
                text: i18n("Hello, World!")
            }
            Controls.Button {
                Layout.alignment: Qt.AlignHCenter
                text: "Open File"
                onClicked: fileDialog.open()
            }

        }
    }
}
