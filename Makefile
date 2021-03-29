# Targets that are not actually files
.PHONY: clean compile compileDebug debugger memCheck run doc ccr

# No standard rules
.SUFFIXES:

# Compiler (Ex. gcc for C or g++ for C++)
CC = g++

# File extension (c or cpp)
FILE_EXTENTION = cpp

# Libraries that need to be linked
LIBS = -lm

# Compiler flags
FLAGS = -Wall -Werror -Wextra -Wno-unused-parameter

# All source files
SRCS = $(wildcard $(SRC_PATH)*.$(FILE_EXTENTION))

# Location of source files
SRC_PATH = src/

# Path to object files
OBJ_PATH = build/
OBJ_PATH_REGEX = $(shell echo $(OBJ_PATH) | sed 's/\//\\\//g')

# Path to documentation
DOC_PATH = doc/

# Path to program
PROG_PATH = ./

# Tool for documentation
DOC_GENERATOR = doxygen

# Name of executable
PROG = helloworld

# All object files (.o)
OBJS = $(SRCS:$(SRC_PATH)%.$(FILE_EXTENTION)=$(OBJ_PATH)%.o)

# Debugger and arguments
DEBUGGER = gdb
DEBUGGER_ARGS = -tui $(PROG_PATH)$(PROG) --directory=$(SRC_PATH) --quiet

# MemCheck tool and arguments
MEMTOOL = valgrind
MEMTOOL_ARGS = -v --leak-check=full --show-reachable=yes $(PROG_PATH)$(PROG)

# Compile the program
compile: FLAGS += -O2
compile: $(PROG)

# Rule to compile the objects
$(OBJ_PATH)%.o: $(SRC_PATH)%.$(FILE_EXTENTION)
	@echo "Compiling $<"
	@$(CC) $(FLAGS) -c $(SRC_PATH)$*.$(FILE_EXTENTION) -o $@

# Linking the executable
$(PROG): folder .depend $(OBJS)
	@echo "Linking program \"$(PROG_PATH)$(PROG)\""
	@$(CC) $(OBJS) $(LIBS) -o $(PROG_PATH)$(PROG)

# Creates folder for object files
folder:
	@echo "Creating object directory"
	@mkdir -p $(OBJ_PATH)

# Creates project documentation
doc:
	$(DOC_GENERATOR)

# Clean all generated files
clean :
	@echo "Cleaning program"
	@rm -f $(PROG_PATH)$(PROG)
	@echo "Cleaning objects"
	@rm -rf $(OBJ_PATH)
	@echo "Cleaning doc"
	@rm -rf $(DOC_PATH)
	@rm -f doxygen.log
	@echo "Cleaning dependencies"
	@rm -f .depend

# Compiles the program in debugging mode (with -g)
compileDebug: FLAGS += -g
compileDebug: $(PROG)

# Runs the debugger
debugger: compileDebug
	$(DEBUGGER) $(DEBUGGER_ARGS)

# Runs the memory check
memCheck: compileDebug
	$(MEMTOOL) $(MEMTOOL_ARGS)

# Write auto dependencies
.depend: $(SRCS)
	@echo "Reading dependencies"
	@$(CC) $(SRC_PATH)*.$(FILE_EXTENTION) -MM | sed 's/^/$(OBJ_PATH_REGEX)/g' > .depend

# Runs the program
run:
	$(PROG_PATH)$(PROG)

# Cleans, compiles and runs the program
ccr: clean compile run

# Include .depend file
include .depend
