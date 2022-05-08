#ifdef _WIN32
#define _CRT_SECURE_NO_WARNINGS
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* #define DEBUGINFO */

enum {
    TYPE_DATA = 0,
    TYPE_END = 1,
    TYPE_SET_SEGMENT = 4
};

#define NUM_PAGES 64
#define PAGE_SIZE 0x2000 // if you change this, you must modify set_data

char rom[NUM_PAGES * PAGE_SIZE];
int  used_page_space[NUM_PAGES] = {0};

void init_rom() {
    memset(rom, sizeof(rom), 1);
}

void set_data(int count, int page_num, int bank_addr, char* data) {
    used_page_space[page_num] += count;
    if(PAGE_SIZE*2-used_page_space[page_num]<0) {
        printf("rom page %d is full\n", page_num);
        exit(1);
    }
    
    int rom_offset = page_num * PAGE_SIZE + (bank_addr & 0x3fff);

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

void show_used_space() {
    printf("page | used | free\n");
    printf("-----+------+-----\n");
    int total_used = 0;
    int total_free = NUM_PAGES * PAGE_SIZE;
    for(int i = 0; i < NUM_PAGES; i++)
        if(used_page_space[i] > 0) {
            int page_free = PAGE_SIZE*2-used_page_space[i];
            total_used += used_page_space[i];
            total_free -= used_page_space[i];
            printf("  %02x | %04x | %04x\n", i, used_page_space[i], page_free);
        }
    printf("total used %d bytes\n", total_used);
    printf("total free %d bytes\n", total_free);
}

int main(int argc, const char** argv) {
    if(argc < 2) {
        return 1;
    }

    init_rom();
    compile(argv[1]);
    save_rom(argv[2]);
    show_used_space();

    return 0;
}
