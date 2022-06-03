#include <iostream>
using namespace std;
struct st1 { char vc[4]; }; struct st2 { char vd[4]; };
class cl {
	long v[4]; 
	st1 c1; st1 c2;
public:
	cl(char c, st2& s);
	void elab1(st1 s1, st2 s2);
	void stampa()
	{
		for (int i=0; i < 4; i++) cout << v[i] << ' '; cout << "\n";
		for (int i=0; i < 4; i++) cout << c1.vc[i] << ' '; cout << "\n";
		for (int i=0; i < 4; i++) cout << c2.vc[i] << ' '; cout << "\n\n";
	}
};

