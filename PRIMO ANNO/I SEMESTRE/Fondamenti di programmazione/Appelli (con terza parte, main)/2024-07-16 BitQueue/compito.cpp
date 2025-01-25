#include "compito.h"

// --- FUNZIONI UTILITA' -------------------------------------------------------

void BitQueue::set_bit(int i, bool bit) {
    if (bit)
        values[(first_bit + i) / 16] |= (1u << ((first_bit + i) % 16));
    else
        values[(first_bit + i) / 16] &= ~(1u << ((first_bit + i) % 16));
}

// --- PRIMA PARTE -------------------------------------------------------------

BitQueue::BitQueue(int _max_bits) {
    if (_max_bits < 0)
        exit(1);
    max_bits = _max_bits;
    values = new unsigned short[_max_bits / 16 + (_max_bits % 16 ? 1 : 0)];
    first_bit = 0;
    num_bits = 0;

    for (int i = 0; i < max_bits / 16; i++)
        values[i] = 0;
}

bool BitQueue::operator[](int i) const{
    if(i < 0 || i >= num_bits)
        return false;
    return values[(first_bit + i) / 16] >> ((first_bit + i) % 16) & 1u;
}

ostream& operator<<(ostream& os, const BitQueue& q) {
    os << q.max_bits;
    os << '[';
    for (int i = 0; i < q.num_bits; i++) {
        if (q[i])
            os << '1';
        else
            os << '0';
        if (i < q.num_bits - 1)
            os << ',';
    }
    os << ']';
    return os;
}

bool BitQueue::enqueue(bool bit) {
    if (num_bits == max_bits)
        return false;
    set_bit(num_bits, bit);
    num_bits++;
    return true;
}

bool BitQueue::dequeue(bool& bit) {
    if (num_bits == 0)
        return false;
    bit = (*this)[0];
    first_bit = (first_bit + 1) % max_bits;
    num_bits--;
    return true;
}

// --- SECONDA PARTE ------------------------------------------------

BitQueue::~BitQueue() {
    delete[] values;
}

BitQueue::BitQueue(const BitQueue &q) {
    max_bits = q.max_bits;
    values = new unsigned short[q.max_bits / 16 + (q.max_bits % 16 ? 1 : 0)];
    first_bit = q.first_bit;
    num_bits = q.num_bits;
    for (int i = 0; i < q.max_bits / 16; i++)
        values[i] = q.values[i];
}

BitQueue BitQueue::operator|(const BitQueue &q) const {
    // faccio in modo che i bit di *this siano maggiori o uguali a quelli di q,
    // se non lo sono scambio di posto gli operandi
    if (q.num_bits > num_bits)
        return q | *this;
    int new_max_bits = (max_bits > q.max_bits) ? max_bits : q.max_bits;
    BitQueue new_q(new_max_bits);
    new_q.num_bits = num_bits;
    for (int i = 0; i < q.num_bits; i++)
        new_q.set_bit(i, (*this)[i] || q[i]);
    return new_q;
}

void BitQueue::replace(const bool seq_find[], int seq_len, const bool seq_rep[]) {
    if (seq_len <= 0)
        return;
    for (int i = 0; i < num_bits - seq_len + 1; i++) {
        bool seq_found = true;
        for (int j = 0; j < seq_len; j++) {
            if ((*this)[i + j] != seq_find[j]) {
                seq_found = false;
                break;
            }
        }
        if (seq_found) {
            for (int j = 0; j < seq_len; j++)
                set_bit(i + j, seq_rep[j]);
            // evito di ritrovare la sequenza dove ho appena sostituito
            i += seq_len - 1;
        }
    }
}

int BitQueue::max_span(bool bit) const {
    int max_len = 0;
    int len = 0;
    for (int i = 0; i < num_bits; i++) {
        if ((*this)[i] == bit)
            len++;
        else {
            if (len > max_len)
                max_len = len;
            len = 0;
        }
    }
    if (len > max_len)
        max_len = len;
    return max_len;
}