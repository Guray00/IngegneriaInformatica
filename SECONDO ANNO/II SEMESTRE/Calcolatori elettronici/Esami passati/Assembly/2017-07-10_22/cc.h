#include <iostream>
using namespace std;
struct st1 { char vi[4]; }; struct st2 { int vd[4]; };
class cl 
{	char v1[4]; char v2[4]; long v3[4]; 
public:
	cl(st1 ss); cl(st1 s1, long ar2[]);
	cl elab1(char ar1[], st2 s2);
	void stampa()
	{	char i;
		for (i=0;i<4;i++) cout << (int)v1[i] << ' '; cout << endl;
		for (i=0;i<4;i++) cout << (int)v2[i] << ' '; cout << endl;
		for (i=0;i<4;i++) cout << v3[i] << ' '; cout << endl << endl;
	}
};

