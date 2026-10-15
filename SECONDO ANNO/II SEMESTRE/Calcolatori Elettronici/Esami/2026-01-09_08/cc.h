#include <iostream>
using namespace std;
struct st1 { int vi[4]; };
struct st2 { char vd[4]; };
class cl {
	char v1[4]; int v3[4]; long v2[4]; 
public:
	cl(st1 ss);
	cl(st1& s1, int ar2[]);
	cl elab1(char ar1[], st2 s2);
	void stampa() {
		for (int i = 0; i < 4; i++) cout << (int)v1[i] << ' '; cout << endl;
		for (int i = 0; i < 4; i++) cout << (int)v2[i] << ' '; cout << endl;
		for (int i = 0; i < 4; i++) cout << (int)v3[i] << ' '; cout << endl << endl;
	}
};
