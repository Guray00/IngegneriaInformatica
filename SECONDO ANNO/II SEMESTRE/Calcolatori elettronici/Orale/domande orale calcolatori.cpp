// Credits: Lorenzo Monaci

#include <iostream>
#include <time.h>
#include <conio.h>

// #define log_dbg printf("%c | %d\n", c, c);

int main(){
    char c;
    unsigned short i, count = 1, j;
    const unsigned short NUM_QUEST = 89, NUM_ORALE = 10;
    srand(time(NULL));
    
    const char* questions[NUM_QUEST] = {
        "A che serve la Cache e come funziona?",
        "Principi di funzionamento della cahche",
        "I principi di localita' valgono sempre?",
        "Quando sono rispettati i principi di localita'?",
        "Cache a indirizzamento diretto",
        "Come e' fatta una cacheline?",
        "Eccezioni: cosa sono e a che sevono",
        "Che fa la cpu quando rileva un'eccezione?",
        "Come fa la cpu a capire dove saltare?",
        "Breakpoint",
        "Funzionamento delle interruzioni e scrittura delle routine",
        "Come mai si usa int e non call per le interruzioni?",
        "Come e'fatto un gate della IDT?",
        "Cosa sono le in terruzioni esterne?",
        "Da dove viene preso il valore del nuovo rsp\nse si cambia pila mentre si attraversa un gate? (GDT, TSS, tr)",
        "DMA: schema e che problema risolve",
        "DMA con cache WT HW e SW",
        "DMA con cache WB e trasferimenti di chacheline intere HW e SW",
        "DMA con cache WB e trasferimenti generici HW e SW",
        "La funzione trasforma",
        "DMA: controlli sugli indirizzi dei buffer",
        "A che serve la Paginazione?",
        "Cos' e' e com' e' implementata la finestra sulla memoria fisica?",
        "Come e' fatto l'albero di traduzione?",
        "Descrittori di tabelle",
        "Come si comporta con il bit D dell'albero di traduzione?",
        "Quando va invalidato?",
        "Ciclo nelle tabelle di liv 4 e 3",
        "Implementazione cambio contesto, cosa fa salva_stato?",
        "Creazione dei processi",
        "Stati di esecuzione dei processi.",
        "A che punto del codice un processo si puo' dire effettivamente in esecuzione?",
        "Come funziona l'i/o nel sistema multiprogrammato?",
        "Quali sono gli accorgimenti da fare per mutex e sync?",
        "I/O con primitiva di sistema",
        "Primitiva di lettura da interfaccia, perche' non salva ne carica lo stato?",
        "Come funziona il driver e chi lo chiama?",
        "A che serve la apic_send_EOI?",
        "3 punti focali di c_driver_i",
        "Gate della IDT per a_read_n e a_driver_i",
        "Cavallo di Troia",
        "Perche' la gestione con i driver e' sconveniente e come si evolve la situazione?",
        "Com'e' collegato il modulo I/O con il resto del sistema?",
        "Come funziona la activate_pe()?",
        "Cosa fa la wfi()?",
        "Primitiva di lettura",
    	"Differenze tra primitiva di sistema e driver,\nprimitiva di i/o e handler e Bus Mastering",
        "Avvio: quali strutture vengono create e come vengono inizializzate",
        "Cambio di processo",
        "Perche' punt_nucleo punta alla base?",
        "Come si passa il parametro alla activate_p?",
        "Chi e' che usa punt_nucleo?",
        "Perche' usiamo una pila sistema diversa per ogni processo?",
        "Cosa e' la preemption",
        "Cosa fa, dove e come si salta dopo carica_stato",
        "Precedenza su piu interruzioni contemporanee",
        "Perche' priorita' > e non >= per confrontare le richieste di interruzione?",
        "Differenza tra interrupt su fronte e su livello",
        "E' possibile che si perdano interruzioni? Se si quando non viene vista?\nAd esempio col timer c'e' la possibilita' di perdere un'interruzione se?",
        "Come gestire piu' richieste sullo stesso piedino apic",
        "Annidamento delle interruzioni con l'utilizzo dei due registri ISR IRR",
        "Cosa comporta programmare con le interruzioni attive",
        "Quando si traduce una funzione in c++ sono ripristinati tutti i registri?",
        "Quali sono le istruzioni che ci permettono di usare le interruzioni?",
        "Quando si accodano le richieste di interruzione su IRR?",
        "Perche' quando si attraversa il gate viene salvato il registro del flag?",
        "Come gestiamo le periferiche che agiscono sullo stesso piedino dell'apic?",
        "Quanti piedini ha l'APIC?",
        "Chi configura i registri dell'APIC e la IDT?",
        "Chi stabilisce le classi di priorita' nelle interruzioni e come si riconoscono?",
        "Registri ISR e IRR dell'APIC",
        "Cosa sono le interruzioni e a cosa servono?",
        "Quali sono le dipendenze sui dati e sui nomi",
        "Esecuzione speculativa e out of order con disegni",
        "Parli delle pipeline",
        "Esecuzione speculativa",
        "Come facciamo nel nostro nucleo a creare un modo per far si che i processi partono e dopo un tot di tempo vadano in fondo a coda pronti?",
        "E se il processo si sospende su un semaforo?",
        "Parli in generale dei semafori, a cosa servono, codice della struct, primitive semaforiche",
        "Problema della mutua esclusione",
        "Come e' organizzata la memoria virtuale di un processo?",
        "Come risolvere le Dipendenze sui nomi?",
        "Come risolvere le Dipendenze sul controllo?",
        "Cosa e' il ROB e a cosa serve?",
        "A cosa serve la rinomina dei registri?",
        "Differenza tra registri logici e fisici",
        "Come si gestisocno le istruzioni LOAD e STORE?",
        "Cosa succese se ho un page fault su una LOAD?",
        "Descrittore di frame"
    };
    
    const char* orale[NUM_ORALE] = {
         "Quando faccio una terminatep non posso distruggere la pila sistema in quanto mi serve poi nella carica_stato per completare le operazioni, come viene risolto?",
         "Protocollo di R/W sul BUS-PCI",
         "Funzionamento della transazione di configurazione",
         "Invertire cache e mmu?",
         "DMA in serie alla mmu risolve il problema degli indirizzi fisici dell'io?",
         "Struttura dati del timer del nucleo",
         "Implementazione della coda del timer",
         "Ottimizzazioni e rallentamenti nella coda con i contatori gia' decrementati",
         "Senza finestra sulla memoria fisica (niente di mappato) come faccio se arriva una interruzione?",
         "Processo esterno con privilegio utente, cosa non puo' fare senza modifiche al codice?"
    };

system("cls");
printf("Realizzato da Lorenzo Monaci nell'a.a. 22/23\n\n");
rand:
    while(c != 'q'){
	if(c == 'h'){
		printf("Raccolta di domande preparate dagli studenti e prese dagli orali per prepararsi all'orale di Calcolatori Elettronici con il buon (si fa per dire) prof. Lettieri.\n\n======================================\nTotale domande: 99: 89 dagli studenti, 10 dagli orali, da approfondire nello specifico parlando\n");

		printf("Guida comandi:\n"
				"Inserire un carattere qualsiasi per una domanda a caso\n"
				"\t(s): Riproduce le domande in sequenza dalla prima\n"
				"\t(o): Chiede le domande fatte dal prof\n"
				"\t[g(oto)]: attende un numero da usare come indice della domanda che si vuole visualizzare\n"
				"\t(q): esce\n");
		c = getch();
		if(c == 'q')
			goto end;
	}
        if(c == 's')
            goto seq;
        
        if(c == 'o')
            goto orale;


        i = rand() % (NUM_QUEST - 1);
        if(i == j) i = ((i+1) % NUM_QUEST);
        
        if(c == 'g'){
            printf("=> ");
            scanf("%d", &i);
            if(i >= NUM_QUEST)
                i = (i % NUM_QUEST);
        }
        
        printf("(%d) %d: [%s]\n", count, i, questions[i-1]);
        
        c = getch();
        #ifdef log_dbg
            log_dbg;
        #endif
        count++;
        j = i;
        system("cls");
    }
    goto end;

seq:
    for(short k = 0; k < NUM_QUEST; k++){
        if(c == 'q')
            break;
        if(c == 'g'){
            printf("=> ");
            scanf("%d", &k);
            if(k >= NUM_QUEST)
                k = (k % NUM_QUEST);
        }
        printf("%d/%d: [%s]\n", k+1, NUM_QUEST, questions[k]);
        c = getch();
        system("cls");
    }
    goto end;

orale:
    for(short k = 0; k < NUM_ORALE; k++){
        if(c == 'q')
            break;
        printf("%d: [%s]\n", k+1, orale[k]);
        c = getch();
        system("cls");
    }
    goto rand;

end:
    return 0;
}
