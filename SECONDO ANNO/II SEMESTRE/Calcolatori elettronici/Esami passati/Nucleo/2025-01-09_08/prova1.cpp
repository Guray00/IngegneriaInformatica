// prova1.cpp
#include "cc.h"
int main()
{
	st1 s1 = { 'e', 'a', 'f', 'd' };
	st2 sa = { 1, 20, 3, 40 };
	st2 sb = { 10, 2, 30, 4 };
	cl cla('a', sa);
	cla.elab1(s1, sb);
	cla.stampa();
}
    
cl::cl(char c, st2 s2) {
	for (int i = 0; i < 4; i++) {
		s.vc[i] = c + i;
		v[i] = s2.vd[i] + s.vc[i];
	}
}
