APP := test_python
BUILD := build

include $(DEVKITPRO)/devkitA64/switch_rules

CFLAGS += -I../python39-switch/include/python3.9
LDFLAGS += \
    ../python39-switch/lib/libpython3.9.a \
    -lnx -lm -lz

SOURCES := source/main.c

ROMFS := romfs

all: $(APP).nro

$(APP).nro: $(SOURCES)
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $(BUILD).elf
	$(OBJCOPY) -O binary $(BUILD).elf $(BUILD).bin
	$(DEVKITPRO)/tools/bin/elf2nro $(BUILD).elf $@ --romfsdir=$(ROMFS)

clean:
	rm -rf $(BUILD) *.nro
