APP := python39-test
BUILD := build
TARGET := $(BUILD)/$(APP)

# Include paths
CFLAGS += -I../python39-switch/include/python3.9
CFLAGS += -I$(DEVKITPRO)/libnx/include
CFLAGS += -O2

# Libraries
LIBS := \
	../python39-switch/lib/libpython3.9.a \
	-L$(DEVKITPRO)/libnx/lib -lnx -lm

SOURCES := source/main.c
ROMFS := romfs

all: $(TARGET).nro

$(TARGET).elf: $(SOURCES)
	mkdir -p $(BUILD)
	aarch64-none-elf-gcc $(CFLAGS) $^ $(LIBS) -o $@

$(TARGET).nro: $(TARGET).elf
	nacptool --create "Python 3.9 Test" "CPythonSwitch" "0.1.0" $(TARGET).nacp
	elf2nro $(TARGET).elf $@ --n
