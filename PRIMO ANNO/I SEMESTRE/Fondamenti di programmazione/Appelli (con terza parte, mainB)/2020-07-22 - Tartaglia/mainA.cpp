#include "compito.h"

int main() {

    cout<<endl<<"--- PRIMA PARTE ---" << endl;

    Tartaglia t(9);
    cout<<t<<endl<<endl;

    cout<<"Test della funzione fibonacci:"<<endl;
    cout<< t.fibonacci(0)<<endl; // deve stampare 1
    cout<< t.fibonacci(1)<<endl; // deve stampare 1
    cout<< t.fibonacci(2)<<endl; // deve stampare 2
    cout<< t.fibonacci(5)<<endl; // deve stampare 8
    cout<< t.fibonacci(8)<<endl; // deve stampare 34
    cout << endl;   

}