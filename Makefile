# Targets that are not actually files
.PHONY: clean compile compileDebug debugger memCheck run doc

# No standard rules
.SUFFIXES:

# Compiler (Ex. gcc for C or g++ for C++)
CC = g++

# File extension (c or cpp)
FILE_EXTENTION = cpp

# Libraries that need to be linked
LIBS = -lm

# Compiler flags
FLAGS = -Wall -Werror -Wextra -Wno-unused-parameter -O2

# All source files
SRCS = $(wildcard *.$(FILE_EXTENTION))

# Location of source files
SRC_PATH = src/

# Path to object files
OBJ_PATH = build/

# Path to documentation
DOC_PATH = doc/

# Path to program
PROG_PATH = ./

# Tool for documentation
DOC_GENERATOR = doxygen

# Name of executable
PROG = helloworld

# All object files (.o)
OBJS = $(SRCS:%.$(FILE_EXTENTION)=%.o)

# Debugger and arguments
DEBUGGER = gdb
DEBUGGER_ARGS = -tui $(PROG) --directory=$(SRC_PATH) --quiet

# Rule to compile the objects
%.o: %.$(FILE_EXTENTION)
	$(CC) $(FLAGS) -c $*.$(FILE_EXTENTION) -o $@

# Linking the executable
$(PROG): $(OBJS)
	$(CC) $(OBJS) $(LIBS) -o $(PROG)

# Creates folder for object files
folder:
	mkdir -p $(OBJ_PATH)

# Creates project documentation
doc:
	$(DOC_GENERATOR)

# Clean all generated files
clean:
	rm -f $(OBJS) $(PROG)

# Compile the program
compile: $(PROG)

# Compiles the program in debugging mode (with -g)
compileDebug: FLAGS += -g
compileDebug: $(PROG)

# Runs the debugger
debugger: compileDebug
	$(DEBUGGER) $(DEBUGGER_ARGS)

# Runs the memory check
memCheck: compileDebug
	valgrind -v --leak-check=full --show-reachable=yes $(PROG)

# Runs the program
run:
	./$(PROG)

