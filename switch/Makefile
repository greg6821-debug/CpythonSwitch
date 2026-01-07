# ============================
# Project configuration
# ============================

APP := test_python
BUILD := build

SOURCES := source/main.c
ROMFS := romfs

# ОБЯЗАТЕЛЬНО: платформа должна быть объявлена ДО include
PLATFORM := switch

# 🔑 ВАЖНО: первая цель
all: $(APP).nro

# ============================
# Environment checks
# ============================

ifndef DEVKITPRO
$(error DEVKITPRO is not set. Please set it to the devkitPro installation path)
endif

# ============================
# Include devkitPro rules
# ============================

include $(DEVKITPRO)/devkitA64/base_rules

# ============================
# Custom flags
# ============================

# CPython headers
CFLAGS += -I../python39-switch/include/python3.9

# Link against static Python + libnx
LIBS += \
	../python39-switch/lib/libpython3.9.a \
	-lnx -lm -lz

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
# Clean
# ============================

clean:
	rm -rf $(BUILD) *.nro *.elf *.bin
