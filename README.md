SKrypter
========

An Interactive Cryptology Learning Environment for Students and Teachers (High-School Level)

Baseline Workaround
===================
Before version 5.3 of QT is released and used please ensure that you add 
the following workaround:
You can add the following line to Base/TextFieldStyle.qml inside the panel item:
property real baselineOffset: control.__contentHeight
Bug Report:
https://bugreports.qt-project.org/browse/QTBUG-36529
