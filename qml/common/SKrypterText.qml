import QtQuick 2.0

Text {
    //this fixes the rendering bug, see https://bugreports.qt-project.org/browse/QTBUG-37015
    renderType: Text.NativeRendering
}
