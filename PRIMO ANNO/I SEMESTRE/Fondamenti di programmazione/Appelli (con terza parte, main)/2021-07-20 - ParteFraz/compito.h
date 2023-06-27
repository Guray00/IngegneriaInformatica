#include <iostream>
#include <cstdlib>
#include <cmath>
using namespace std;

const int PRECISION = 16;

class VirgolaFissa;

class ParteFraz{
    unsigned short int pFraz;

    bool radd(); // funzione di utilita', che verra' utilizzata dalla classe VirgolaFissa
    friend VirgolaFissa;

public:
    ParteFraz(double);
    friend ostream& operator<<(ostream&,const ParteFraz&);
    void visBase16()const{cout<<"0x"<<hex<<pFraz<<endl;};
    operator double()const{return double(pFraz)/pow(2,PRECISION);};
};

class VirgolaFissa{
    unsigned short int pI;
    ParteFraz pF;
public:
    VirgolaFissa(unsigned short i, double pf): pI(i), pF(pf){}
    VirgolaFissa& raddoppia();
    friend ostream& operator<<(ostream&,const VirgolaFissa&);
};