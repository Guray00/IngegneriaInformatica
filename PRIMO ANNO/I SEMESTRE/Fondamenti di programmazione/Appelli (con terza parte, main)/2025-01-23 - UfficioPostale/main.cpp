#include "compito.h"


int main() {


    cout << "--- PRIMA PARTE ---" << endl;

    UfficioPostale up(3);
    up.accodaUtente("Maria Rossi", 1);
    up.accodaUtente("Luigi Bianchi", 1);
    up.accodaUtente("Chiara Biondi", 1);
    up.accodaUtente("Giuseppe Verdi", 2);
    // quest'ultimo non deve accodare l'utente in quanto stringa vuota
    up.accodaUtente("", 3);


    cout << "Test costruttore e funzione accodaUtente" << endl << endl;
    cout << up << endl << endl << endl;


    //servo l'utente Maria Rossi
    up.serviUtente(1);


    cout << "Test funzione serviUtente" << endl << endl;
    cout << up << endl << endl << endl;


    cout << "--- SECONDA PARTE ---" << endl;


    cout << "Test eventuale distruttore" << endl;
    {
        UfficioPostale up1(4);
    }
    cout << "Distruttore chiamato" << endl << endl << endl;


    //accodo 4 utenti prioritari ai vari sportelli
    up.accodaPrioritario("Simona Gialli");
    up.accodaPrioritario("Daniela Neri");
    up.accodaPrioritario("Francesco Grigi");
    up.accodaPrioritario("Maurizio Violi");


    cout << "Test funzione accodaPrioritario" << endl << endl;
    cout << up << endl << endl << endl;


    //faccio passare avanti Biondi e Verdi (che diventa prioritario)
    up.passaAvanti("Chiara Biondi", 1, 1);
    up.passaAvanti("Giuseppe Verdi", 2, 1);


    cout << "Test funzione passaAvanti" << endl << endl;
    cout << up << endl << endl << endl;


    //applico l'operatore di negazione logica su up


    !up;


    cout << "Test operatore di negazione" << endl << endl;
    cout << up << endl << endl << endl;


    cout << "--- TERZA PARTE ---" << endl;


    cout << "Test costruttore" << endl << endl;


    // deve costruire un oggetto UfficioPostale con due sportelli
    UfficioPostale up2;
    cout << up2 << endl << endl << endl;


    // gestisco valori non validi di M
    // ho fatto la scelta di sanificare valori non validi, convertendoli al valore di default che Ã¨ pari a 2
    cout << "Test costruttore con input non valido" << endl << endl;
    UfficioPostale up3(0);
    cout << up3 << endl << endl << endl;


    cout << "Test accodaUtente" << endl << endl;


    up2.accodaUtente("Giovanni Fabbri", 3); // sportello troppo grande: non accoda
    up2.accodaUtente("Contessa Serbelloni Mazzanti Vien Dal Mare", 1); // nome troppo lungo: non accoda
    up2.accodaUtente("Giovanni Fabbri", 1); // accoda
    up2.accodaUtente("Giovanni Fabbri", 1); // nome giÃ  presente allo sportello: non accoda


    cout << up2 << endl << endl << endl;


    cout << "Test serviUtente" << endl << endl;


    up2.serviUtente(3); // sportello grande: non serve l'utente e stampa false


    up2.serviUtente(1); // serve l'utente e svuota la coda


    up2.serviUtente(1); // coda vuota: non serve l'utente e stampa false


    cout << up2 << endl << endl << endl;


    cout << "Test accodaPrioritario" << endl << endl;


    up2.accodaPrioritario(""); // stringa vuota: non accoda
    up2.accodaPrioritario("Contessa Serbelloni Mazzanti Vien Dal Mare"); // nome troppo lungo: non accoda
    up2.accodaPrioritario("Giada Medici"); // accoda
    up2.accodaPrioritario("Umberto Cracchi"); // accoda
    up2.accodaPrioritario("Giada Medici"); // nome giÃ  presente: non accoda


    cout << up2 << endl << endl << endl;


    cout << "Test passaAvanti" << endl << endl;


    // accodo prima alcuni utenti non prioritari per riempire le code
    up2.accodaUtente("Laura Mieli", 1);
    up2.accodaUtente("Corrado Franchi", 1);
    up2.accodaUtente("Teresa Cheli", 2);


    up2.passaAvanti("Mario Borsi", 1, 1); // nome non trovato: fallisce
    up2.passaAvanti("Corrado Franchi", 3, 1); // sportello troppo grande: fallisce
    up2.passaAvanti("Corrado Franchi", -2, 1); // sportello troppo piccolo: fallisce
    up2.passaAvanti("Corrado Franchi", 1, 5); // troppe posizioni in avanti: fallisce
    up2.passaAvanti("Corrado Franchi", 1, -3); // numero negativo di posizioni: fallisce


    cout << up2 << endl << endl << endl;


    cout << "Test operatore di negazione" << endl << endl;


    // due applicazioni in cascata dell'operatore di negazione su up2, lasciano up2 invariato
    !!up2;


    cout << up2 << endl << endl << endl;


    return 0;


}