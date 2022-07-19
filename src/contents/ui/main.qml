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
    selectMultiple: false //Disabled for testing pourposes
    title: "Please choose a file"
    folder: shortcuts.home
    onAccepted: {
        console.log("Loading... " + fileDialog.fileUrls)
        image.source = fileDialog.fileUrls.toString()
        fileDialog.close()
    }
    onRejected: {
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
        header: Controls.TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        Controls.TabButton {
            text: "Open Files"
        }
        Controls.TabButton {
            text: "Add Watermark"
        }
        Controls.TabButton {
            text: "Export"
        }
    }
Controls.SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        clip: true
        Item{
            id: firstTab
        }
Item{
id: secondTab
    Image {
        id:image
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
}
}
Item{
            id: thirdTab
        }
}
    }
}
