// prova1.cpp
#include "cc.h"
int main()
{
	st1 s3 = { 'm', 'n', 'c', 'j' };
	st1 sa = { 1, 20, 3, 40 };
	char c = 'h';
	cl cla(&c, sa);
	cla.stampa();
	cla.elab1(s3);
	cla.stampa();
}
    
