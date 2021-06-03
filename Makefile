CCFLAGS = -mz80 --opt-code-speed --std-c11 --no-std-crt0 --nostdlib

all: linker compile

linker:
	-mkdir build
	gcc util/makerom.c -o build/makerom

compile:
	sdcc $(CCFLAGS) --codeseg BANK1 --code-size 0x2000 -c src/main.c
	sdcc $(CCFLAGS) --codeseg BANK5 --code-size 0x2000 -c src/bank1.c
	sdasz80 -o megarom.rel src/megarom.s
	sdcc $(CCFLAGS) -o main.ihx --data-loc 0xc000 -Wl-b_BANK1=0x06000 -Wl-b_BANK5=0x16000 megarom.rel main.rel bank1.rel
	./build/makerom main.ihx main.rom

clean:
	-rm *.lst *.asm *.map *.sym *.noi *.rel *.ihx *.lk *.rom
