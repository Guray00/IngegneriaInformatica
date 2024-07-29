#include "costanti.h"

struct credenziali{
    char user[MAX_CR_SIZE];
    char password[MAX_CR_SIZE];
};

struct stanza{
    char intro[MAX_BUFFER_SIZE];
    char descr[MAX_BUFFER_SIZE];
    char location_names[LOCATIONS][MAX_DESCR_SIZE];
    char locations[LOCATIONS][MAX_DESCR_SIZE];
    char obj_names[OBJECTS][MAX_DESCR_SIZE];
    char objs[OBJECTS][MAX_DESCR_SIZE];
    char questions[OBJECTS][MAX_DESCR_SIZE];
    uint8_t solutions[SOLUTIONS];
};