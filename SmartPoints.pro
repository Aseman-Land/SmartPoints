qmlFiles.source = qml
qmlFiles.target = $$DESTDIR
DEPLOYMENTFOLDERS = qmlFiles

QT += core gui qml quick

TARGET = SmartPoints
TEMPLATE = app

SOURCES += \
    main.cpp \
    smartpointanalizer.cpp \
    smartpointanalizerthread.cpp \
    smartpointitem.cpp \
    smartpointglobalqml.cpp

HEADERS  += \
    smartpointanalizer.h \
    smartpointanalizerthread.h \
    smartpointitem.h \
    smartpointglobalqml.h

include(qmake/qtcAddDeployment.pri)
qtcAddDeployment()
