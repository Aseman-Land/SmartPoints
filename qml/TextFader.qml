import QtQuick 2.0

Item {
    id: tfader
    width: 100
    height: 62

    property string text

    onTextChanged: {
        show_timer.text = text
        show_timer.restart()
        if(privates.currentItem)
            privates.currentItem.end()
    }

    QtObject {
        id: privates
        property variant currentItem
    }

    Timer {
        id: show_timer
        interval: motionSpeed*400
        onTriggered: {
            privates.currentItem = text_component.createObject(tfader)
            privates.currentItem.text = text
            privates.currentItem.opacity = 1
        }
        property string text
    }

    Component {
        id: text_component
        Text {
            id: item
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.verticalCenter
            anchors.topMargin: 180*ratio
            color: "#333333"
            opacity: 0
            font.family: "ubuntu"
            font.pointSize: 26*ratio

            Behavior on opacity {
                NumberAnimation{easing.type: Easing.OutCubic; duration: motionSpeed*400}
            }

            Timer {
                id: destroy_timer
                interval: motionSpeed*400
                onTriggered: item.destroy()
            }

            function end() {
                opacity = 0
                destroy_timer.restart()
            }
        }
    }
}

