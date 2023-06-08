// prova1.cpp
#include "cc.h"
cl::cl(char c, st1& s2)
{
	for (int i = 0; i < 3; i++) {
		s.vc[i] = c++;
		v[i] = s2.vc[i] - c;
	}
}

int main()
{
	st1 s3 = { 'm', 'n', 'o' };
	st1 sa = { 1, 20, 30 };
	cl cla('h', sa);
	cla.elab1(s3);
	cla.stampa();
}
    
