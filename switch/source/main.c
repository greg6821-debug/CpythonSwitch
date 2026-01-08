#include <stdio.h>
#include <Python.h>

int main(int argc, char **argv) {
    // Устанавливаем домашний каталог Python на SD-карту
    Py_SetPythonHome(L"sdmc:/python");
    
    // Инициализируем Python
    if (!Py_Initialize()) {
        printf("Failed to initialize Python.\n");
        return 1;
    }
    
    // Добавляем путь к пользовательским модулям на SD-карту
    PyRun_SimpleString("import sys; sys.path.append('sdmc:/python/lib'); sys.path.append('sdmc:/python/userlib')");
    
    // Простой тест Python
    PyRun_SimpleString("print('Hello from Python on Switch!')\n"
                       "print('Python version:', sys.version)\n");
    
    // Если передан аргумент - скрипт для запуска
    if (argc > 1) {
        FILE* script = fopen(argv[1], "r");
        if (script) {
            PyRun_SimpleFile(script, argv[1]);
            fclose(script);
        } else {
            printf("Cannot open script: %s\n", argv[1]);
        }
    }
    
    Py_Finalize();
    return 0;
}
