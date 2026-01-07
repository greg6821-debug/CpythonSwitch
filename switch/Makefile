APP := python39-test
BUILD := build
TARGET := $(BUILD)/$(APP)

CFLAGS := -I../python39-switch/include/python3.9 \
          -I$(DEVKITPRO)/libnx/include \
          -O2

LDFLAGS := -L$(DEVKITPRO)/libnx/lib \
           -specs=libnx.specs \
           ../python39-switch/lib/libpython3.9.a \
           -lm

SOURCES := source/main.c
ROMFS := romfs

all: $(TARGET).nro

$(TARGET).elf: $(SOURCES)
	mkdir -p $(BUILD)
	aarch64-none-elf-gcc $(CFLAGS) $(SOURCES) $(LDFLAGS) -o $@

$(TARGET).nro: $(TARGET).elf
	nacptool --create "Python 3.9 Test" "CPythonSwitch" "0.1.0" $(TARGET).nacp
	elf2nro $(TARGET).elf $@ --nacp=$(TARGET).nacp --romfsdir=$(ROMFS)

clean:
	rm -rf $(BUILD)
