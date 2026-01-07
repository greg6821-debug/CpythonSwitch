#include <switch.h>
#include <hid.h>
#include <console.h>
#include <Python.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    consoleInit(NULL);

    printf("Starting Python...\n");

    Py_SetProgramName(L"python");
    Py_Initialize();

    FILE *fp = fopen("romfs:/renpy_smoketest.py", "r");
    if (!fp) {
        printf("Failed to open test script\n");
        Py_Finalize();
        consoleUpdate(NULL);
        while (appletMainLoop()) svcSleepThread(1e9);
    }

    PyRun_SimpleFile(fp, "renpy_smoketest.py");
    fclose(fp);

    Py_Finalize();

    printf("Python finished\n");
    consoleUpdate(NULL);

    while (appletMainLoop()) {
        hidScanInput();
        if (hidKeysDown(CONTROLLER_P1_AUTO) & KEY_PLUS)
            break;
        consoleUpdate(NULL);
    }

    consoleExit(NULL);
    return 0;
}
