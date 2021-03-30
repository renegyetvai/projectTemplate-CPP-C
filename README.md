# C/CPP Project Template
This is a template for small to standard sized C or C++ Projects.

## General Advice:
All setting can be customized at the top of the makefile.

## Initial Structure
### The initial configuration builds the following structure:
- build/    : Folder for all *.o files
- doc/      : Folder for all documentation files (created by 'make doc')

### Other structure requirements:
The source files must be located in a folder with the name 'src/'.

### Compiler settings:
The initial compiler is set to 'g++' and uses the flags '-Wall -Werror -Wextra -Wno-unused-parameter'. Initially the math library is linked.

### Documentation generator settings:
Initially as generator for documentation doxygen is used. It is called without arguments.

### Debugger setting:
For debugging gdb ist used and called with the arguments '-tui', '--directory' and  '--quiet'. 

### Memory check settings:
To identify memory issues valgrind is used with the arguments '-v --leak-check=full --show-reachable=yes'.

## Target documentation:
- doc           : Runs the documentation generator. 
- clean         : Removes all generated files and folders.
- compile       : Compiles the program (initially enables optimizations with '-O2' flag).
- compileDebug  : Compiles the program for debugging purposes (initially enables '-g' flag).
- debugger      : Runs the debugger with its arguments and if not done starts compileDebug.
- memCheck      : Runs the memory check tool with its arguments and if not done starts compileDebug.
- run           : Runs the compiled program.
- ccr           : Runs the targets clean, compile and run in this order.

