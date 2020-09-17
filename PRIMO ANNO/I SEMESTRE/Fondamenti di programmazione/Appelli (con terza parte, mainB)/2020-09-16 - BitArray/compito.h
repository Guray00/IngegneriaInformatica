#include<iostream>
using namespace std;

const int MAXLENGTH = 32; // const unsigned MAXLENGTH = 8*sizeof(unsigned int);

class BitArray{

    unsigned int value;
    int length;

    // Funzioni di utilita'
    BitArray(unsigned int value, int length); // ulteriore costruttore, di utilita'
    static inline unsigned onesStart2End(int start, int end);

public:
    // --- PRIMA PARTE ---
    BitArray(const bool value[], int length);
    friend ostream& operator<<(ostream& os, const BitArray& array);
    unsigned operator!() const; // Return the number of bits equal to 1
    BitArray operator|(const BitArray &) const;

    // --- SECONDA PARTE ---
    bool setBit(int, int, bool);
    bool flip(int, int);
    unsigned int maxSubSeq() const;
};