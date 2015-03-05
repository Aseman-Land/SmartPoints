import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import SmartPoints 1.0

ApplicationWindow {
    id: mainwin
    width: 800
    height: 600
    visible: true
    visibility: Window.FullScreen

    property real ratio: height/768
    property real motionSpeed: 1

    property variant texts: SmartPointGlobal.readFileData(SmartPointGlobal.applicationDirPath() + "/qml/data")

    SmartPointsItem {
        id: smart_pnt
        anchors.fill: parent
        list: SmartPointGlobal.filesEntryList(SmartPointGlobal.applicationDirPath() + "/qml/images/", ["*.png"] )
        Component.onCompleted: start()
        onIndexChanged: {
            if(index == 1 )
                oxygen_logo.opacity = 0

            fader.text = ""
            switch_fader.index = index
            switch_fader.restart()

            if(index == 15)
                for_you_logo_timer.restart()
        }

        Behavior on opacity {
            NumberAnimation{ duration: motionSpeed*400 }
        }
    }

    Image {
        id: oxygen_logo
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "images/00_oxygenfree.png"

        Behavior on opacity {
            NumberAnimation{ duration: motionSpeed*200 }
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.verticalCenter
        anchors.topMargin: 140*ratio
        font.family: "ubuntu"
        font.pointSize: 26*ratio
        color: "#333333"
        text: "Oxygen Project"
        opacity: oxygen_logo.opacity
    }

    Image {
        id: for_you_logo
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "images/13_foryou.png"
        opacity: 0
        onOpacityChanged: if(opacity==1) smart_pnt.opacity = 0

        Behavior on opacity {
            NumberAnimation{ duration: motionSpeed*1000 }
        }

        Timer {
            id: for_you_logo_timer
            interval: motionSpeed*1500
            onTriggered: {
                for_you_logo.opacity = 1
                aseman_logo_timer.restart()
            }
        }
    }

    TextFader {
        id: fader
        anchors.fill: parent

        Timer {
            id: switch_fader
            interval: motionSpeed*500
            onTriggered: fader.text = texts[index]
            property int index
        }
    }

    Rectangle {
        id: aseman_logo
        anchors.fill: parent
        color: "#eeeeee"
        z: 10
        opacity: 0

        Behavior on opacity {
            NumberAnimation{ duration: motionSpeed*1000 }
        }

        Image {
            anchors.centerIn: parent
            width: 360*ratio
            height: 360*ratio
            sourceSize: Qt.size(width,height)
            source: "images/aseman-special-black.png"
            asynchronous: true
        }

        Text {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 40*ratio
            font.pixelSize: 16*ratio
            color: "#333333"
            text: "aseman.co/oxygen"
        }

        Timer {
            id: aseman_logo_timer
            interval: motionSpeed*2500
            onTriggered: {
                aseman_logo_timer2.restart()
                for_you_logo.opacity = 0
            }
        }

        Timer {
            id: aseman_logo_timer2
            interval: motionSpeed*1500
            onTriggered: aseman_logo.opacity = 1
        }
    }
}
