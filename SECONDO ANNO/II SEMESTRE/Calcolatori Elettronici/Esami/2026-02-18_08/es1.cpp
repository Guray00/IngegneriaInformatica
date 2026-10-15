#include "cc.h"
cl cl::elab1(char ar1[], st1 s2)
{
	st1 s1;
	for (int i = 0; i < 4; i++)
		s1.vi[i] = v3[i] + ar1[i];
	cl cla(s1);
	for (int i = 0; i < 4; i++)
		v3[i] = cla.v3[i] + s2.vi[i];
	return cla;
}
