#include "compito.h"

int main() {

    cout << "--- PRIMA PARTE ---" << endl;
    cout << "Test del costruttore" << endl;
    BitQueue q1(16);
    cout << q1 << endl << endl;

    cout << "Test di enqueue" << endl;
    q1.enqueue(true);
    q1.enqueue(false);
    q1.enqueue(true);
    q1.enqueue(true);
    cout << q1 << endl << endl;

    cout << "Test di dequeue" << endl;
    bool bit;
    q1.dequeue(bit);
    cout << bit << ' ' << endl << q1 << endl;
    q1.dequeue(bit);
    cout << bit << ' ';
    q1.dequeue(bit);
    cout << bit << ' ';
    q1.enqueue(true);
    q1.enqueue(true);
    q1.enqueue(false);
    q1.enqueue(true);
    q1.dequeue(bit);
    cout << bit << ' ' << endl << q1 << endl << endl;

    cout << "Test di parentesi quadra" << endl;
    cout << q1[1] << ' ' << q1[2] << endl;

    cout << "--- SECONDA PARTE ---" << endl;
    cout << "Test del costruttore di copia" << endl;
    BitQueue q2(q1);
    cout << q2 << endl << endl;

    cout << "Test dell'or bit-a-bit" << endl;
    q2.enqueue(false);
    q2.enqueue(false);
    q2.dequeue(bit);
    q2.dequeue(bit);
    cout << q2 << endl << (q1 | q2) << endl << endl;

    cout << "Test di max_span" << endl;
    cout << q1.max_span(true) << ' ' << q2.max_span(false) << endl << endl;

    cout << "Test di replace" << endl;
    bool seq_find[] = {true, false};
    bool seq_rep[] = {false, false};
    q1.replace(seq_find, 2, seq_rep);
    cout << q1 << endl << endl;

    cout << "--- TERZA PARTE ---" << endl;
    cout << "Test del distruttore" << endl;
    {
        BitQueue q2_(100);
        q2_.enqueue(true);
        q2_.enqueue(false);
        q2_.enqueue(true);
        q2_.enqueue(true);
    }
    cout << "Il distruttore e' stato invocato" << endl << endl;

    cout << "Test di parentesi quadra fuori range" << endl;
    cout << q1[-2] << ' ' << q1[4] << ' ' << q1[100] << endl << endl;

    cout << "Test del costruttore con capienza grande e non multipla di 16" << endl;
    BitQueue q3(1001);
    cout << q3 << endl << endl;
    q3.enqueue(true);
    q3.enqueue(true);
    q3.enqueue(false);
    q3.enqueue(true);
    q3.enqueue(true);
    q3.enqueue(false);
    for(int i = 0; i < 57; i++)
        q3.enqueue(i%2 == 0);
    for(int i = 0; i < 68; i++)
        q3.enqueue(false);
    cout << q3 << endl << endl;

    cout << "Test di enqueue con wrap-around della coda" << endl;
    q1.enqueue(true);
    q1.enqueue(false);
    q1.enqueue(true);
    q1.enqueue(false);
    q1.enqueue(true);
    q1.enqueue(false);
    q1.enqueue(false);
    q1.enqueue(true);
    q1.enqueue(true);
    q1.enqueue(false);
    q1.enqueue(true);
    q1.enqueue(true);
    cout << q1 << endl << endl;

    cout << "Test di enqueue con coda piena" << endl;
    q1.enqueue(false);
    q1.enqueue(false);
    q1.enqueue(true);
    cout << q1 << endl << endl;

    cout << "Test dell'or bit-a-bit con lunghezze e capacita' diverse" << endl;
    cout << (q1 | q3) << endl << (q3 | q1) << endl << endl;

    cout << "Test di dequeue con coda vuota" << endl;
    for(int i = 0; i < 21; i++)
        q1.dequeue(bit);
    cout << q1 << endl << endl;

    cout << "Test intensivo di max_span" << endl;
    cout << q3.max_span(true) << ' ' << q3.max_span(false) << endl << endl;

    cout << "Test intensivo di replace" << endl;
    cout << q3 << endl;
    // evitare rimpiazzo ricorsivo (e sequenze costanti):
    const bool seq_find2[] = {true, true, false, true};
    const bool seq_rep2[] = {false, true, true, false};
    q3.replace(seq_find2, 4, seq_rep2);
    cout << q3 << endl << endl;
    // rimpiazzo multiplo:
    bool seq_find3[] = {true, false, true};
    bool seq_rep3[] = {false, true, false};
    q3.replace(seq_find3, 3, seq_rep3);
    cout << q3 << endl << endl;

    return 0;
}