import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.0
import org.kde.kirigami 2.19 as Kirigami

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
            drag{
                target: parent; axis: Drag.XAxis
            }
            onMouseXChanged: {
                if(drag.active)
                {
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
            drag{
                target: parent; axis: Drag.XAxis
            }
            onMouseXChanged: {
                if(drag.active)
                {
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
            drag{
                target: parent; axis: Drag.YAxis
            }
            onMouseYChanged: {
                if(drag.active)
                {
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
            drag{
                target: parent; axis: Drag.YAxis
            }
            onMouseYChanged: {
                if(drag.active)
                {
                selComp.height = selComp.height + mouseY
                if(selComp.height < 50)
                    selComp.height = 50
                }
            }
        }
    }
}
