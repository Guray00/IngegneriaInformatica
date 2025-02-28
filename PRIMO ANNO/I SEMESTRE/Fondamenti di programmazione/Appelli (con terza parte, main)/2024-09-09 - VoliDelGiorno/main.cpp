#include "compito.h"

int main() {
    cout << "--- PRIMA PARTE ---" << endl;
    cout << "Test costruttore e aggiungi" << endl;
    VoliDelGiorno vg;
    vg.aggiungi("11.35", "pisa galileo galilei");
    vg.aggiungi("07.30", "milano malpensa");
    vg.aggiungi("08.05", "roma ciampino");
    cout << vg << endl;

    cout << "Test annulla" << endl;
    vg.annulla("07.30");
    vg.annulla("08.05");
    cout << vg << endl;

    cout << "Test costruttore di copia" << endl;
    vg.aggiungi("09.45", "torino caselle");
    VoliDelGiorno vg2 = vg;
    cout << vg2 << endl;

    cout << "--- SECONDA PARTE ---" << endl;
    cout << "Test eventuale distruttore" << endl;
    {
        VoliDelGiorno vg3;
        vg3.aggiungi("01.25", "pisa galileo galilei");
        vg3.aggiungi("06.30", "trapani birgi");
    }
    cout << "Distruttore chiamato" << endl << endl;

    cout << "Test nonAnnullati" << endl;
    cout << vg.nonAnnullati() << endl;

    cout << "Test operatore di complemento" << endl;
    cout << ~vg << endl;

    cout << "Test operatore di somma" << endl;
    VoliDelGiorno vg3;
    vg3.aggiungi("10.20", "firenze peretola");
    vg3.aggiungi("13.10", "catania fontanarossa");
    cout << vg + vg3 << endl;

    cout << "--- TERZA PARTE ---" << endl;
    cout << "Test aggiungi con input non validi" << endl;
    vg.aggiungi("08.30", "bologna guglielmo marconi"); //non aggiunge: nome troppo lungo
    vg.aggiungi("09.30", "b0l0gna marc0n1"); //non aggiunge: caratteri non ammessi
    vg.aggiungi("10.30", ""); //non aggiunge: stringa vuota
    vg.aggiungi("1.30", "bergamo orio al seri"); //non aggiunge: orario scorretto
    vg.aggiungi("01:30", "bergamo orio al seri"); //non aggiunge: orario scorretto
    vg.aggiungi("41.30", "bergamo orio al seri"); //non aggiunge: orario scorretto
    vg.aggiungi("07.30", "palermo punta raisi"); //non aggiunge: orario giÃ  presente
    cout << vg << endl;

    cout << "Test annulla con input non validi" << endl;
    vg.annulla("07.45"); //non annulla: orario non esistente
    vg.annulla("1.25"); //non annulla: orario scorretto
    vg.annulla("11.35"); //non annulla: il volo a questo orario Ã¨ giÃ  annullato
    cout << vg << endl;

    cout << "Test operatore di somma" << endl;
    vg3.aggiungi("09.45", "venezia marco polo");
    //quando stampo la somma, il volo per venezia non deve essere
    //stampato in quanto esiste giÃ  un volo in vg allo stesso orario (torino)
    cout << vg + vg3 << endl;

    return 0;
}