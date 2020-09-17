#include "compito.h"

// FUNZIONI DI UTILITA'

// Costruttore di utilita'
BitArray::BitArray(unsigned int val, int len){
    value = val;
    if(len > MAXLENGTH || len <= 0)
        length = MAXLENGTH;
    else
        length = len;
}

// Restituisce una maschera di 32 bit del tipo:
//  00001111111111111111000000000000
// costituita da 1 nel range dal bit di indice start al bit
// di indice end (compresi) e da 0 fuori da tale range.
inline unsigned int BitArray::onesStart2End(int start, int end) {
    return (1<<end+1)-(1<<start);
}


// --- PRIMA PARTE -------------------------------------------------------------

BitArray::BitArray(const bool vetBool[], int len){
    value = 0u;
    if ( len <= 0 || len > MAXLENGTH)
       len = MAXLENGTH;
    length = len;

    for( int i = 0; i < length; i++)
        this->value += ( vetBool[i] << i );

}

ostream& operator<<(ostream& os, const BitArray& array){
    os << '[';
    for (int i = 0; i < array.length - 1; i++)
        ( array.value >> i & 1u ) == true ? os<<"T," : os<<"F,";

    ( array.value>>array.length-1 & 1u ) == true ? os<<"T]" :os<<"F]";

    return os;
}

unsigned int BitArray::operator!() const{

    unsigned int cardinality = 0u;
    for(int i = 0; i < length; i++)
        cardinality += ( ( value >> i ) & 1u);
    return cardinality;
}

BitArray BitArray::operator|(const BitArray &array) const{
    unsigned int newValue = value|array.value;
    int newLength = (length > array.length)?length:array.length;
    BitArray newBitArray(newValue, newLength);
    return newBitArray;
}


// --- SECONDA PARTE ------------------------------------------------
bool BitArray::setBit(int start, int end, bool val){
    if( start >= length || end >= length || start < 0 || start > end )
        return false;

    unsigned int mask = onesStart2End(start, end);
    if( val )
        value |= mask;
    else{
        mask = ~mask;
        value &= mask;
    }
    return true;
}


bool BitArray::flip(int start, int end){
    if( start >= length || end >= length || start < 0 || start > end )
        return false;

    value ^= onesStart2End(start, end);

    return true;
}

unsigned int BitArray::maxSubSeq() const {
    unsigned int maxLen = 0u;
    unsigned int len = 0u;
    for (int i = 0; i < length; i++)
        if (((value >> i) & 1u) == 0u)
            len++;
        else {
            if (len > maxLen)
                maxLen = len;
            len = 0u;
        }
    return maxLen;
}


