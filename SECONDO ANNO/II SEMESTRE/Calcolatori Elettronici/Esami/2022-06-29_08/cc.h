#include <iostream>
using namespace std;
struct st {
	char vv1[6];
	long vv2[3];
};
class cl {
	st s;
public:
	cl(char v[]);
	void elab1(int d, st& ss);
	void stampa()
	{	
		for (int i = 0; i < 6; i++)
			cout << (int)s.vv1[i] << ' ';
		cout << '\t';
		for (int i = 0; i < 3; i++)
			cout << s.vv2[i] << ' ';
		cout << "\n\n";
	}
};
