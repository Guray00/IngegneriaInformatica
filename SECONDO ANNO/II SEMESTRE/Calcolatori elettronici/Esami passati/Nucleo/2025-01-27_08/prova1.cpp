// prova1.cpp
#include "cc.h"
int main()
{
	st1 s1 = { 'e', 'b', 'f', 'd' };
	st1 s2 = { 'x', 'y', 'z', 'w' };
	st2 sa = { 2, 10, 4, 30 };
	st2 sb = { 10, 2, 30, 4 };
	cl cla(s2.vc, sa);
	cla.elab1(s1, sb);
	cla.stampa();
}

cl::cl(char *c, st2 s2)
{
	for (int i = 0; i < 4; i++) {
		s.vc[i] = c[i];
		v[i] = s2.vd[i] + s.vc[i];
	}
}
