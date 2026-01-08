#include <Python.h>
#include <switch.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char* argv[]) {
    consoleInit(NULL);
    
    printf("Initializing Python for Switch...\n");
    consoleUpdate(NULL);
    
    // Устанавливаем домашний каталог Python на SD-карту
    Py_SetPythonHome(L"sdmc:/python");
    
    // Добавляем пути для поиска модулей
    wchar_t pythonPath[512];
    swprintf(pythonPath, sizeof(pythonPath) / sizeof(wchar_t),
             L"sdmc:/python/lib/python3.9:"
             L"sdmc:/python/lib/python3.9/lib-dynload:"
             L"sdmc:/python/lib/python3.9/site-packages");
    Py_SetPath(pythonPath);
    
    // Инициализируем интерпретатор
    if (!Py_Initialize()) {
        printf("ERROR: Failed to initialize Python!\n");
        consoleUpdate(NULL);
        svcSleepThread(3000000000ULL);
        consoleExit(NULL);
        return 1;
    }
    
    printf("Python initialized successfully\n");
    
    // Устанавливаем sys.argv
    wchar_t* wargv[1] = { L"switch_python" };
    PySys_SetArgv(1, wargv);
    
    // Проверяем работоспособность
    PyRun_SimpleString(
        "import sys\n"
        "print('Python version:', sys.version)\n"
        "print('Platform:', sys.platform)\n"
        "print('Path:', sys.path)\n"
        "print('Hello from Python on Nintendo Switch!')\n"
    );
    
    if (Py_FinalizeEx() < 0) {
        printf("ERROR: Python finalization failed\n");
    }
    
    printf("\nPress + to exit...\n");
    
    // Ожидание нажатия кнопки
    while (appletMainLoop()) {
        hidScanInput();
        u64 kDown = hidKeysDown(CONTROLLER_P1_AUTO);
        
        if (kDown & KEY_PLUS) {
            break;
        }
        
        consoleUpdate(NULL);
    }
    
    consoleExit(NULL);
    return 0;
}
