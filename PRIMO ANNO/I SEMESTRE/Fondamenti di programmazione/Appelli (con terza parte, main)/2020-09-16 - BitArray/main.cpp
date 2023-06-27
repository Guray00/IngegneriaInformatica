#include "compito.h"
int  main(){

    cout<<"--- PRIMA PARTE ---" <<endl;
    cout << "Test del costruttore (deve stampare [T,F,T,T])" <<endl;
    bool input1[] = {true, false, true, true};    
    BitArray a1(input1, 4);
    cout<<a1<<endl<<endl;

    cout << "Altro test del costruttore (deve stampare [F,T,T])" <<endl;
    bool input2[] = {false, true, true};
    BitArray a2(input2, 3);
    cout<<a2<<endl<<endl;    

    cout << "Test dell'operatore di negazione logica (deve stampare 3)" <<endl;
    cout<<!a1<<endl<<endl;

    cout << "Test dell'operatore di or bit a bit (deve stampare [T,T,T,T]) " <<endl;
    cout<<(a1|a2)<<endl<<endl;



    cout<<"--- SECONDA PARTE ---" <<endl;
    cout << "Test della funzione flip (deve stampare [T,T,F,T])" <<endl;
    a1.flip(1,2);
    cout<<a1<<endl<<endl;
   
    cout << "Doppio test della setBit (deve stampare [F,T,T] e [T,T,T])" <<endl;
    a2.setBit(1,3, false);
    cout<<a2<<endl;
    a2.setBit(0,2, true);
    cout<<a2<<endl<<endl;

    cout << "Doppio test della maxSubSeq (deve stampare 1 e poi 4)" <<endl;
    cout<<a1.maxSubSeq()<<endl;
    bool input3[] = {true,false,false,true,false,false,false,false,true};
    BitArray a3(input3, 9);
    cout<<a3.maxSubSeq()<<endl<<endl;



    cout<<"--- TERZA PARTE ---" <<endl;
    bool input4[] = {true,false,false,false,true,true,true,false,false,false,false,false,true};
    BitArray a4(input4, 13);
    cout<<"Deve stampare 5"<<endl;
    cout<<a4.maxSubSeq()<<endl<<endl;
    cout<<"Deve stampare [T,F,F,T,T,T,T,F,T,F,F,F,T]"<<endl;
    cout<< (a3|a4) <<endl;

    
}