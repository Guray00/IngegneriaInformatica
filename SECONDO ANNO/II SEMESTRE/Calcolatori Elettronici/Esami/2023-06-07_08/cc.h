#include <iostream>
using namespace std;
struct st1 {
	char vc[3];
};
class cl {
	st1 s;
	long v[3]; 
public:
	cl(char c, st1& s2);
	void elab1(st1& s1);
	void stampa()
	{
		for (int i = 0; i < 3 ;i++) cout << s.vc[i] << ' '; cout << endl;
		for (int i = 0; i < 3; i++) cout << v[i] << ' '; cout << endl << endl;
	}
};

