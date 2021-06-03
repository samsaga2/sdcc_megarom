#include "bank1.h"

char test_func(char i, char j) __banked {
	return i+j;
}
