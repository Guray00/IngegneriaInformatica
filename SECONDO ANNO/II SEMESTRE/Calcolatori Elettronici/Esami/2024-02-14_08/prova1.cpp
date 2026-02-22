#include "cc.h"
int main()
{
	st1 s1 = { 1,2,3,4 };
	st1 s2 = { 5,6,7,8 };
	char a1[4] = { 11,12,13,14 };
	cl cla2(s1);
	cl cla1 = cla2.elab1(a1, s2);
	cla1.stampa();
	cla2.stampa();
}

cl::cl(st1 ss)
{	
	for (int i = 0; i < 4; i++) {
		v3[i] = ss.vi[i];
	}
}
