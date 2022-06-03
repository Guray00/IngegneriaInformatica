#include "cc.h"
cl::cl(char c, st1& s2)
{
	for (int i = 0; i < 8; i++) {
		s.vc[i] = c + i;
	}
	for (int i = 0; i < 4; i++) {
		v[i] = s2.vc[i] - s.vc[i];
	}
}
void cl::elab1(st1 s1, st2& s2)
{	
	cl cla('f', s1);
	for (int i = 0; i < 4; i++) {
		if (s.vc[i] < s1.vc[i])
			s.vc[i] = cla.s.vc[i];
		if (v[i] < cla.v[i])
			v[i] = cla.v[i] + i;
	}
}
