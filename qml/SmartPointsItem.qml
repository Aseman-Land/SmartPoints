import QtQuick 2.0
import SmartPoints 1.0

Rectangle {
    id: main_item
    width: 100
    height: 62
    color: "#eeeeee"

    property variant list

    signal indexChanged(int index)
    signal finished()

    ListModel {
        id: model
    }

    ListModel {
        id: results
    }

    Timer {
        id: next_timer
        interval: motionSpeed*5000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if(!scene.next())
                stop()
        }
    }

    SmartPointAnalizer {
        id: analizer
        minPointSize: 2
        maxPointSize: 80
        onResult: {
            var obj = result_component.createObject(scene)
            obj.list = list
            obj.size = size

            results.append({"obj": obj})
            if(!next_timer.running && scene.started)
                next_timer.start()
        }

        Component.onCompleted: {
            for(var i=0; i<list.length; i++)
                start("file://" + list[i])
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.BlankCursor
    }

    Item {
        id: scene
        anchors.fill: parent

        property int pointer: -1
        property bool started: false

        function start() {
            started = true
            next_timer.restart()
        }

        function next() {
            return show(pointer+1)
        }

        function previous() {
            return show(pointer-1)
        }

        function show(index) {
            if(index >= results.count || index<0) {
                main_item.finished()
                return false
            }
            else
                main_item.indexChanged(index)

            var firstInit = (model.count == 0)
            var obj = results.get(index).obj

            var size = obj.size
            var list = obj.list

            var sourceSize = size
            var sourceRatio = sourceSize.width/sourceSize.height
            var sceneRatio = scene.width/scene.height
            var nwidth = sceneRatio<sourceRatio? scene.width : scene.height*sourceRatio
            var nheight = sceneRatio<sourceRatio? scene.width/sourceRatio : scene.height
            var xRatio = nwidth/sourceSize.width
            var yRatio = nheight/sourceSize.height
            var xPad = scene.width/2 - nwidth/2
            var yPad = scene.height/2 - nheight/2

            var remove_list = new Array
            while(list.length<model.count) {
                var idx = Math.floor(Math.random()*model.count)
                var oldObj = model.get(idx).object
                model.remove(idx)

                remove_list[remove_list.length] = oldObj
            }

            for(var i=0; i<list.length; i++) {
                var item = list[i]
                var object
                var mX = xPad + item.x*xRatio
                var mY = yPad + item.y*yRatio
                var mRadius = item.radius*xRatio

                if(i < model.count) {
                    object = model.get(i).object
                } else {
                    var startX = mX
                    var startY = mY
                    var startColor = item.color
                    if(!firstInit) {
                        var otherObject = model.get( Math.random()*(model.count-1) ).object
                        startX = otherObject.x
                        startY = otherObject.y
                        startColor = otherObject.color
                    }

                    object = circle_component.createObject(scene, {"x":startX, "y":startY, "color": startColor, "firstInit": firstInit})
                    model.append({"object": object})
                }

                object.firstInit = firstInit
                object.radius = mRadius*2
                object.x = mX
                object.y = mY
                object.color = item.color
            }

            for(var j=0; j<remove_list.length; j++)
                remove_list[j].end()

            pointer = index
            return true
        }
    }

    Component {
        id: circle_component
        Item {
            id: circle
            property alias radius: rect.width
            property alias color: rect.color

            property int animDuration: motionSpeed*(1000 + 1000*Math.random())
            property bool firstInit: false

            Behavior on x {
                NumberAnimation{ easing.type: Easing.InOutCubic; duration: circle.animDuration}
            }
            Behavior on y {
                NumberAnimation{ easing.type: Easing.InOutCubic; duration: circle.animDuration}
            }
            Behavior on color {
                ColorAnimation{ easing.type: Easing.InOutCubic; duration: circle.animDuration}
            }

            Rectangle {
                id: rect
                anchors.centerIn: parent
                height: width
                radius: width/2

                Behavior on width {
                    NumberAnimation{ easing.type: circle.firstInit?Easing.OutCubic:Easing.InOutCubic; duration: circle.firstInit? motionSpeed*400 : circle.animDuration}
                }
            }

            function end() {
                radius = 0
                end_timer.restart()
            }

            Timer {
                id: end_timer
                interval: motionSpeed*300
                onTriggered: circle.destroy()
            }
        }
    }

    Component {
        id: result_component
        QtObject {
            property variant list
            property variant size
        }
    }

    function start() {
        scene.start()
    }
}

