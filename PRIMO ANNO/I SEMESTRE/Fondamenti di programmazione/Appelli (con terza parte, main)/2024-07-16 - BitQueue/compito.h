#include <iostream>
using namespace std;

class BitQueue{
    unsigned short* values; // suppongo short su 16 bit
    int max_bits;
    int first_bit;
    int num_bits;

    // --- FUNZIONI UTILITA' ---
    void set_bit(int, bool);

public:
    // --- PRIMA PARTE ---
    BitQueue(int);
    friend ostream& operator<<(ostream&, const BitQueue&);
    operator int() const;
    bool enqueue(bool);
    bool dequeue(bool&);
    bool operator[](int) const;

    // --- SECONDA PARTE ---
    ~BitQueue();
    BitQueue(const BitQueue&);
    BitQueue operator|(const BitQueue&) const;
    void replace(const bool[], int, const bool[]);
    int max_span(bool bit) const;
};