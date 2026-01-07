# ============================
# Project configuration
# ============================
TARGET := test_python
BUILD := build
SOURCES := source/main.c
ROMFS := romfs
# ОБЯЗАТЕЛЬНО: платформа должна быть объявлена ДО include
PLATFORM := switch
# ============================
# Environment checks
# ============================
ifndef DEVKITPRO
$(error DEVKITPRO is not set. Please set it to the devkitPro installation path)
endif
# ============================
# Custom flags
# ============================
# CPython headers
CFLAGS += -I../python39-switch/include/python3.9
# Link against static Python + libnx
LIBS += ../python39-switch/lib/libpython3.9.a \
        -L$(DEVKITPRO)/libnx/lib -lnx -lm -lz
# ============================
# Debug output (optional)
# ============================
$(info ===== DEBUG =====)
$(info DEVKITPRO=$(DEVKITPRO))
$(info PLATFORM=$(PLATFORM))
$(info CC=$(CC))
$(info CFLAGS=$(CFLAGS))
$(info LIBS=$(LIBS))
$(info =================)
# ============================
# Include devkitPro rules for Switch
# ============================
include $(DEVKITPRO)/libnx/switch_rules
# ============================
# Targets
# ============================
all: $(TARGET).nro
# ============================
# Clean
# ============================
clean:
	rm -rf $(BUILD) *.nro *.elf *.bin
