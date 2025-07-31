// prova1.cpp
#include "cc.h"
cl::cl(char c, st1& s2)
{
	for (int i = 0; i < 4; i++) {
		s.vc[i] = c++;
		v[i] = s2.vc[i] - c;
	}
}

int main()
{
	st1 s3 = { 'p', 'o', 'm', 'n' };
	st1 sa = { 10, 20, 30, 40 };
	cl cla('n', sa);
	cla.elab1(s3);
	cla.stampa();
}
    
