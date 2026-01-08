#include <switch.h>
#include <Python.h>

int main(int argc, char **argv) {
    // Инициализация консоли Switch (опционально, для отладки)
    consoleInit(NULL);

    // КРИТИЧЕСКОЕ ИСПРАВЛЕНИЕ: Устанавливаем домашний каталог Python на SD-карту
    Py_SetPythonHome(L"sdmc:/python");

    // Инициализируем интерпретатор Python
    if (!Py_Initialize()) {
        printf("[ERROR] Failed to initialize Python interpreter.\n");
        consoleUpdate(NULL);
        svcSleepThread(3000000000ULL); // Задержка 3 секунды
        consoleExit(NULL);
        return 1;
    }

    // Добавляем путь к стандартной библиотеке на SD-карту
    PyRun_SimpleString("import sys\n"
                       "sys.path.insert(0, 'sdmc:/python/lib')\n"
                       "sys.path.insert(0, 'sdmc:/python')\n");

    printf("[INFO] Python initialized successfully.\n");
    printf("[INFO] Running: sdmc:/python/main.py\n");

    // Запуск основного пользовательского скрипта
    FILE* main_script = fopen("sdmc:/python/main.py", "r");
    if (main_script) {
        PyRun_SimpleFile(main_script, "sdmc:/python/main.py");
        fclose(main_script);
    } else {
        printf("[ERROR] Could not open sdmc:/python/main.py\n");
        PyRun_SimpleString("print('Hello from Python on Nintendo Switch!')");
    }

    // Завершение работы
    Py_Finalize();
    printf("[INFO] Application finished.\n");

    // Ожидание перед выходом
    while (appletMainLoop()) {
        consoleUpdate(NULL);
        hidScanInput();
        if (hidKeysDown(CONTROLLER_P1_AUTO) & KEY_PLUS) break;
    }

    consoleExit(NULL);
    return 0;
}
