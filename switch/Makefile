# ============================
# Project configuration
# ============================
TARGET := test_python
BUILD := build
SOURCES := source/main.c
PLATFORM := switch

# ============================
# Environment checks
# ============================
ifndef DEVKITPRO
$(error DEVKITPRO is not set. Please set it to your devkitPro installation path)
endif

# ============================
# Custom flags
# ============================
CFLAGS += -I../python39-switch/include/python3.9
# Линкуем только уже собранный Python для Switch
LIBS += ../python39-switch/lib/libpython3.9.a

# ============================
# Debug output
# ============================
$(info ===== DEBUG =====)
$(info DEVKITPRO=$(DEVKITPRO))
$(info PLATFORM=$(PLATFORM))
$(info CC=$(CC))
$(info CFLAGS=$(CFLAGS))
$(info LIBS=$(LIBS))
$(info =================)

# ============================
# Include devkitPro rules
# ============================
include $(DEVKITPRO)/libnx/switch_rules

# ============================
# Targets
# ============================
all: $(TARGET).nro

# ============================
# Clean
# ============================
#clean:
	#rm -rf $(BUILD) *.nro *.elf *.bin
