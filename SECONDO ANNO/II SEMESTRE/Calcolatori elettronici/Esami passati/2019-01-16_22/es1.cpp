#include "cc.h"
cl::cl(const char *c, st2 s2)
{
	for (int i = 0; i < 4; i++) {
		s.vc[i] = c[i];
		v[i] = s2.vd[i] + s.vc[i];
	}
}
void cl::elab1(st1 s1, st2 s2)
{
	cl cla(s1.vc, s2);
	for (int i = 0; i < 4; i++) {
		if (s.vc[i] < s1.vc[i])
			s.vc[i] = cla.s.vc[i];
		if (v[i] <= cla.v[i])
			v[i] += cla.v[i];
	}
}
