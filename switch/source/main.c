#include <switch.h>
#include <Python.h>
#include <stdio.h>

void userAppInit(void) {
    // Инициализация romfs и SD-карты
    fsdevMountSdmc();
    romfsInit();

    // Перенаправляем stdout / stderr в файл на SD
    freopen("sdmc:/renpy_switch.log", "w", stdout);
    freopen("sdmc:/renpy_switch.log", "w", stderr);

    printf("=== Python Switch smoketest launcher started ===\n");
}

void userAppExit(void) {
    romfsExit();
}

// Простая функция для sleep из libnx, чтобы проверить модуль _nx
static PyObject* py_nx_sleep(PyObject* self, PyObject* args) {
    double seconds;
    if (!PyArg_ParseTuple(args, "d", &seconds))
        return NULL;

    uint64_t ns = (uint64_t)(seconds * 1000000000ULL);
    Py_BEGIN_ALLOW_THREADS
    svcSleepThread(ns);
    Py_END_ALLOW_THREADS
    Py_RETURN_NONE;
}

int main(int argc, char* argv[]) {
    userAppInit();

    // Python flags
    Py_NoSiteFlag = 1;
    Py_IgnoreEnvironmentFlag = 1;
    Py_NoUserSiteDirectory = 1;
    Py_DontWriteBytecodeFlag = 1;
    Py_OptimizeFlag = 2;


    // Инициализация Python
    Py_InitializeEx(0);

    // Устанавливаем домашнюю директорию
    setenv("HOME", "/save", 1);

    // Загружаем и выполняем smoketest
    FILE* test_file = fopen("romfs:/renpy_smoketest.py", "r");
    if (!test_file) {
        printf("Could not find renpy_smoketest.py\n");
        Py_Finalize();
        userAppExit();
        return 1;
    }

    PyRun_SimpleFile(test_file, "renpy_smoketest.py");
    fclose(test_file);

    Py_Finalize();
    userAppExit();

    return 0;
}
