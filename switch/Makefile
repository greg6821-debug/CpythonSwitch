APP := python39-test
BUILD := build
TARGET := $(BUILD)/$(APP)

include $(DEVKITPRO)/devkitA64/switch_rules

CFLAGS += -I../python39-switch/include/python3.9
LDFLAGS += \
    ../python39-switch/lib/libpython3.9.a \
    -lz -lm -lnx

SOURCES := source/main.c

ROMFS := romfs

all: $(TARGET).nro

$(TARGET).elf:
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $(SOURCES) $(LDFLAGS) -o $@

$(TARGET).nro: $(TARGET).elf
	nacptool --create "Python 3.9 Test" "CPythonSwitch" "0.1.0" $(TARGET).nacp
	elf2nro $(TARGET).elf $@ --nacp=$(TARGET).nacp --romfsdir=$(ROMFS)

clean:
	rm -rf $(BUILD)
