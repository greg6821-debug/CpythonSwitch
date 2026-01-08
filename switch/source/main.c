#include <switch.h>
#include <Python.h>

int main(int argc, char* argv[])
{
    consoleInit(NULL);

    Py_SetProgramName(L"python");
    Py_Initialize();

    PyRun_SimpleString(
        "import sys\n"
        "sys.path.insert(0, 'sdmc:/python')\n"
        "import test_renpy\n"
    );

    Py_Finalize();

    printf("\nDone. Press PLUS to exit.\n");
    while (appletMainLoop()) {
        hidScanInput();
        if (hidKeysDown(CONTROLLER_P1_AUTO) & KEY_PLUS)
            break;
        consoleUpdate(NULL);
    }

    consoleExit(NULL);
    return 0;
}
