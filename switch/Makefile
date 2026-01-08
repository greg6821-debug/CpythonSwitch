#---------------------------------------------------------------------------------
# Базовые настройки для Switch
#---------------------------------------------------------------------------------
TARGET      := python_launcher
BUILD       := build
SOURCES     := source
INCLUDES    := include
LIBDIRS     := ../python39-switch/lib

#---------------------------------------------------------------------------------
# Использование инструментов devkitA64
#---------------------------------------------------------------------------------
export PATH := $(PATH):/opt/devkitpro/devkitA64/bin

PREFIX  := aarch64-none-elf-
CC      := $(PREFIX)gcc
CXX     := $(PREFIX)g++
AS      := $(PREFIX)as
LD      := $(PREFIX)gcc
OBJCOPY := $(PREFIX)objcopy
STRIP   := $(PREFIX)strip

#---------------------------------------------------------------------------------
# Флаги компиляции и линковки
#---------------------------------------------------------------------------------
ARCH := -march=armv8-a+crc+crypto -mtune=cortex-a57 -mtp=soft -fPIE

CFLAGS   := -g -Wall -O2 -ffunction-sections $(ARCH) $(INCLUDE)
CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions
ASFLAGS  := -g $(ARCH)
LDFLAGS  := -specs=$(DEVKITPRO)/libnx/switch.specs -g $(ARCH) -Wl,-Map,$(TARGET).map

# ИСПРАВЛЕНИЕ: Используем правильное имя библиотеки Python
LIBS := -lpython3.9 -lnx

#---------------------------------------------------------------------------------
# Сборка списка исходных файлов
#---------------------------------------------------------------------------------
CFILES   := $(shell find $(SOURCES) -name '*.c')
CPPFILES := $(shell find $(SOURCES) -name '*.cpp')
SFILES   := $(shell find $(SOURCES) -name '*.s')
OFILES   := $(CFILES:.c=.o) $(CPPFILES:.cpp=.o) $(SFILES:.s=.o)

#---------------------------------------------------------------------------------
# Правила сборки
#---------------------------------------------------------------------------------
all: $(TARGET).nro

$(TARGET).nro: $(TARGET).elf
    @echo "Creating NRO..."
    @elf2nro $< $@ --icon=../icon.jpg --nacp=../control.nacp

$(TARGET).elf: $(OFILES)
    @echo "Linking ELF..."
    @$(LD) $(LDFLAGS) $(OFILES) $(LIBDIRS:%=-L%) $(LIBS) -o $@

%.o: %.c
    @echo "Compiling $<..."
    @$(CC) $(CFLAGS) -c $< -o $@

clean:
    @echo "Cleaning..."
    @rm -rf $(BUILD) $(TARGET).elf $(TARGET).nro $(OFILES)

.PHONY: all clean
