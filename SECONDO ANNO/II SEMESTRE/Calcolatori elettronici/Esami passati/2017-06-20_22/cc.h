#include <iostream>
using namespace std;
struct st1 {
	char vc[8];
};
struct st2 {
	int vd[4];
};
class cl {
	st1 s;
	long v[4]; 
public:
	cl(char c, st1 s2);
	void elab1(st1& s1, st2 s2);
	void stampa()
	{
		for (int i = 0; i < 8 ;i++) cout << s.vc[i] << ' '; cout << endl;
		for (int i = 0; i < 4; i++) cout << v[i] << ' '; cout << endl << endl;
	}
};

