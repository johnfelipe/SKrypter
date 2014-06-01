TEMPLATE += app

ICON = ../Icon.icns

RC_ICONS = ../appicon.ico

QT += quick widgets svg

SOURCES += ../src/main.cpp \
    ../src/helpers/logger.cpp \
    ../src/helpers/view.cpp \
    ../src/helpers/calculations.cpp \
    ../src/helpers/stats.cpp \
    ../src/io/serializable.cpp \
    ../src/io/simplecrypt.cpp \
    ../src/io/caesar_1_exercise.cpp \
    ../src/io/caesar_2_exercise.cpp \
    ../src/io/caesar_3_exercise.cpp \
    ../src/io/exercise_list.cpp \
    ../src/io/exercise_loader.cpp \
    ../src/io/exercise.cpp \
    ../src/io/file_crypter.cpp \
    ../src/io/caesar_4_exercise.cpp \
    ../src/io/caesar_5_exercise.cpp \
    ../src/io/perm_1_exercise.cpp \
    ../src/io/perm_2_exercise.cpp \
    ../src/io/perm_3_exercise.cpp \
    ../src/io/perm_4_exercise.cpp \
    ../src/io/perm_5_exercise.cpp \
    ../src/io/perm_6_exercise.cpp \
    ../src/io/vigenere_1_exercise.cpp \
    ../src/io/vigenere_2_exercise.cpp \
    ../src/io/vigenere_3_exercise.cpp \
    ../src/io/vigenere_4_exercise.cpp \
    ../src/io/vigenere_5_exercise.cpp \
    ../src/io/vigenere_6_exercise.cpp \
    ../src/io/vigenere_7_exercise.cpp

OTHER_FILES += ../src/helpers/stats.txt

RESOURCES += ../resources.qrc

lupdate_only{
SOURCES = ../qml/*.qml \
    ../qml/common/*.js \
    ../qml/common/*.qml \
    ../qml/exercises/caesar/*.js \
    ../qml/exercises/caesar/*.qml \
    ../qml/exercises/*.js \
    ../qml/exercises/perm/*.js \
    ../qml/exercises/perm/*.qml \
    ../qml/exercises/*.qml \
    ../qml/exercises/vigenere/*.js \
    ../qml/exercises/vigenere/*.qml
}

HEADERS += \
    ../src/helpers/logger.h \
    ../src/helpers/view.h \
    ../src/helpers/calculations.h \
    ../src/helpers/stats.h \
    ../src/io/serializable.h \
    ../src/io/simplecrypt.h \
    ../src/io/caesar_1_exercise.h \
    ../src/io/exercise_list.h \
    ../src/io/exercise_loader.h \
    ../src/io/caesar_2_exercise.h \
    ../src/io/exercise.h \
    ../src/io/file_crypter.h \
    ../src/io/caesar_3_exercise.h \
    ../src/io/caesar_4_exercise.h \
    ../src/io/caesar_5_exercise.h \
    ../src/io/perm_1_exercise.h \
    ../src/io/perm_2_exercise.h \
    ../src/io/perm_3_exercise.h \
    ../src/io/perm_4_exercise.h \
    ../src/io/perm_5_exercise.h \
    ../src/io/perm_6_exercise.h \
    ../src/io/vigenere_1_exercise.h \
    ../src/io/vigenere_2_exercise.h \
    ../src/io/vigenere_3_exercise.h \
    ../src/io/vigenere_4_exercise.h \
    ../src/io/vigenere_5_exercise.h \
    ../src/io/vigenere_6_exercise.h \
    ../src/io/vigenere_7_exercise.h

mac {
    Exercises.files = ../exercises
    Exercises.path = Contents/MacOS
    QMAKE_BUNDLE_DATA += Exercises
}
