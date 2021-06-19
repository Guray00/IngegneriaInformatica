#include "cc.h"
cl::cl(st1 ss)
{	
	for (int i = 0; i < 4; i++) {
		v1[i] = v2[i] = ss.vi[i]; v3[i] = ss.vi[i] + ss.vi[i];
	}
}
cl::cl(st1 s1, long ar2[])
{
	for (int i=0; i<4; i++) {
		v1[i] = v2[i] = s1.vi[i]; v3[i] = ar2[i];
	}
}
cl cl::elab1(char ar1[], st2 s2)
{
	st1 s1;
	for (int i = 0; i < 4; i++)
		s1.vi[i] = ar1[i];
	cl cla(s1);
	for (int i = 0; i < 4; i++)
		cla.v3[i] = s2.vd[i];
	return cla;
}
