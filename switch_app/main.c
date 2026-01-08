#include <switch.h>
#include <Python.h>

int main(int argc, char **argv)
{
    consoleInit(NULL);

    printf("Python 3.9 on Nintendo Switch\n\n");

    Py_SetProgramName(L"python");
    Py_Initialize();

    PyRun_SimpleString(
        "print('Hello from Python!')\n"
        "print('2 + 2 =', 2 + 2)\n"
    );

    Py_Finalize();

    printf("\nPress PLUS to exit\n");

    while (appletMainLoop())
    {
        hidScanInput();
        if (hidKeysDown(CONTROLLER_P1_AUTO) & KEY_PLUS)
            break;
        consoleUpdate(NULL);
    }

    consoleExit(NULL);
    return 0;
}
