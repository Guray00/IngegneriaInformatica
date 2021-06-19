// prova1.cpp
#include "cc.h"
int main()
{
	st1 s1 = { 'e', 'b', 'f', 'd' };
	st1 s2 = { 'a', 'b', 'c', 'd' };
	st2 sa = { 1, 20, 3, 40 };
	st2 sb = { 10, 2, 30, 4 };
	cl cla(s2.vc, sa);
	cla.stampa();
	cla.elab1(s1, sb);
	cla.stampa();
}
    
