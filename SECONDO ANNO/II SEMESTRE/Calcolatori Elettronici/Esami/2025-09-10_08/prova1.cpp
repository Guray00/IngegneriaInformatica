// prova1.cpp
#include "cc.h"
int main()
{
	st1 s1 = { 'e', 'a', 'f', 'd' };
	st2 sa = { 1, 20, 3, 40 };
	st2 sb = { 10, 2, 30, 4 };
	cl cla('a', sa);
	cla.stampa();
	cla.elab1(s1, sb);
	cla.stampa();
}
    
void cl::elab1(st1 s1, st2 s2) {
	cl cla('a', s2);
	for (int i = 0; i < 4; i++) {
		if (c2.vc[i] <= s1.vc[i]) {
			c1.vc[i] = i + cla.c2.vc[i];
			v[i] = i - cla.v[i];
		}
	}
}
