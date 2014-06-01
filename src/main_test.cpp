#include <QtQuickTest/quicktest.h>
#include <QtQml>

#include "helpers/calculations.h"
#include "helpers/stats.h"
#include "helpers/logger.h"

static QObject *calculations_provider(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return new Calculations();
}


static QObject *stats_provider(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return new Stats();
}

void registerSingletons() {
    qmlRegisterSingletonType<Calculations>("CCode", 1, 0, "Calculations", calculations_provider);
    qmlRegisterSingletonType<Stats>("CCode", 1, 0, "Stats", stats_provider);
}

int main(int argc, char **argv)
{
    registerSingletons();
    return quick_test_main(argc, argv, "TestName", QUICK_TEST_SOURCE_DIR);
}
