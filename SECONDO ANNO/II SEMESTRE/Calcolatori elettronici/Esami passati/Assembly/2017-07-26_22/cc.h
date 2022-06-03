#include <iostream>
using namespace std;
struct st {
	long vv2[4];
	char vv1[4];
};
class cl {
	st s;
	char a, b;
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
