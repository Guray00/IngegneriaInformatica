#include "cc.h"
cl::cl(char c, st2 s2)
{
	for (int i = 0; i < 4; i++) {
		s.vd[i] = c;
		v[i] = s2.vd[i] + s.vd[i];
	}
}
void cl::elab1(st1 s1, st2& s2)
{
	cl cla(s1.vc[3], s2);
	for (int i = 0; i < 4; i++) {
		if (s.vd[i] < s1.vc[i])
			s.vd[i] = cla.s.vd[i];
		if (v[i] <= cla.v[i])
			v[i] += cla.v[i];
	}
}
