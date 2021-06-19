#include "cc.h"
cl::cl() { }
cl::cl(char v[])
{	
	a = v[0]++;
	b = v[1];
	for (int i = 0; i < 4; i++) {
		s.vv1[i] = v[i] + a;
		s.vv2[i] = v[i] + b;
	}
}
void cl::elab1(st& ss, int d)
{	
	for (int i = 0; i < 4; i++) {
		if (d >= ss.vv2[i])
			s.vv1[i] += ss.vv1[i]; 
	  	s.vv2[i] = a + d - i;
	}
}
