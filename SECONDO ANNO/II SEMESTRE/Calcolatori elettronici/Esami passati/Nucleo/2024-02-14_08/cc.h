#include <iostream>
using namespace std;
struct st1 { char vi[4]; };
class cl {
	int v3[4]; 
public:
	cl(st1 ss);
	cl elab1(char ar1[], st1 s2);
	void stampa() {
		int i;
		for (i=0;i<4;i++) cout << v3[i] << ' '; cout << endl << endl;
	}
};

