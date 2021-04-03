/**
 * @author René Gyetvai
 * @date 03.04.2021
 **/

#include <stdio.h>
#include <string.h>

/** Function for testing equality of integer values. 
 * It casts all input values to type 'long' to compare all sizes of integer numbers.
 * @param given represents the value given from the program
 * @param expected represents the value expected from the user
 **/
static int assertLong(long given, long expected) {
    printf("Assert equal number test: ");

    if (expected == given) {
        return 0;
    } else {
        return 1;
    }
}

/** Function for testing equality of floating-point numbers.
 * It casts all parameters to type 'double' to compare with highest precision possible.
 * @param given represents the value given from the program
 * @param expected represents the value expected from the user
 **/
static int assertDouble(double given, double expected) {
    printf("Assert equal floating-point number test: ");

    double precision = 0.00001;
    if (((given - precision) < expected) && ((given + precision) > expected)) {
        return 0;
    } else {
        return 1;
    }
}

/** Function for testing equality of strings.
 * Utilizes the strcmp() function from string.h library.
 * @param given represents the string (char array) given from the program
 * @param expected represents the string (char array) expected from the user
 **/
static int assertString(char given[], char expected[]) {
    printf("Assert equal strings test: ");

    return strcmp((char*) given, (char*) expected);
}

/** Function for printing out a test result.
 * @param value represents the value to select the correct message.
 **/
static void message(int value) {
    if (value == 0) {
        printf("\033[32m Test passed! \033[m\n");
    } else {
        printf("\033[31m Test failed! \033[m\n");
    }
}
