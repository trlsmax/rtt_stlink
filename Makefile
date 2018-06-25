ifeq ($(OS),Windows_NT)
TARGET = rtt_stlink.exe
CC = i686-w64-mingw32-gcc
LINKER = i686-w64-mingw32-g++
RM=del
INC_IUP  = ./include/iup
LD_LIB  = ./lib/win_32
else
TARGET = rtt_stlink
CC = gcc
LINKER = g++
RM=rm
LBITS := $(shell getconf LONG_BIT)
ifeq ($(LBITS),64)
INC_IUP  = ./include/iup
LD_LIB  = ./lib/linux_64
else
INC_IUP  = ./include/iup
LD_LIB  = ./lib/linux_86
endif
endif
C_FLAG = -I. -I./include -I$(INC_IUP) -c -std=c99
L_FLAG = $(LD_LIB)/libiup.a $(LD_LIB)/libstlink.a $(LD_LIB)/libusb-1.0.a
ifeq ($(OS),Windows_NT)
L_FLAG += -lkernel32 -luser32 -lgdi32 -lwinspool -lcomdlg32 -ladvapi32 -lshell32 -lole32 -loleaut32 -luuid -lcomctl32 -lsetupapi -mwindows -static 
else
ifeq ($(LBITS),64)
L_FLAG += $(shell pkg-config --libs gtk+-3.0 gdk-3.0)
else
L_FLAG += $(shell pkg-config --libs gtk+-2.0 gdk-2.0)
endif
L_FLAG += -lX11 -lpthread -ludev
endif

$(TARGET):rtt_stlink.o
	$(LINKER) $^ $(L_FLAG) -o $(TARGET)

rtt_stlink.o:rtt_stlink.c
	$(CC) $^ $(C_FLAG)

clean:
	$(RM) -f *.o
	$(RM) -f $(TARGET)
