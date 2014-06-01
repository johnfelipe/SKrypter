CONFIG += qmltestcase

SOURCES += ../src/helpers/logger.cpp \
    ../src/helpers/calculations.cpp \
    ../src/main_test.cpp \
    ../src/helpers/stats.cpp

OTHER_FILES += qml/exercises/loader.js \
    ./*.qml

HEADERS += \
    ../src/helpers/logger.h \
    ../src/helpers/calculations.h \
    ../src/helpers/stats.h
