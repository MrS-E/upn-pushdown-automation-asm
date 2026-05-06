CC = gcc

TARGET = upn
CSRC = main.c
ASMSRC = upn.asm

COBJ = $(CSRC:.c=.o)
ASMOBJ = $(ASMSRC:.asm=.o)

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(COBJ) $(ASMOBJ)
	$(CC) $^ -o $@

%.o: %.c
	$(CC) -c $< -o $@

%.o: %.asm
	$(CC) -x assembler -c $< -o $@

clean:
	rm -f $(TARGET) $(COBJ) $(ASMOBJ)