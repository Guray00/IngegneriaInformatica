#include "cc.h"
cl::cl(char c, st2& s2) {
	for (int i = 0; i < 4; i++) {
		c1.vc[i] = c2.vc[i] = c;
		v[i] = s2.vd[i] - c2.vc[i];
	}
}
void cl::elab1(st1 s1, st2 s2) {
	cl cla('z', s2);
	for (int i = 0; i < 4; i++) {
		if (c2.vc[i] < s1.vc[i]) {
			c1.vc[i] = cla.c2.vc[i];
			v[i] = cla.v[i];
		}
	}
}
