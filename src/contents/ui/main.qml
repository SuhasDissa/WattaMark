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
    Component.onCompleted : App.restoreWindowGeometry(root)
    property var selection: undefined
    property var watermarkImg: undefined
    property var previewImg: undefined
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
    pageStack.initialPage : page
    Kirigami.Page {
        id : page
        Layout.fillWidth : true
        title : i18n("WattaMark")
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
        background: Rectangle {
        color: Kirigami.Theme.backgroundColor
    }
    }
    Controls.SwipeView {
        id : swipeView
        anchors.fill: parent
        currentIndex : tabBar.currentIndex
        clip : true
        Item {
       FileDialog {
        id : fileDialog
        selectMultiple : true
        title : "Please choose a file"
        folder : shortcuts.home
        nameFilters: [ "Image files (*.jpg *.jpeg *.png)" ]
        onAccepted : {
            fileDialog.fileUrls.forEach(file => {
                listModel.append({"title": file.split('/').pop(),"imageurl":file,                          "actions": [{text: "Remove",icon: "list-remove"}]})})
            previewImg = fileDialog.fileUrls[0]
            fileDialog.close()
        }
        onRejected : {
            fileDialog.close()
        }
        Component.onCompleted : visible = false
    }
            RowLayout{
                anchors.fill: parent
                spacing: 6
                ColumnLayout{
        Layout.fillWidth: true
        Layout.preferredHeight: parent.height
        Layout.minimumWidth: 400
        Controls.ScrollView{
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: filesList.width
            contentHeight: filesList.height
            Controls.ScrollBar.horizontal.policy: Controls.ScrollBar.AlwaysOff
            Controls.ScrollBar.vertical.interactive: true
        ListView {
                id : filesList
                width: parent.width
                model : ListModel {
                    id : listModel
                }
                delegate:FileListDelegate{}
            }}

    Controls.Button {
            text : i18n("Open File")
            icon.name : "list-add"
            onClicked : fileDialog.open()
    }


    }
    ColumnLayout {
        Layout.fillWidth: true
        Layout.minimumWidth: 400
        Image{
            id:previewImage
            source:previewImg
            fillMode : Image.PreserveAspectFit
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
            }

        }
        Item {
            Component {
    id: selectionComponent

    WatermarkSelection{}
}

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

Image {
                id: mainImage
                height:parent.height
                fillMode : Image.PreserveAspectFit
                source:previewImg
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(!selection)
                            watermarkDialog.open()
                            selection = selectionComponent.createObject(parent, {"x": parent.width / 2, "y": parent.height / 2, "width": 128, "height": 128})

                    }
                }
            }


        }
        Item {
            Controls.Button{
                text : i18n("Apply Watermark")
                icon.name : "list-add"
                onClicked : {
                var imgWidth = parseInt(mainImage.width)
                var imgHeight = parseInt(mainImage.height)
                var wmWidth = parseInt(selection.width)
                var wmHeight = parseInt(selection.height)
                var wmX = parseInt(selection.x)
                var wmY = parseInt(selection.y)
                var wmPath = watermarkImg.toString()
                Backend.applyWatermark(imgWidth,imgHeight,wmX,wmY,wmWidth,wmHeight,wmPath)
            }
            }
        }
    }
}

    }

