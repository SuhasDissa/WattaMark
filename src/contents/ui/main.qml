 // SPDX-License-Identifier: GPL-2.0-or-later // SPDX-FileCopyrightText: 2022 Suhas Dissanayake <suhasdissa@protonmail.com>
import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.0
import org.kde.kirigami 2.19 as Kirigami
import org.kde.WattaMark 1.0

Kirigami.ApplicationWindow {
    id : root
    title : i18n("WattaMark")
    minimumWidth : Kirigami.Units.gridUnit * 20
    minimumHeight : Kirigami.Units.gridUnit * 20
    onClosing : App.saveWindowGeometry(root)
    onWidthChanged : saveWindowGeometryTimer.restart()
    onHeightChanged : saveWindowGeometryTimer.restart()
    onXChanged : saveWindowGeometryTimer.restart()
    onYChanged : saveWindowGeometryTimer.restart()
    Component.onCompleted : App.restoreWindowGeometry(root)
    property var selection: undefined
    property var watermarkImg: undefined
    Timer {
        id : saveWindowGeometryTimer
        interval : 1000
        onTriggered : App.saveWindowGeometry(root)
    }
    globalDrawer : Kirigami.GlobalDrawer {
        title : i18n("WattaMark")
        titleIcon : "applications-graphics"
        isMenu : !root.isMobile
        actions : [
            Kirigami.Action {
                text : i18n("About WattaMark")
                icon.name : "help-about"
                onTriggered : pageStack.layers.push('qrc:About.qml')
            },
            Kirigami.Action {
                text : i18n("Quit")
                icon.name : "application-exit"
                onTriggered : Qt.quit()
            }
        ]
    }
    contextDrawer : Kirigami.ContextDrawer {
        id : contextDrawer
    }
    FileDialog {
        id : fileDialog
        selectMultiple : true
        title : "Please choose a file"
        folder : shortcuts.home
        nameFilters: [ "Image files (*.jpg *.jpeg *.png)" ]
        onAccepted : {
            fileDialog.fileUrls.forEach(file => {listModel.append({"title": file,"imageurl":file,                          "actions": [{text: "Remove",icon: "list-remove"}]})})
            mainImage.source = fileDialog.fileUrls[0]
            fileDialog.close()
        }
        onRejected : {
            fileDialog.close()
        }
        Component.onCompleted : visible = false
    }
    pageStack.initialPage : page
    Kirigami.Page {
        id : page
        Layout.fillWidth : true
        title : i18n("Main Page")
        actions.main : Kirigami.Action {
            text : i18n("Open File")
            icon.name : "list-add"
            tooltip : i18n("Open Files")
            onTriggered : fileDialog.open()
        }
        header : Controls.TabBar {
            id : tabBar
            currentIndex : swipeView.currentIndex
                Controls.TabButton {
                    text : "Open Files"
                }
                Controls.TabButton {
                    text : "Add Watermark"
                }
            Controls.TabButton {
                text : "Export"
            }
    }
    Controls.SwipeView {
        id : swipeView
        anchors.fill : parent
        currentIndex : tabBar.currentIndex
        clip : true
        Item {
            id : firstTab
            Component {
                id : delegateComponent
                Kirigami.SwipeListItem {
                    id : listItem
                    contentItem :RowLayout {
                        Image{
                            source:model.imageurl
                            sourceSize: {width: 100; height: 100}
                            Layout.preferredHeight: 100
                            Layout.preferredWidth: 100
                            asynchronous : true
                            fillMode : Image.PreserveAspectFit
                        }
                        Controls.Label {
                            Layout.fillWidth : true
                            text:model.title
                            color : listItem.checked || (listItem.pressed && !listItem.checked && !listItem.sectionDelegate)? listItem.activeTextColor: listItem.textColor
                        }
                    }
                        actions : [Kirigami.Action {
                            iconName : "list-remove"
                            text : "Remove"
                            onTriggered : listModel.remove(index)
                        }
                    ]
                }
            }
            ListView {
                id : filesList
                anchors.fill : parent
                model : ListModel {
                    id : listModel
                }
                delegate:delegateComponent
            }
        }
        Item {
            FileDialog {
        id : watermarkDialog
        selectMultiple : false
        title : "Please choose a file"
        folder : shortcuts.home
        nameFilters: [ "Image files (*.jpg *.jpeg *.png)" ]
        onAccepted : {
            watermarkImg = watermarkDialog.fileUrl
            watermarkDialog.close()
        }
        onRejected : {
            watermarkDialog.close()
        }
        Component.onCompleted : visible = false
    }
            id : secondTab
            Image {
                id: mainImage
                anchors.fill: parent
                fillMode : Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(!selection)
                            watermarkDialog.open()
                            selection = selectionComponent.createObject(parent, {"x": parent.width / 4, "y": parent.height / 4, "width": parent.width / 2, "height": parent.width / 2})

                    }
                }
            }
            Component {
        id: selectionComponent

        Rectangle {
            id: selComp
            border {
                width: 2
                color: "#00a6ff"
            }
            color: "#00a6ffB4"

            property int rulersSize: 18
            Image{
                source: watermarkImg
                anchors.fill: parent
                }
            MouseArea {     // drag mouse area
                anchors.fill: parent
                drag{
                    target: parent
                    minimumX: 0
                    minimumY: 0
                    maximumX: parent.parent.width - parent.width
                    maximumY: parent.parent.height - parent.height
                    smoothed: true
                }

                onDoubleClicked: {
                    parent.destroy()        // destroy component
                }
            }

            Rectangle {
                width: rulersSize
                height: rulersSize
                radius: rulersSize
                color: "#00a6ff"
                anchors.horizontalCenter: parent.left
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    drag{ target: parent; axis: Drag.XAxis }
                    onMouseXChanged: {
                        if(drag.active){
                            selComp.width = selComp.width - mouseX
                            selComp.x = selComp.x + mouseX
                            if(selComp.width < 30)
                                selComp.width = 30
                        }
                    }
                }
            }

            Rectangle {
                width: rulersSize
                height: rulersSize
                radius: rulersSize
                color: "#00a6ff"
                anchors.horizontalCenter: parent.right
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    drag{ target: parent; axis: Drag.XAxis }
                    onMouseXChanged: {
                        if(drag.active){
                            selComp.width = selComp.width + mouseX
                            if(selComp.width < 50)
                                selComp.width = 50
                        }
                    }
                }
            }

            Rectangle {
                width: rulersSize
                height: rulersSize
                radius: rulersSize
                x: parent.x / 2
                y: 0
                color: "#00a6ff"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.top

                MouseArea {
                    anchors.fill: parent
                    drag{ target: parent; axis: Drag.YAxis }
                    onMouseYChanged: {
                        if(drag.active){
                            selComp.height = selComp.height - mouseY
                            selComp.y = selComp.y + mouseY
                            if(selComp.height < 50)
                                selComp.height = 50
                        }
                    }
                }
            }


                Rectangle {
                    width: rulersSize
                    height: rulersSize
                    radius: rulersSize
                    x: parent.x / 2
                    y: parent.y
                    color: "#00a6ff"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.bottom

                    MouseArea {
                        anchors.fill: parent
                        drag{ target: parent; axis: Drag.YAxis }
                        onMouseYChanged: {
                            if(drag.active){
                                selComp.height = selComp.height + mouseY
                                if(selComp.height < 50)
                                    selComp.height = 50
                            }
                        }
                    }
                }
            }
    }
        }
        Item {
            id : thirdTab
        }
    }
}}

