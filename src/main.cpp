#include <QApplication>
#include <QFontDatabase>
#include <QtQml>
#include <QDebug>

#include "helpers/logger.h"
#include "helpers/view.h"
#include "helpers/calculations.h"
#include "io/exercise_list.h"
#include "io/exercise_loader.h"
#include "io/caesar_1_exercise.h"
#include "io/caesar_2_exercise.h"
#include "io/caesar_3_exercise.h"
#include "io/caesar_4_exercise.h"
#include "io/caesar_5_exercise.h"

#include "io/perm_1_exercise.h"
#include "io/perm_2_exercise.h"
#include "io/perm_3_exercise.h"
#include "io/perm_4_exercise.h"
#include "io/perm_5_exercise.h"
#include "io/perm_6_exercise.h"

#include "io/vigenere_1_exercise.h"
#include "io/vigenere_2_exercise.h"
#include "io/vigenere_3_exercise.h"
#include "io/vigenere_4_exercise.h"
#include "io/vigenere_5_exercise.h"
#include "io/vigenere_6_exercise.h"
#include "io/vigenere_7_exercise.h"


Logger *logger;

void myMessageOutput(QtMsgType type, const QMessageLogContext &, const QString &msg)
{
    QByteArray localMsg = msg.toLocal8Bit();
    logger->log(localMsg, type);

    if (type == QtFatalMsg) {
        abort();
    }
}

static QObject *calculations_provider(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return new Calculations();
}

static QObject *exercise_loader_provider(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return new ExerciseLoader();
}

static QObject *stats_provider(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return new Stats();
}

int main(int argc, char *argv[]) {
    //application title
    QApplication app(argc, argv);

    logger = new Logger();

    //message handler for logger
    qInstallMessageHandler(myMessageOutput);

    //register as singleton type
    qmlRegisterSingletonType<Calculations>("CCode", 1, 0, "Calculations", calculations_provider);
    qmlRegisterSingletonType<Stats>("CCode", 1, 0, "Stats", stats_provider);
    qmlRegisterSingletonType<ExerciseLoader>("ExerciseLoader", 1, 0, "ExerciseLoader", exercise_loader_provider);

    //register
    qmlRegisterType<ExerciseList>("com.SKrypter.ExerciseList", 1, 0, "ExerciseList");
    qmlRegisterType<Exercise>("com.SKrypter.Exercise", 1, 0, "Exercise");
    qmlRegisterType<Caesar1Exercise>("com.SKrypter.Caesar1Exercise", 1, 0, "Caesar1Exercise");
    qmlRegisterType<Caesar2Exercise>("com.SKrypter.Caesar2Exercise", 1, 0, "Caesar2Exercise");
    qmlRegisterType<Caesar3Exercise>("com.SKrypter.Caesar3Exercise", 1, 0, "Caesar3Exercise");
    qmlRegisterType<Caesar4Exercise>("com.SKrypter.Caesar4Exercise", 1, 0, "Caesar4Exercise");
    qmlRegisterType<Caesar5Exercise>("com.SKrypter.Caesar5Exercise", 1, 0, "Caesar5Exercise");

    qmlRegisterType<Perm1Exercise>("com.SKrypter.Perm1Exercise", 1, 0, "Perm1Exercise");
    qmlRegisterType<Perm2Exercise>("com.SKrypter.Perm2Exercise", 1, 0, "Perm2Exercise");
    qmlRegisterType<Perm3Exercise>("com.SKrypter.Perm3Exercise", 1, 0, "Perm3Exercise");
    qmlRegisterType<Perm4Exercise>("com.SKrypter.Perm4Exercise", 1, 0, "Perm4Exercise");
    qmlRegisterType<Perm5Exercise>("com.SKrypter.Perm5Exercise", 1, 0, "Perm5Exercise");
    qmlRegisterType<Perm6Exercise>("com.SKrypter.Perm6Exercise", 1, 0, "Perm6Exercise");

    qmlRegisterType<Vigenere1Exercise>("com.SKrypter.Vigenere1Exercise", 1, 0, "Vigenere1Exercise");
    qmlRegisterType<Vigenere2Exercise>("com.SKrypter.Vigenere2Exercise", 1, 0, "Vigenere2Exercise");
    qmlRegisterType<Vigenere3Exercise>("com.SKrypter.Vigenere3Exercise", 1, 0, "Vigenere3Exercise");
    qmlRegisterType<Vigenere4Exercise>("com.SKrypter.Vigenere4Exercise", 1, 0, "Vigenere4Exercise");
    qmlRegisterType<Vigenere5Exercise>("com.SKrypter.Vigenere5Exercise", 1, 0, "Vigenere5Exercise");
    qmlRegisterType<Vigenere6Exercise>("com.SKrypter.Vigenere6Exercise", 1, 0, "Vigenere6Exercise");
    qmlRegisterType<Vigenere7Exercise>("com.SKrypter.Vigenere7Exercise", 1, 0, "Vigenere7Exercise");

    //app.setApplicationName("SKrypter");
    app.setOrganizationName("ETH Zuerich ABZ");
    app.setOrganizationDomain("ethz.ch");

    //install kingthings clarity font
    QFontDatabase::addApplicationFont(":/fonts/Kingthings_Clarity1.1.ttf");
    app.setFont(QFont("Kingthings Clarity"));

    //initialize the view
    View view;

    //set up translations
    QTranslator translator;
    // Load from qrc resources
    QString currentLanguage = view.getLanguage();
    if (!translator.load(":/translations/SKrypter_" + currentLanguage)) {
        qWarning() << "main.cpp could not load translation file for language " << currentLanguage;
    }
    qApp->installTranslator(&translator);

    //initialize view at this point because we need to hae loaded the translator!
    view.start();

    int returnValue = app.exec();

    delete logger;

    return returnValue;
}





