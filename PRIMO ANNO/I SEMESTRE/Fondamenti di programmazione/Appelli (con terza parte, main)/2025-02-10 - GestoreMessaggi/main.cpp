#include <iostream>
#include "compito.h"
using namespace std;

int main(){

    cout<<endl<<"--- PRIMA PARTE ---" <<endl<<endl;

    cout<<"Test del costruttore:" << endl;
    GestoreMessaggi g(4);
    cout << g << endl << endl;

    cout<<"Test della registra_utente:" << endl;
    g.registra_utente("Utente1");
    cout << g << endl << endl;

    g.registra_utente("Utente2");
    cout << g << endl << endl;

    cout<<"Test della invia_messaggio:" << endl;
    g.invia_messaggio("Utente1", "Utente2", "Mess 1 di u1 per u2");
    cout << g << endl << endl;

    g.invia_messaggio("Utente2", "Utente1", "Mess 1 di u2 per u1");
    cout << g << endl << endl;

    g.invia_messaggio("Utente1", "Utente2", "Mess 2 di u1 per u2");
    cout << g << endl << endl;


    cout<<endl<<"--- SECONDA PARTE ---" <<endl<<endl;

    char mittente[50];

    cout<<"Test della leggi_messaggio:" << endl;
    cout << g.leggi_messaggio("Utente2", mittente) << endl;
    cout << mittente << endl << endl << endl;

    cout<<"Test del costruttore di copia:" << endl;
    GestoreMessaggi g1(g);
    cout << g1 << endl << endl;

    cout<<"Test dell'operatore di somma:" << endl;
    GestoreMessaggi g2 = 3 + g;
    cout << g2 << endl << endl;
	
	
	
		
    cout<<endl<<"--- TERZA PARTE ---" <<endl<<endl;

    cout<<"Test del costruttore con valore negativo:" << endl;
    GestoreMessaggi g3(-100);
    cout << g3 << endl << endl;

    cout<<"Test del costruttore con valore tra 0 e 1:" << endl;
    GestoreMessaggi g4(0);
    cout << g4 << endl << endl;

    GestoreMessaggi g5(1);
    cout << g5 << endl << endl;

    cout<<"Test della registra_utente:" << endl;
    g4.registra_utente("Utente1");
    g4.registra_utente("Utente2");
    cout << g4 << endl << endl;

    cout<<"Test della registra_utente con gestore pieno:" << endl;
    GestoreMessaggi g6(2);
    g6.registra_utente("Utente1");
    cout << g6.registra_utente("Utente2") << " ";
    cout << g6.registra_utente("Utente3") << endl << endl;
    g6.registra_utente("Utente4");
    cout << g6 << endl << endl;

    cout<<"Test della registra_utente spazi iniziali e finali:" << endl;
    GestoreMessaggi g7(8);
    g7.registra_utente("   Utente1");
    g7.registra_utente("Utente2   ");
    g7.registra_utente("   Utente3     ");
    cout << g7.registra_utente("   Ut en  te4   ") << " ";
    cout << g7.registra_utente("Utente5") << " ";
    cout << g7.registra_utente("") << " ";
    cout << g7.registra_utente(" ") << " ";
    cout << g7.registra_utente("      ") << " " << endl << endl;
    cout << g7 << endl << endl;

    cout<<"Test della registra_utente con duplicati:" << endl;
    cout << g7.registra_utente("Utente1") << " ";
    cout << g7.registra_utente("Utente2") << " ";
    cout << g7.registra_utente("Utente3") << " ";
    cout << g7.registra_utente("Ut en  te4") << " ";
    cout << g7.registra_utente("Utente5") << " ";
    cout << g7.registra_utente("Utente4") << " " << endl << endl;
    cout << g7 << endl << endl;

    cout<<"Test della registra_utente con lunghezze eccessive:" << endl;
    GestoreMessaggi g8(4);
    cout << g8.registra_utente("Utente da non aggiungere perche' contiene troppi caratteri") << " ";
    cout << g8.registra_utente("                    Utente da aggiungere                ") << " ";
    cout << g8.registra_utente("                    Utente da non aggiungere                ") << " ";
    cout << g8.registra_utente("                    Non               aggiungere                ") << " " << endl << endl;
    cout << g8 << endl << endl;

    cout<<"Test vari della invia messaggio:" << endl;
    GestoreMessaggi g9(3);
    g9.invia_messaggio("Utente1", "Utente4", "Gestore vuoto");
    cout << g9 << endl << endl;
    g9.registra_utente("Utente1");
    g9.invia_messaggio("Utente1", "Utente4", "Solo un utente");
    cout << g9 << endl << endl;
    g9.registra_utente("Utente2");
    g9.invia_messaggio("Utente1", "Utente4", "Mitt assente");
    cout << g9 << endl << endl;
    g9.invia_messaggio("Utente4", "Utente2", "Dest assente");
    cout << g9 << endl << endl;
    g9.registra_utente("Utente3");
    
    char str[7] = "Mess 0";
    g9.invia_messaggio("Utente2", "Utente3", str);
    
    for(int i = 1; i < 5; ++i){
        str[5] += 1;
        g9.invia_messaggio("Utente2", "Utente1", str);
    }
    g9.invia_messaggio("Utente2", "Utente1", "Casella piena");
    cout << g9 << endl << endl;

    const char* messaggio = nullptr;

    cout<<"Test della leggi messaggio con utente assente:" << endl;
    messaggio = g9.leggi_messaggio("Utente10", mittente);
    if(messaggio != nullptr)
        cout << messaggio << " " << mittente << endl << endl;

    cout<< endl << "Test della leggi messaggio con casella vuota:" << endl;
    messaggio = g9.leggi_messaggio("Utente1", mittente);
    if(messaggio != nullptr)
        cout << messaggio << " " << mittente << endl << endl;

    cout<< endl << "Altri Test della leggi messaggio:" << endl;
    for(int i = 0; i<3; ++i){
        messaggio = g9.leggi_messaggio("Utente2", mittente);
        if(messaggio != nullptr)
            cout << messaggio << " " << mittente << endl << endl;
    }

    cout<<"Test vari della invia messaggio dopo svuotamento parziale della casella:" << endl;
    for(int i = 5; i < 10; ++i){
        str[5] += 1;
        g9.invia_messaggio("Utente2", "Utente3", str);
    }
    cout << g9 << endl << endl;

    cout<<"Test del costruttore di copia:"<<endl;
    GestoreMessaggi g10(g9);
    cout << g10 << endl << endl;
    for(int i = 0; i<5; ++i){
        messaggio = g10.leggi_messaggio("Utente2", mittente);
        if(messaggio != nullptr)
            cout << messaggio << " " << mittente << endl << endl;
    }

    cout << g10 << endl << endl;
    cout << g9 << endl << endl;

    cout<<"Test operatore di somma:"<<endl;
	GestoreMessaggi g00 = -3 + g9;
    GestoreMessaggi g11 = 6 + g00;
    for(int i = 0; i<5; ++i)
        g11.leggi_messaggio("Utente2", mittente);

    cout << g11 << endl << endl;
    cout << g9 << endl << endl;

    GestoreMessaggi g12 = 4 + g9;
    for(int i = 0; i<5; ++i)
        g11.leggi_messaggio("Utente2", mittente);

    g12.registra_utente("UtenteX");
    g12.invia_messaggio("UtenteX", "Utente1", "Chi sei?");
    g12.invia_messaggio("UtenteX", "Utente3", "Chi sei?");
    g12.invia_messaggio("UtenteX", "Utente2", "Chi sei?");

    cout << g12 << endl << endl;
    cout << g9 << endl << endl;

    for(int i = 0; i<5; ++i){
        messaggio = g12.leggi_messaggio("UtenteX", mittente);
        if(messaggio != nullptr)
            cout << messaggio << " " << mittente << endl << endl;
    }
    
    return 0;
}