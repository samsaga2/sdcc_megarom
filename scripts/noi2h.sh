#!/bin/sh
echo "#pragma once"
echo ""
grep DEF._ "$1" | perl -pe 's/DEF\ _(.*)\ (0x[0-9A-Fa-f]+)/#define ADDR_\U$1 \L$2/'
