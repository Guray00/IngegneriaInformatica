#include "compito.h"
#include <cstring>

// Metodi della classe Evento

Evento::Evento(const char* t, const char* d, int dd, int mm, int yy){
    strcpy(titolo, t);
    strcpy(descrizione, d);
    giorno = dd;
    mese = mm;
    anno = yy;
}


ostream& operator<<(ostream& os, const Evento& e){
    os << "Data: " << e.giorno << "/" << e.mese << "/" << e.anno << endl;
    os << "Titolo: " << e.titolo << endl;
    os << "Descrizione: " << e.descrizione << endl;
    return os;
}


bool Evento::controllaPrimaDi(const Evento& e) const {
    if (anno != e.anno) return anno < e.anno;
    if (mese != e.mese) return mese < e.mese;
    return giorno < e.giorno;
}


bool Evento::controllaDataEsatta(int dd, int mm, int yy) const {
    return (giorno == dd && mese == mm && anno == yy);
}


bool Evento::controllaParolachiave(const char* keyword) const {
    return (strstr(titolo, keyword) != nullptr || strstr(descrizione, keyword) != nullptr);
}


// Metodi della classe Calendario

const int Calendario::giorniMese[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};


Calendario::Calendario(const char* titolo){
	testa = nullptr;
    // Controlla la stringa titolo
    if(!controllaStringaValida(titolo)) {
        // Usa titolo di default per membro titoloCalendario
        const char titoloDefault[] = "Senza nome";
        this->titoloCalendario = new char[strlen(titoloDefault) + 1];
        strcpy(this->titoloCalendario, titoloDefault);
    } else {
        // Usa titolo passato come parametro, prima alloca abbastanza memoria per la stringa
        this->titoloCalendario = new char[strlen(titolo) + 1];
        strcpy(this->titoloCalendario, titolo);
    }
}


bool Calendario::controllaDataValida(int gg, int mm, int yyyy)
{
    if (gg < 1 || mm < 1 || yyyy < 1)
        return false; // Data non valida    
	
    if (mm > 12 || gg > 30)
        return false; // Data non valida
    
    // Controlla se il mese ha meno dei suoi giorni massimi
    if (gg > Calendario::giorniMese[mm - 1])
        return false; // Data non valida    

    return true; // Data valida
}


bool Calendario::controllaStringaValida(const char* str){
    // Controlla se le stringhe non sono nullptr
    if (str == nullptr)
        return false;    

    // Controlla se stringhe sono di lunghezza 0
    if (strlen(str) == 0)
        return false;

    // Controlla se stringhe hanno solo spazi, usando un for
    bool soloSpazi = true;
    for (int i = 0; str[i] != '\0'; i++)
        if (str[i] != ' ')
            soloSpazi = false;

    return !soloSpazi; // Stringhe valide
}


bool Calendario::aggiungiEvento(const char* titolo, const char* descrizione, int giorno, int mese, int anno){
    // Controlla prima giorno mese e anno
    if (!controllaDataValida(giorno, mese, anno))
        return false;
   
    // Controlla se titolo e descrizione sono stringhe valide
    if (!controllaStringaValida(titolo) || !controllaStringaValida(descrizione))
        return false;

    if (strlen(titolo) > 50 || strlen(descrizione) > 100) 
		return false;

    Evento nuovoEvento(titolo, descrizione, giorno, mese, anno);
    elem* nuovoElem = new elem;
    nuovoElem->evento = nuovoEvento;
    nuovoElem->succ = nullptr;


    if (testa == nullptr || nuovoEvento.controllaPrimaDi(testa->evento)){
        if(testa != nullptr && testa->evento.controllaDataEsatta(giorno,mese,anno)){
			delete nuovoElem; 
			return false;
		}
        nuovoElem->succ = testa;
        testa = nuovoElem;
    }else{
        elem* current = testa;

        while (current->succ != nullptr && !nuovoEvento.controllaPrimaDi(current->succ->evento))
            current = current->succ;

        if(current->evento.controllaDataEsatta(giorno,mese,anno)){
            delete nuovoElem; 
			return false;
        }

        nuovoElem->succ = current->succ;
        current->succ = nuovoElem;
    }
    return true;
}


bool Calendario::rimuoviEvento(int giorno, int mese, int anno){
    if(testa == nullptr)
        return false;

    if(testa->evento.controllaDataEsatta(giorno, mese, anno)){
        elem* temp = testa;
        testa = testa->succ;
        delete temp;
        return true;
    }

    elem* current = testa;
    while(current->succ != nullptr && !current->succ->evento.controllaDataEsatta(giorno, mese, anno))
        current = current->succ;
    
    if(current->succ != nullptr){
        elem* temp = current->succ;
        current->succ = temp->succ;
        delete temp;
        return true;
    }else
        return false;    
}


// Funzione di utilitÃ¡ per ottenere l'ultimo evento contenuto nel calendario
// Il calendario Ã© costruito con gli eventi giÃ¡ in ordine
// L'evento da ritornare Ã© l'ultimo della lista
elem* Calendario::ottieniUltimoEvento() const {
    if (testa == nullptr)
        return nullptr;
   
    // Scorri fino a ottenere l'ultimo evento
    elem* current = testa;
    while (current->succ != nullptr)
        current = current->succ;
	
    return current;
}

// Stampa il calendario su output stream
ostream& operator<<(ostream& os, const Calendario& calendar){
    elem* current = calendar.testa;
	const char cornice[] = "==============================";
    os << cornice << endl;
    os << "Calendario: " << calendar.titoloCalendario << endl;

    if(current == nullptr){
        os << "Data ultimo evento: (vuota)" << endl;
        os << cornice << endl;
        return os;
    }

    // Stampa la data piÃº lontana nel calendario
    elem* last = calendar.ottieniUltimoEvento();
    os << "Data ultimo evento: " << last->evento.giorno << "/" << last->evento.mese << "/" << last->evento.anno  << endl << "%%%" << endl;


    // Stampa ogni evento nel calendario
    while(current != nullptr){
        os << current->evento;
        if(current->succ != nullptr)
            os << "+++" << endl;
        current = current->succ;
    }

    os << cornice << endl;

    return os;
}



// --- SECONDA PARTE ---

// Distruttore di Calendario
Calendario::~Calendario() {
    delete [] titoloCalendario;
    elem* current = testa;
    while (current != nullptr){
        elem* succ = current->succ;
        delete current;
        current = succ;
    }
}

// Costruttore di copia per Calendario
Calendario::Calendario(const Calendario& c){
	testa = nullptr;
    elem* current = c.testa;
    elem* last = nullptr;
    titoloCalendario = new char[strlen(c.titoloCalendario)+1];
    strcpy(titoloCalendario, c.titoloCalendario);
    while(current != nullptr){
        elem* nuovoElem = new elem;
        nuovoElem->evento = current->evento;
        nuovoElem->succ = nullptr;

        if (last == nullptr)
            testa = nuovoElem;
        else
            last->succ = nuovoElem;
        last = nuovoElem;
        current = current->succ;
    }
}


// Rimuove gli eventi successivi ad una data, ritorna il numero di eventi rimossi
int Calendario::rimuoviEventiSuccessiviA(int giorno, int mese, int anno){
    if(testa == nullptr)
        return 0;    
    int count = 0;

    Evento dataLimite("", "", giorno, mese, anno);

    while (testa != nullptr && testa->evento.controllaPrimaDi(dataLimite) == false){
        elem* temp = testa;
        testa = testa->succ;
        delete temp;
        count++;
    }

    if (testa == nullptr)
        return count;    

    elem* current = testa;
    while(current->succ != nullptr){
        if(current->succ->evento.controllaPrimaDi(dataLimite) == false){
            elem* temp = current->succ;
            current->succ = temp->succ;
            delete temp;
            count++;
        }else
            current = current->succ;        
    }
    return count;
}

// Cerca gli eventi che contengono una parola chiave specifica e restituisce un nuovo calendario con i risultati
// Il nuovo calendario ha come nome la keyword passata
Calendario Calendario::cercaEventi(const char* keyword) const {
    // Valida la stringa keyword
    if(!controllaStringaValida(keyword)){
        Calendario vuoto("");
        return vuoto;
    }

    Calendario risultato(keyword);

    if (testa == nullptr)
        return risultato;

    elem* current = testa;


    while(current != nullptr){
        if (current->evento.controllaParolachiave(keyword))
            risultato.aggiungiEvento(current->evento.titolo, current->evento.descrizione,
                            current->evento.giorno, current->evento.mese, current->evento.anno);        
        current = current->succ;
    }

    return risultato;
}