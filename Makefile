
.PHONY: clean compile compileDebug debugger memCheck run
.SUFFIXES:

CC = g++

FILE_EXTENTION = cpp

LIBS = -lm

FLAGS = -O2

SRCS = $(wildcard *.$(FILE_EXTENTION))

SRC_PATH = ./

PROG = helloworld

# Alle Objektdateien (.o)
OBJS = $(SRCS:%.$(FILE_EXTENTION)=%.o)

DEBUGGER = gdb
DEBUGGER_ARGS = -tui $(PROG) --directory=$(SRC_PATH) --quiet

%.o: %.cpp
	$(CC) $(FLAGS) -c $*.$(FILE_EXTENTION) -o $@

$(PROG): $(OBJS)
	$(CC) $(OBJS) $(LIBS) -o $(PROG)

clean:
	rm -f $(OBJS) $(PROG)

compile: $(PROG)

# Normaler Compile Aufruf, nur dass noch das -g Flag benutzt wird
compileDebug: FLAGS += -g
compileDebug: $(PROG)

debugger: compileDebug
	$(DEBUGGER) $(DEBUGGER_ARGS)

memCheck: compileDebug
	valgrind -v --leak-check=full --show-reachable=yes $(PROG)

run:
	./$(PROG)

