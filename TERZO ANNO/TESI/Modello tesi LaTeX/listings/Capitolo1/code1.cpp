#include <iostream>
#include <cmath>
using namespace std;

// Codice fittizio 1 2 3 check

void ciaoMarco(char* matr, int h, int w){
	for(int i=0; i<h; i++){
		for (int j=0; j<w; j++)
			cout << *( matr + i*w +j) << ' ';
		cout << endl;
	}
}

bool isThisRight (int x, int y){
	double eq= pow(0.1 * x - 1 .5 ,2) + pow(0.1 * y - 1.2 ,2);
	if(eq<1) return true;
	else return false;
}

bool isThisLeft (int x, int y){
	double eq = pow(0.1 * x - 3.5 ,2) + pow(0.1 * y - 1.2 ,2);
    if(eq < 1) return true;
    else return false;
}

bool AAAA (int x, int y){
	double eq= pow( 0.1*x-2.5 ,2) + pow( 0.1*y-5.8 ,2);
    if( eq<1 ) return true;
    else return false;
}

bool nomeSerio(int x, int y){
	if (x>15 && x<35 && y<60 && y>12) return true;
	else return false;
}
