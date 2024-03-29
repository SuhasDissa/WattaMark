// SPDX-License-Identifier: GPL-2.0-or-later // SPDX-FileCopyrightText: 2022 Suhas Dissanayake <suhasdissa@protonmail.com>
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
    Component.onCompleted: App.restoreWindowGeometry(root)

// define useful variables for later use (these can be used in any .qml file)
    property var selection: undefined
    property var watermarkImg: undefined
    property var previewImg: undefined

//Global Drawer (the menu that pops up when the menu button is clicked)
    globalDrawer: Kirigami.GlobalDrawer {
        title: i18n("WattaMark")
        titleIcon: "applications-graphics"
        isMenu: !root.isMobile
        actions: [
            Kirigami.Action {
                text: i18n("About WattaMark")
                icon.name: "help-about"
                onTriggered: pageStack.layers.push('qrc: About.qml')
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

    //Kirigami page (All stuff go inside this)
    Kirigami.Page {
        id: page
        Layout.fillWidth: true
        title: i18n("WattaMark")

        //We have three tabs here which control swipeview
        header: Controls.TabBar {
            id: tabBar
            currentIndex: swipeView.currentIndex
            background: Rectangle {
                color: Kirigami.Theme.backgroundColor
            }

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
            Item {
                // This is the file import Dialog
                FileDialog {
                    id: fileDialog
                    selectMultiple: true
                    title: "Please choose a file"
                    folder: shortcuts.home
                    nameFilters: [ "Image files (*.jpg *.jpeg *.png)" ]
                    onAccepted: {
                        //Add files to listModel
                        fileDialog.fileUrls.forEach(file => {listModel.append({"title": file.split('/').pop(), "imageurl": file, "actions": [{text: "Remove", icon: "list-remove"}]})})
                        //Add first image as PreviewImage (otherwise it will be empty)
                        previewImg = fileDialog.fileUrls[0]
                        fileDialog.close()
                    }
                    onRejected: {
                        fileDialog.close()
                    }
                    Component.onCompleted: visible = false
                }
                // Content of the first tab begins here
                RowLayout{
                    anchors.fill: parent
                    spacing: 6
                    ColumnLayout{
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height
                        Layout.minimumWidth: 400

                        //Files list scroll view
                        Controls.ScrollView{
                            background: Rectangle{
                                radius: 10
                                color: Kirigami.Theme.backgroundColor
                            }
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            contentWidth: filesList.width
                            contentHeight: filesList.height
                            Controls.ScrollBar.horizontal.policy: Controls.ScrollBar.AlwaysOff
                            Controls.ScrollBar.vertical.interactive: true
                            ListView {
                                id: filesList
                                width: parent.width
                                model: ListModel {
                                    id: listModel
                                }

                                //this delegate is imported from FileListDelegate.qml
                                delegate: FileListDelegate{ }
                            }}
                            

                            //File Open Button
                            Controls.Button {
                                text: i18n("Open File")
                                icon.name: "list-add"
                                onClicked: fileDialog.open()
                            }


                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.minimumWidth: 400

                            //Preview image of first tab
                            Image{
                                id: previewImage
                                source: previewImg
                                fillMode: Image.PreserveAspectFit
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }
                    }

                }
                Item {
                    Component {
                        id: selectionComponent

                        //This is imported from WatermarkSelection.qml
                        WatermarkSelection{ }
                    }

                    //File Dialog to open watermark
                    FileDialog {
                        id: watermarkDialog
                        selectMultiple: false
                        title: "Please choose a file"
                        folder: shortcuts.home
                        nameFilters: [ "Image files (*.jpg *.jpeg *.png)" ]
                        onAccepted: {
                            watermarkImg = watermarkDialog.fileUrl
                            watermarkDialog.close()
                        }
                        onRejected: {
                            watermarkDialog.close()
                        }
                        Component.onCompleted: visible = false
                    }

                    //Preview image of second tab
                    Image {
                        id: mainImage
                        height: parent.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        fillMode: Image.PreserveAspectFit
                        source: previewImg
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if(!selection){
                                watermarkDialog.open()
                                selection = selectionComponent.createObject(parent, {"x": parent.width / 2, "y": parent.height / 2, "width": 128, "height": 128})
                            }
                        }
                    }
                }


            }
            Item {
                Controls.ProgressBar{
                    id: pBar
                    height: 20
                    width: parent.width
                    anchors.bottom: parent.bottom
                }
                Controls.Button{
                    text: i18n("Apply Watermark")
                    icon.name: "list-add"
                    onClicked: {
                        for(var i = 0; i < listModel.count; ++i){
                        var imgPath = listModel.get(i).imageurl.toString()
                        var imgRatio = parseInt(mainImage.sourceSize.width)/parseInt(mainImage.width)
                        var wmWidth = parseInt(parseInt(selection.width)*imgRatio)
                        var wmHeight = parseInt(parseInt(selection.height)*imgRatio)
                        var wmGeometry = wmWidth+"x"+wmHeight+"!"
                        var wmX = parseInt(parseInt(selection.x)*imgRatio)
                        var wmY = parseInt(parseInt(selection.y)*imgRatio)
                        var wmPath = watermarkImg.toString()
                        var imgFileName = imgPath.split('/').pop()
                        Backend.applyWatermark(wmX, wmY, wmGeometry, wmPath, imgPath, imgFileName)
                        pBar.value = (i + 1)/listModel.count
                        console.log("Progress: "+ parseInt((i + 1)/listModel.count*100)+"%")
                    }}
                }
            }
        }
    }

}

