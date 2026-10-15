// prova1.cpp
#include "cc.h"
int main()
{   st1 s1 = { 1,2,3,4 };
    st2 s2 = { 5,6,7,8 };
    char a1[4] = { 11,12,13,14 };
    int a2[4] = {15,16,17,18 };
    cl cla1(s1);
    cl cla2(s1, a2);
    cla1 = cla2.elab1(a1, s2); cla1.stampa();
}
    
cl::cl(st1 ss)
{	
	for (int i = 0; i < 4; i++) {
		v1[i] = ss.vi[i]; v2[i] = ss.vi[i] / 2;
		v3[i] = 2 * ss.vi[i];
	}
}
cl::cl(st1& s1, int ar2[])
{	
	for (int i = 0; i < 4; i++) {
		v1[i] = s1.vi[i]; v2[i] = s1.vi[i] / 4;
		v3[i] = ar2[i];
	}
}
