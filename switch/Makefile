APP := test_python
BUILD := build

SOURCES := source/main.c

ROMFS := romfs

# Проверка DEVKITPRO
ifndef DEVKITPRO
$(error DEVKITPRO is not set)
endif

include $(DEVKITPRO)/devkitA64/switch_rules

# Python
CFLAGS += -I../python39-switch/include/python3.9

LIBS += \
    ../python39-switch/lib/libpython3.9.a \
    -lnx -lm -lz

all: $(APP).nro

clean:
	rm -rf $(BUILD) *.nro
