#include <iostream>
using namespace std;
struct st {
	char vv1[4];
	long vv2[4];
};
class cl {
	char a, b;
	st s;
public:
	cl();
	cl(char v[]);
	void elab1(st& ss, int d);
	void stampa()
	{	
		cout << (int)a << ' ' << (int)b << endl;
		for (int i = 0; i < 4; i++)
			cout << (int)s.vv1[i] << ' ';
		cout << '\t';
		for (int i = 0; i < 4; i++)
			cout << s.vv2[i] << ' ';
		cout << endl;
		cout << endl;
	}
};
