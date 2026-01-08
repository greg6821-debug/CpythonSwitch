#include <stdio.h>
#include <switch.h>
#include <Python.h>

int main(int argc, char* argv[])
{
    // Инициализация Switch API
    socketInitializeDefault();
    nxlinkStdio();
    
    printf("Python for Switch initializing...\n");
    
    // Устанавливаем домашний каталог Python на SD-карту
    // Это необходимо для поиска стандартной библиотеки
    Py_SetPythonHome(L"sdmc:/python");
    
    // Инициализируем интерпретатор Python
    if (!Py_Initialize()) {
        printf("ERROR: Failed to initialize Python interpreter!\n");
        socketExit();
        return 1;
    }
    
    printf("Python initialized successfully\n");
    
    // Добавляем путь к SD-карте в sys.path
    PyRun_SimpleString("import sys");
    PyRun_SimpleString("sys.path.insert(0, 'sdmc:/python')");
    PyRun_SimpleString("sys.path.insert(0, 'sdmc:/python/Lib')");
    
    // Пробуем выполнить скрипт на SD-карте
    printf("Attempting to run sdmc:/python/main.py...\n");
    
    // Открываем файл для чтения
    FILE* fp = fopen("sdmc:/python/main.py", "r");
    if (fp) {
        fclose(fp);
        PyRun_SimpleString(
            "try:\n"
            "    import sys\n"
            "    with open('sdmc:/python/main.py', 'r') as f:\n"
            "        exec(f.read())\n"
            "    print('Script executed successfully')\n"
            "except Exception as e:\n"
            "    print(f'Error executing script: {e}')\n"
        );
    } else {
        printf("Warning: sdmc:/python/main.py not found\n");
        printf("Running interactive mode...\n");
        
        // Простой REPL, если скрипт не найден
        PyRun_SimpleString(
            "print('Python 3.9 on Nintendo Switch')\n"
            "print('Type quit() or Ctrl+D to exit')\n"
            "import code\n"
            "code.interact()\n"
        );
    }
    
    // Завершаем работу интерпретатора
    Py_Finalize();
    
    printf("Python interpreter finalized\n");
    
    // Завершаем работу Switch API
    socketExit();
    return 0;
}
