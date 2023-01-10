#include <iostream>
using namespace std;


const int LEN = 16;

class Mask16; // dichiarazione incompleta

class Bit16{
    unsigned int stato;
public:
    // prima parte:
    Bit16(unsigned int s):stato(s){};
    friend ostream& operator<<(ostream &os, const Bit16&);
    friend Bit16 operator|(const Bit16&, const Mask16&);
    friend Bit16 operator&(const Bit16&, const Mask16&);
    // seconda parte:
    friend Bit16 operator^(const Bit16&, const Mask16&);
    friend Bit16 operator^(const Mask16&m, const Bit16&b){return b ^ m;};
    Mask16 mascheraConvertitrice(const Bit16&ba)const;
};

class Mask16{
    unsigned int stato;
    bool valore;
public:
    // prima parte:
    Mask16(unsigned int s, bool val = true){stato=s; valore = val;};
    friend ostream& operator<<(ostream &os, const Mask16&);
    friend Bit16 operator|(const Bit16&, const Mask16&);
    friend Bit16 operator&(const Bit16&, const Mask16&);
    // seconda parte:
    friend Bit16 operator^(const Bit16&, const Mask16&);
    int quantiMascherati()const;
    Mask16 ruotaADestra(int)const;

};