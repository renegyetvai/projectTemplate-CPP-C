# author Rene Gyetvai & Philipp Munz

# Targets that are not actually files
.PHONY: clean compile compileDebug debugger memCheck run doc ccr compileRelease showDoc

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
SRCS = $(wildcard $(SRC_PATH)/*.$(FILE_EXTENTION)) $(wildcard $(SRC_PATH)/*/*.$(FILE_EXTENTION))

# Location of source files
SRC_PATH = src

# Path to object files
OBJ_PATH = build

# Path to documentation
DOC_PATH = doc

# Tool for documentation
DOC_GENERATOR = doxygen

# File containing the documentation (or start of documentation)
DOC_START_FILE = html/index.html

# Path to program
PROG_PATH = .

# Name of executable
PROG = helloworld

# All object files (.o)
OBJS = $(SRCS:$(SRC_PATH)/%.$(FILE_EXTENTION)=$(OBJ_PATH)/%.o)

# Debugger and arguments
DEBUGGER = gdb
DEBUGGER_ARGS = -tui $(PROG_PATH)/$(PROG) --directory=$(SRC_PATH)/ --quiet

# MemCheck tool and arguments
MEMTOOL = valgrind
MEMTOOL_ARGS = -v --leak-check=full --show-reachable=yes $(PROG_PATH)/$(PROG)

# Compile the program
compile: FLAGS += -O1
compile: $(PROG)

# Compile with full optimizations
compileRelease: FLAGS += -O3 -flto
compileRelease:
	@echo "Compiling for release ..."
	@$(CC) $(FLAGS) $(SRCS) $(LIBS) -o $(PROG_PATH)/$(PROG)
	@echo "done"

# Rule to compile the objects
$(OBJ_PATH)/%.o: $(SRC_PATH)/%.$(FILE_EXTENTION)
	@echo "Compiling $<"
	@mkdir -p $(@D)
	@$(CC) $(FLAGS) -c $(SRC_PATH)/$*.$(FILE_EXTENTION) -o $@

# Linking the executable
$(PROG): .depend $(OBJS)
	@echo "Linking program \"$(PROG_PATH)/$(PROG)\""
	@$(CC) $(OBJS) $(LIBS) -o $(PROG_PATH)/$(PROG)

# Creates project documentation
$(DOC_PATH)/$(DOC_START_FILE): $(OBJS)
	$(DOC_GENERATOR)

# Creates project documentation (alias)
doc: $(DOC_PATH)/$(DOC_START_FILE)

# Clean all generated files
clean :
	@echo "Cleaning program"
	@rm -f $(PROG_PATH)/$(PROG)
	@echo "Cleaning objects"
	@rm -rf $(OBJ_PATH)/
	@echo "Cleaning doc"
	@rm -rf $(DOC_PATH)/
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
	@rm -f .depend
	@for i in $^; do \
		$(CC) -MM -MT $$(echo $$i | sed 's/^$(SRC_PATH)/$(OBJ_PATH)/g' | sed 's/\.$(FILE_EXTENTION)$$/\.o/g') $$i >> .depend; \
	done

# Runs the program
run:
	@$(PROG_PATH)/$(PROG)

# Cleans, compiles and runs the program
ccr: clean compile run

# Display documentation with standard program
showDoc: $(DOC_PATH)/$(DOC_START_FILE)
	xdg-open $(DOC_PATH)/$(DOC_START_FILE)

# Include .depend file
include .depend
