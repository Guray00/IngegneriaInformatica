#include "cc.h"
cl::cl(st1 ss)
{	
	for (int i = 0; i < 4; i++) {
		v1[i] = ss.vi[i]; v2[i] = ss.vi[i] * 2;
		v3[i] = 2 * ss.vi[i];
	}
}
cl::cl(st1& s1, int ar2[])
{	
	for (int i = 0; i < 4; i++) {
		v1[i] = s1.vi[i]; v2[i] = s1.vi[i] * 4;
		v3[i] = ar2[i];
	}
}
