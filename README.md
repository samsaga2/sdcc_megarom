How to compile?
===============

Dependencies:
- Linux
- gcc
- sdcc 4.1

Compile command:
`make`

Test pages
==========

Pages 0&1 are fixed, never changes.
Pages 2&3 always change together.

How it works?
=============

Tools
-----

- SDCC 4.1.0
- gcc (for makerom)

Functions
---------

The functions that can be called from any page must be marked as __banked. The non-banked functions are
only callable from the same module (they are not callable from other pages).

Pages
-----

A megarom mapper has four pages:
- Page 0: 0x4000-0x5fff
- Page 1: 0x6000-0x7fff
- Page 2: 0x8000-0x9fff
- Page 3: 0xa000-0xbfff

Banks
-----

And your code is organized in 64 banks (64 banks by 0x2000 bytes per bank are 512kb).
You can select any bank in any page but, for simplicity the banks only will be selected for single page:
- bank 0 will be at page 0
- bank 1 at page 1
- bank 2 at page 2
- bank 3 at page 3
- bank 4 at page 0
- bank 5 at page 1
- bank 6 at page 2
- ...

Assigning banks to modules
--------------------------

You have to assign a bank to each module at compile time:
> `sdcc $(CCFLAGS) --codeseg BANK1 --code-size 0x2000 -c src/main.c`
> The module main will be assigned to the bank 1
> 
> `sdcc $(CCFLAGS) --codeseg BANK5 --code-size 0x2000 -c src/test.c`
> The module test will be assigned to the bank 5

Compiling header
----------------

Obviously you need the megarom header and init code:
> `sdasz80 -o megarom.rel src/megarom.s`

Linking
-------

At linking time will assign the bank addresses:
> `sdcc $(CCFLAGS) -o main.ihx --data-loc 0xc000 -Wl-b_BANK1=0x06000 -Wl-b_BANK5=0x16000 megarom.rel main.rel bank1.rel`
> BANK1 will have address 0x6000 page 1 bank 1
> BANK5 will have address 0x6000 page 1 bank 5
Note that the page number is inferred from the bank address.

The bank number is inferred from the bank name.

To generate the bank in the correct file rom position you need to set the segmentation and the address correctly (flag -Wl-b).
- Example address: A=0x16000
- Segmentation: S=A>>16=0x1
- Bank address: BA=A&0xffff=0x6000
- Bank number: BN=S*4+((BA-0x4000)>>12)/2=5

Finally
-------

To create the rom:
`./build/makerom main.ihx main.rom`

The _makerom_ program will the the generated Intel HEX file and it will create a megarom file.
