#!/bin/sh
echo "#pragma once"
echo ""
echo "// addresses"
grep ^res $1 | perl -pe 's/res\.p([0-9]+)_(.*): equ ([0-9A-Fa-f]+)h/#define \URES_$2 \L0x$3/'
echo ""
echo "// pages"
grep ^res $1 | perl -pe 's/res\.p([0-9]+)_(.*): equ ([0-9A-Fa-f]+)h/#define \URESP_$2 1/'
