CCFLAGS = -mz80 --opt-code-speed --std-c11 --no-std-crt0 --nostdlib --max-allocs-per-node 100000 
BANK0_SIZE = 0x3000
BANKn_SIZE = 0x4000
BANK0_ADDR = 0x04100
BANK2_ADDR = 0x08000
BANKS_ADDR = -Wl-b_BANK0=$(BANK0_ADDR) -Wl-b_BANK2=$(BANK2_ADDR) 
RAM_ADDR = 0xc000

OBJ = build/megarom.rel build/main.rel build/test.rel

all: compile run

compile: banks build/megarom.rel build/makerom build/main.ihx build/main.rom

banks:
	-mkdir build
	cd build && sdcc $(CCFLAGS) --codeseg BANK0 --code-size $(BANK0_SIZE) -c ../src/main.c
	cd build && sdcc $(CCFLAGS) --codeseg BANK2 --code-size $(BANKn_SIZE) -c ../src/test.c

build/megarom.rel: src/megarom.s
	sdasz80 -o $@ src/megarom.s

build/main.ihx: $(OBJ)
	sdcc $(CCFLAGS) -o $@ --data-loc $(RAM_ADDR) $(BANKS_ADDR) $(OBJ)

build/makerom: util/makerom.c
	gcc util/makerom.c -o $@

build/main.rom: build/main.ihx
	./build/makerom build/main.ihx $@

run:
	openmsx -carta build/main.rom

clean:
	-rm -rf build
