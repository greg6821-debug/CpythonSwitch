APP := test_python
BUILD := build

# Проверяем наличие DEVKITPRO
ifndef DEVKITPRO
$(error DEVKITPRO is not set. Please set it to the devkitPro installation path)
endif

# Проверяем наличие файла правил
ifeq (,$(wildcard $(DEVKITPRO)/devkitA64/switch_rules))
ifeq (,$(wildcard $(DEVKITPRO)/devkitA64/base_rules))
$(error Cannot find switch_rules or base_rules in $(DEVKITPRO)/devkitA64)
else
include $(DEVKITPRO)/devkitA64/base_rules
endif
else
include $(DEVKITPRO)/devkitA64/switch_rules
endif

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
	$(ELF2NRO) $(BUILD).elf $@ --romfsdir=$(ROMFS)

clean:
	rm -rf $(BUILD) *.nro
