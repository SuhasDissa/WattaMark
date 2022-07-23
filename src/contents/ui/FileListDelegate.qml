import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.0
import org.kde.kirigami 2.19 as Kirigami
import org.kde.WattaMark 1.0

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
                        actions : [
                        Kirigami.Action {
                            iconName : "list-remove"
                            text : "Remove"
                            onTriggered : listModel.remove(index)
                        }
                    ]
                }
