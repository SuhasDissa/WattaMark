import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.0
import org.kde.kirigami 2.19 as Kirigami

Kirigami.SwipeListItem {
                    id : listItem
                    contentItem :RowLayout {
                        Controls.Label {
                            Layout.fillWidth : true
                            text:model.title
                            color: listItem.checked || (listItem.pressed && !listItem.checked && !listItem.sectionDelegate) ? listItem.activeTextColor : listItem.textColor
                        }
 MouseArea {
	anchors.fill: parent
	onClicked: {
		filesList.currentIndex = index;
		previewImg = title
	}
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
