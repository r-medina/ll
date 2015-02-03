# all the cource code pregenerated as a string and not just the string `*.c`
SRC = $(wildcard *.c)
# loses the `.c` suffix
tmp = $(basename $(SRC))
# all the object files we will need
OBJ = $(addsuffix .o, $(tmp))

# gnu c compiler
CC = gcc

# `Wall`    - warns about questionable things
# `Werror`  - makes all warnings errors
# `Wextra`  - enables some extra warning flags that `all` doesn't set
# `Wunused` - complains about any variable, function, label, etc. not being used
CFLAGS = -Wall -Werror -Wextra -Wunused

# `g`           - generate source code debug info
# `std=`        - sets the language standard, in this case c99
# `_GNU_SOURCE` - is a macro that tells the compiler to use rsome gnu functions
# `pthred`      - adds support for multithreading with the pthreads lib (for preprocessor
#                 and linker)
# `O3`          - the level of optimization
CFLAGS += -g -std=c99 -D_GNU_SOURCE -pthread -O3

# designates which rules aren't actually targets
.PHONY: all test clean clean_obj clean_ll

all: $(OBJ) ll

obj: $(OBJ)

# combiles the object files necessary for linking
%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

# my linked list library
ll: %: %.c
	$(CC) $(CFLAGS) -DLL -o $@ $^

test: ll
	./ll

# cleans everything up when done
clean: clean_obj clean_ll
# *.dSYM directories made by clang on darwin
	rm -rf *.dSYM
# removes the object files. useful at the end of all
clean_obj:
	rm -f $(OBJ)
clean_ll:
	rm -f ll
