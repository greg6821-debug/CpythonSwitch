APP := python39-test
BUILD := build
TARGET := $(BUILD)/$(APP)

DEVKITPRO ?= /opt/devkitpro

include $(DEVKITPRO)/libnx/rules

CFLAGS += -I../python39-switch/include/python3.9
CFLAGS += -O2

LIBS := \
	../python39-switch/lib/libpython3.9.a \
	-lz -lm -lnx

SOURCES := source/main.c
ROMFS := romfs

all: $(TARGET).nro

$(TARGET).elf: $(SOURCES)
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $^ $(LIBS) -o $@

$(TARGET).nro: $(TARGET).elf
	nacptool --create "Python 3.9 Test" "CPythonSwitch" "0.1.0" $(TARGET).nacp
	elf2nro $(TARGET).elf $@ --nacp=$(TARGET).nacp --romfsdir=$(ROMFS)

clean:
	rm -rf $(BUILD)
