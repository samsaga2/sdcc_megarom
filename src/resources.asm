        include bios.asm

        module res

        defpage 0..1, 0, 0
        defpage 2..49, 0xa000, 0x2000

        page 2
p2_hello_world:
        db 'Hello world',0
