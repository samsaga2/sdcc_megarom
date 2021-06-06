#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* #define DEBUGINFO */

enum {
    TYPE_DATA = 0,
    TYPE_END = 1,
    TYPE_SET_SEGMENT = 4
};

char rom[512 * 1024];

void init_rom() {
    memset(rom, sizeof(rom), 1);
}

void set_data(int count, int page_num, int bank_addr, char* data) {
    int rom_offset = page_num * 0x2000 + (bank_addr & 0x1fff);

    #ifdef DEBUGINFO
    printf("addr 0x%05x - page %2d - rom addr 0x%06x - data %s\n", bank_addr, page_num, rom_offset, data);
    #endif
    char *rom_ptr = &rom[rom_offset];
    do {
        int byte;
        sscanf(data, "%2x", &byte);
        data += 2;
        *rom_ptr++=byte;
    } while(count--);
}

void compile(const char* filename) {
    int count, addr, type;
    char data[256];
    int segment = 0;
    
    FILE* in = fopen(filename, "r");
    while(!feof(in)) {
        fscanf(in, ":%2x%4x%2x%s\n", &count, &addr, &type, data);
        switch(type) {
        case TYPE_DATA:
            set_data(count, segment, addr, data);
            break;
        case TYPE_SET_SEGMENT:
            sscanf(data+2, "%2x", &segment);
            break;
        case TYPE_END:
            break;
        default:
            printf("unknown type %2x\n", type);
            exit(2);
        }
    }
    fclose(in);
}

void save_rom(const char* filename) {
    FILE* out = fopen(filename, "wb");
    fwrite(rom, sizeof(rom), 1, out);
    fclose(out);
}

int main(int argc, const char** argv) {
    if(argc < 2) {
        return 1;
    }

    init_rom();
    compile(argv[1]);
    save_rom(argv[2]);

    return 0;
}
