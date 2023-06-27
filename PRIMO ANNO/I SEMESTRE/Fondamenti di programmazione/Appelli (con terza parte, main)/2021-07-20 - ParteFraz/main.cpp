#include <iostream>
#include "compito.h"
using namespace std;


int main(){
    cout<<"--- PRIMA PARTE ---"<<endl;

    cout<<endl<<"Test del costruttore di PartFraz (deve stampare '0100000000000000b')"<<endl;
    ParteFraz p(0.25);
    cout<<p<<endl;

    cout<<endl<<"Test del costruttore di PartFraz (deve stampare '1010000000000000b')"<<endl;
    ParteFraz p2(0.625);
    cout<<p2<<endl;

    cout<<endl<<"Test della visBase16() della classe ParteFraz (Deve stampare '0x6000')"<<endl;
    ParteFraz p3(0.375);
    p3.visBase16();

    cout<<endl<<"Test dell'operatore di conversione a double di una ParteFraz (Deve stampare '0.375')"<<endl;
    cout<<double(p3)<<endl;


    cout<<endl<<endl<<"--- SECONDA PARTE ---"<<endl;

    cout<<endl<<"Test del costruttore di VirgolaFissa (deve stampare '(3,0.375)')"<<endl;
    VirgolaFissa v(3u, 0.375);
    cout<<v<<endl;

    cout<<endl<<"Test della funzione raddoppia di VirgolaFissa (deve stampare '(6,0.75)')"<<endl;
    v.raddoppia();
    cout<<v<<endl;

    cout<<endl<<"Altro test della funzione raddoppia di VirgolaFissa (deve stampare '(13,0.5)')"<<endl;
    v.raddoppia();
    cout<<v<<endl;


    cout<<endl<<"---TERZA PARTE ---"<<endl;
    ParteFraz p4(1.52e-005); // deve stampare tutti zeri
    cout<<p4<<endl;

    ParteFraz p5(1.53e-005); // deve stampare tutti zeri ed un uno alla fine (meno significativo)
    cout<<p5<<endl;

    ParteFraz p6(0.3);
    cout<<p6<<endl;          // deve stampare 0100110011001100b, ossia 0(1001) dove (1001) si ripete all'infinito
    p6.visBase16();          // deve stampare 0x4ccc

    VirgolaFissa v2(12u, 0.625);
    v2.raddoppia();
    cout<<endl<<v2<<endl;          // deve stampare il doppio, ossia (25,0.25)

}