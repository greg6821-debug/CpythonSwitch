APP := test_python
BUILD := build

SOURCES := source/main.c
ROMFS := romfs


$(info ===== DEBUG =====)
$(info DEVKITPRO=$(DEVKITPRO))
$(info PLATFORM=$(PLATFORM))
$(info CFLAGS=$(CFLAGS))
$(info LIBS=$(LIBS))
$(info =================)


ifndef DEVKITPRO
$(error DEVKITPRO is not set)
endif

# ВАЖНО
PLATFORM := switch

include $(DEVKITPRO)/devkitA64/base_rules

# Python
CFLAGS += -I../python39-switch/include/python3.9

LIBS += \
    ../python39-switch/lib/libpython3.9.a \
    -lnx -lm -lz
