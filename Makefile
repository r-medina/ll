SRCDIR = src
OBJDIR = obj
BINDIR = bin
INCDIR = include
DIRS   = $(SRCDIR) $(OBJDIR) $(BINDIR) $(INDDIR)

# name of executable
EXEC = ll

# all the cource code pregenerated as a string and not just the string `*.c`
SRC = $(wildcard $(SRCDIR)/*.c)
FILES = $(notdir $(SRC))
# loses the `.c` suffix
tmp = $(basename $(FILES))
# all the object files we will need
OBJ = $(addprefix $(OBJDIR)/, $(addsuffix .o, $(tmp)))

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
# `-I` - adds directory to the system search path (for include files)
CFLAGS += -I"$(INCDIR)"

# designates which rules aren't actually targets
.PHONY: all o exec test clean clean_obj clean_ll clean_very

all: $(OBJ) $(EXEC)

# for only compiling object voce
o: $(OBJ)

# for only compiling executable binary
exec: $(EXEC)

# combiles the object files necessary for linking
$(OBJDIR)/%.o: $(SRCDIR)/%.c $(OBJDIR)
	@echo building object files...
	$(CC) $(CFLAGS) -o $@ -c $<

# makes sure bin/ is created and the builds the proper binary name
$(EXEC): %: $(BINDIR) $(BINDIR)/%

# had to do this so it wouldn't recompile each time
$(BINDIR)/%: $(SRCDIR)/%.c
	@echo building binary...
	$(CC) $(CFLAGS) -DLL -o $@ $<

$(DIRS):
	@mkdir -p $@

test: $(EXEC)
	@echo running tests...
	@$(BINDIR)/$(EXEC)

# cleans everything up when done
clean: clean_obj clean_ll
# *.dSYM directories made by clang on darwin
	@rm -rf $(BINDIR)/*.dSYM
# removes the object files. useful at the end of all
clean_obj:
	@echo removing object files...
	@rm -rf $(OBJ)
clean_ll:
	@echo removing binary...
	@rm -f $(BINDIR)/$(EXEC)
clean_very:
	@echo removing binary directory...
	@rm -rf $(BINDIR)
	@echo removing object directory...
	@rm -rf $(OBJDIR)
