// prova1.cpp
#include "cc.h"
int main()
{
	st1 s1 = { 'e', 'a', 'f', 'd' };
	st2 sa = { 1.0, 20.0, 3.0, 40.0 };
	st2 sb = { 10.0, 2.0, 30.0, 4.0 };
	cl cla('a', sa);
	cla.stampa();
	cla.elab1(s1, sb);
	cla.stampa();
}
    
