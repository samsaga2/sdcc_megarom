CCFLAGS = -mz80 --no-std-crt0 --fsigned-char --opt-code-size --std-c99
CCPAGE01 = --code-loc 0x4020 --data-loc 0xc000
CCPAGE2 = --code-loc 0x8000 --data-loc 0xc000

PAGE = 8192
PAGE0_START = 16384 # 0x4000
PAGE1_START = 24576 # 0x4000+0x2000*1
PAGE2_START = 32768 # 0x4000+0x2000*2
PAGE3_START = 40960 # 0x4000+0x2000*2
ROMSIZE = 524288 # 512kb
ROMSIZE49 = 409600 # 50*0x2000

all: compile emulate


### its magic!

compile: megarom.rel main.rel variables.rel test.rel
	# build pages 0..1 - main code
	sdcc $(CCFLAGS) --code-loc 0x4020 --data-loc 0xc000 megarom.rel main.rel variables.rel
	makebin -s $(PAGE2_START) < megarom.ihx > megarom.bin
	dd if=megarom.bin of=page01.bin bs=1 skip=$(PAGE0_START)

	# build page 2..49 - resources
	sjasm -s src/resources.asm
	mv src/resources.out resources.bin

  # build page 50..63 - code
	sdcc $(CCFLAGS) --code-loc 0x8000 --data-loc 0xc000 test.rel variables.rel
	makebin -s 65535 < test.ihx > test.bin
	dd if=test.bin of=test_page2.bin bs=1 skip=$(PAGE2_START)
	truncate -s $(PAGE) test_page2.bin
	./scripts/noi2h.sh test.noi > src/test_funcs.h

	# build 512k megarom
	cat page01.bin > megarom.rom
	cat resources.bin >> megarom.rom
	truncate -s $(ROMSIZE49) megarom.rom
	cat test_page2.bin >> megarom.rom
	truncate -s $(ROMSIZE) megarom.rom


### compiling files

megarom.rel: src/megarom.asm
	sdasz80 -o megarom.rel src/megarom.asm

main.rel: src/main.c
	sdcc $(CCFLAGS) $(CCPAGE01) -c $<

variables.rel: src/variables.c
	sdcc $(CCFLAGS) $(CCPAGE01) -c $<

test.rel: src/test.c
	sdcc $(CCFLAGS) $(CCPAGE2) -c $<


### other things

emulate:
	openmsx -machine msx2plus -carta megarom.rom -script scripts/openmsx.tcl

clean:
	rm -f *.asm *.lst *.ihx *.noi *.rel *.sym *.lk *.map *.rom *.rst *.mem *.bin src/*.lst src/*.out

.PHONY: all compile clean clean
