// prova1.cpp
#include "cc.h"
int main()
{   st s = { 1,2,3,4,5, 1,2,3 };
    char v[3] = {10,11,12 };
    int d = 2;
    cl cc1(v); cc1.stampa();
    cc1.elab1(d, s); cc1.stampa();
}
    
