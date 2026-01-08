DEVKITPRO ?= /opt/devkitpro
DEVKITA64 := $(DEVKITPRO)/devkitA64

include $(DEVKITPRO)/libnx/switch_rules

TARGET := python39
BUILD := build
SOURCES := .
INCLUDES := ../Python-3.9.22/Include
LIBDIRS := ../Python-3.9.22

LIBS := -lpython3.9 -lnx -lm -lc

CFLAGS := -O2 -Wall
LDFLAGS := -Wl,--gc-sections

ROMFS := romfs

all: $(TARGET).nro

$(BUILD):
	mkdir -p $(BUILD)

$(TARGET).elf: $(SOURCES)/main.c | $(BUILD)
	$(CC) $(CFLAGS) \
		-I$(INCLUDES) \
		$< \
		-L$(LIBDIRS) \
		$(LIBS) \
		-o $@

$(TARGET).nro: $(TARGET).elf
	nacptool --create "Python 3.9" "CPython" "1.0.0" python.nacp
	elf2nro $< $@ --nacp=python.nacp --romfsdir=$(ROMFS)

clean:
	rm -rf $(BUILD) *.elf *.nro *.nacp
