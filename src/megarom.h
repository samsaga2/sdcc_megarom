#pragma once

#define PAGE0(page) *((char*)0x5000) = page
#define PAGE1(page) *((char*)0x7000) = page
#define PAGE2(page) *((char*)0x9000) = page
#define PAGE3(page) *((char*)0xb000) = page
