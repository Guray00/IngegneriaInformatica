#include "head.h"
#include "funz_serv.h"
#include "utility.h"
#include "Tavolo.h"
#include "Prenotazione.h"
#include "Piatto.h"
#include "Ordine.h"
#include "Comanda.h"
#include "TableDevice.h"
#include "KitchenDevice.h"

//mostra l'elenco di comandi selezionabili da terminale
void guida_comandi_serv(){
    printf("Guida comandi server:\n");
    printf("- stat table|status: restituisce stato delle comande giornaliere in base al parametro scelto.\n \"table\" deve essere un codice Tx dove x e' il numero del tavolo di cui si vogliono visionare le comande.\n \"status\" deve essere il carattere a, s, oppure p.\n");
    printf("- stop: arresta il server se non ci sono comande \"in attesa\" o \"in preparazione\"\n");
    return;
}

//mostra lo stato delle comande presenti tra tutti i tavoli, in base ai parametri specificati (o non)
void gestisci_comando_stat(char* p_comandointero, struct Comanda* p_elencoComande){
    int num_tavolo;
    char letterastat[2] = "";

    //non sono stati specificati parametri
    if(strcmp(p_comandointero, "stat\n") == 0){
        stat_no_parametri(p_elencoComande);
    }
    //l'utente ha specificato parametri, bisogna capire quali
    else if(sscanf(p_comandointero, "stat T%d", &num_tavolo) == 1){
        if(num_tavolo < 1 || num_tavolo > MAX_TAVOLI){
            printf("Numero tavolo non valido.\n");
        }
        else stat_num_tavolo(num_tavolo, p_elencoComande);
    }
    else if(sscanf(p_comandointero, "stat %s", letterastat) == 1){
        if(strcmp(letterastat, "a") == 0 || strcmp(letterastat, "p") == 0 || strcmp(letterastat, "s") == 0){
            stat_con_lettera(letterastat[0], p_elencoComande);
        }
        else printf("Parametro della stat non valido. Lettere valide: a, p, s.\n");
    }
    else{
        printf("Comando stat invocato con parametri non validi.\n");
    }
    return;
}

void stat_no_parametri(struct Comanda* p_elencoComande){
    struct Comanda* tmp = p_elencoComande;
    struct Ordine* tmp_ordine = NULL;
    char buffer[RIGA_TESTO_SIZE];
    char pezzo_messaggio[RIGA_TESTO_SIZE];

    while(tmp != NULL){
        sprintf(buffer, "com%d T%d <%s>\n", tmp->num_comanda, tmp->id_tavolo, tmp->stato);
        tmp_ordine = tmp->ordini;
        while(tmp_ordine != NULL){
            sprintf(pezzo_messaggio, "%s %d\n", tmp_ordine->cod_piatto, tmp_ordine->quantita);
            strcat(buffer, pezzo_messaggio);
            tmp_ordine = tmp_ordine->next;
        }
        printf(buffer);
        tmp = tmp->next;
    }
    return;
}

void stat_num_tavolo(int p_num_tavolo, struct Comanda* p_elencoComande){
    struct Comanda* tmp = p_elencoComande;
    struct Ordine* tmp_ordine = NULL;
    char buffer[RIGA_TESTO_SIZE];
    char pezzo_messaggio[RIGA_TESTO_SIZE];

    while(tmp != NULL){
        if(tmp->id_tavolo == p_num_tavolo){
            sprintf(buffer, "com%d <%s>\n", tmp->num_comanda, tmp->stato);
            tmp_ordine = tmp->ordini;
            while(tmp_ordine != NULL){
                sprintf(pezzo_messaggio, "%s %d\n", tmp_ordine->cod_piatto, tmp_ordine->quantita);
                strcat(buffer, pezzo_messaggio);
                tmp_ordine = tmp_ordine->next;
            }
            printf(buffer);
        }
        tmp = tmp->next;
    }
    return;
}

void stat_con_lettera(char p_letterastat, struct Comanda* p_elencoComande){
    struct Comanda* tmp = p_elencoComande;
    struct Ordine* tmp_ordine = NULL;
    char buffer[RIGA_TESTO_SIZE];
    char pezzo_messaggio[RIGA_TESTO_SIZE];

    while(tmp != NULL){
        if((p_letterastat == 'a' && strcmp(tmp->stato, "In attesa") == 0) ||
           (p_letterastat == 'p' && strcmp(tmp->stato, "In preparazione") == 0) ||
           (p_letterastat == 's' && strcmp(tmp->stato, "In servizio") == 0)){
            sprintf(buffer, "com%d T%d\n", tmp->num_comanda, tmp->id_tavolo);
            tmp_ordine = tmp->ordini;
            while(tmp_ordine != NULL){
                sprintf(pezzo_messaggio, "%s %d\n", tmp_ordine->cod_piatto, tmp_ordine->quantita);
                strcat(buffer, pezzo_messaggio);
                tmp_ordine = tmp_ordine->next;
            }
            printf(buffer);
        }
        tmp = tmp->next;
    }
    return;
}

void gestisci_comando_stop(char* p_comandointero, struct Comanda** p_elencoComande, struct KitchenDevice** p_elencoKD, struct TableDevice** p_elencoTD, 
                                                  struct Prenotazione** p_elencoPrenotazioni, struct Tavolo* p_elencoTavoli, struct Piatto** p_elencoPiatti,
                                                  int* p_tdonline, int p_listener){
    struct Comanda* l_comande = *p_elencoComande;
    bool trovata = false;
    struct KitchenDevice* l_elencoKD = *p_elencoKD;
    struct TableDevice* l_elencoTD = *p_elencoTD;

    if(strcmp(p_comandointero, "stop\n") == 0){
        //devo assicurarmi che non ci siano comande in attesa o in preparazione prima di proseguire
        while(l_comande != NULL){
            if(strcmp(l_comande->stato, "In attesa") == 0 || strcmp(l_comande->stato, "In preparazione") == 0){
                trovata = true;
                break;
            }
            l_comande = l_comande->next;
        }
        if(trovata){
            printf("Ci sono ancora delle comande in attesa o in preparazione. Attendere che le comande siano tutte state soddisfatte e poi riprovare.\n");
            return;
        }

        //se arrivo qui, sono pronto ad eseguire la procedura di stop.
        //devo svuotare la memoria di tutte le mie strutture dati. 
        printf("Ricevuto comando \"stop\". Arresto il server...\n");

        //1) Comande
        printf("Svuoto lista comande... ");
        svuota_lista_comande(p_elencoComande);
        printf("OK\n");

        //2) Piatti
        printf("Svuoto lista piatti... ");
        svuota_lista_piatti(p_elencoPiatti);
        printf("OK\n");

        //3) Tavoli
        printf("Svuoto lista tavoli... ");
        svuota_array_tavoli(p_elencoTavoli);
        printf("OK\n");

        //4) Prenotazioni
        //Per le prenotazioni, prima di svuotare la lista, devo aggiornare il file delle prenotazioni in modo tale che le
        //prenotazioni salvate per il futuro, rimangano alla futura accensione del server, e quelle che ho soddisfatto
        //vengano eliminate.
        printf("Creo nuovo file prenotazioni... ");
        crea_file_prenotazioni(*p_elencoPrenotazioni);
        printf("OK\nSvuoto lista prenotazioni... ");
        svuota_lista_prenotazioni(p_elencoPrenotazioni);
        printf("OK\n");

        //Per i kitchen device e i table device, prima di svuotare le relative liste, devo mandare un messaggio a ognuno 
        //di loro per segnalare che devono terminare a loro volta.

        //5) KitchenDevice
        printf("Avviso i KD... ");
        while(l_elencoKD != NULL){
            if(!invia_messaggio(l_elencoKD->socket, "stop", "Errore in fase di invio stop kitchen device.")) return;
            l_elencoKD = l_elencoKD->next;
        }
        printf("OK\nSvuoto lista KD... ");
        svuota_lista_kd(p_elencoKD);
        printf("OK\n");

        //6) TableDevice
        printf("Avviso i TD... ");
        while(l_elencoTD != NULL){
            if(!invia_messaggio(l_elencoTD->socket, "stop", "Errore in fase di invio stop table device.")) return;
            l_elencoTD = l_elencoTD->next;
        }
        printf("OK\nSvuoto lista TD... ");
        svuota_lista_td(p_elencoTD);
        *p_tdonline = 0;
        printf("OK\n");

        //per finire, posso terminare il server
        printf("Arresto il server! A domani!\n");
	    fflush(stdout);
	    close(p_listener);
        exit(0);
    }
    else{
        printf("Comando stop inserito in modo errato. Riprovare.\n");
    }
    return;
}

//riceve il comando find da parte del client e gli restituisce la lista dei tavoli disponibili
//per essere prenotati
void gestisci_comando_find_server(int p_socket, char* p_buffer, struct Tavolo* p_elencoTavoli){
    char comando[COMANDO_SIZE];
    char cliente[CLIENTE_SIZE];
    int num_persone;
    int giorno;
    int mese;
    int anno;
    int ora;

    printf("Ho ricevuto un comando \"find\" dal client, preparo la lista di tavoli da inviare...\n");
    sscanf(p_buffer, "%s %s %d %d-%d-%d %d", comando, cliente, &num_persone, &giorno, &mese, &anno, &ora);
    gv_tavoli_disponibili = verifica_tavoli_disponibili(p_elencoTavoli, num_persone, giorno, mese, anno, ora);
    struct Tavolo* tmp = gv_tavoli_disponibili;
    while(tmp != NULL){
        sprintf(p_buffer, "Tavolo: %d; Posti: %d; Sala: %d; Posizione: %s.", tmp->id, tmp->numposti, tmp->sala, tmp->posizionesala);
        if(!invia_messaggio(p_socket, p_buffer, "Errore in fase di invio tavoli_disponibili.")) return;
        tmp = tmp->next;
    }
    svuota_lista_tavoli(&gv_tavoli_disponibili);
    if(!invia_messaggio(p_socket, "FINE", "Errore in fase di comunicazione fine tavoli.")) return;
    printf("Lista tavoli inviata.\n");
    return;
}

//riceve il comando book da parte del client e gli restituisce il codice prenotazione
//dopo aver salvato la relativa prenotazione
void gestisci_comando_book_server(int p_socket, char* p_buffer, struct Prenotazione* p_elencoPrenotazioni, struct Tavolo* p_elencoTavoli){
    char comando[COMANDO_SIZE];
    int id_tavolo_trovato;
    char cliente[CLIENTE_SIZE];
    char comando_find[COMANDO_SIZE]; //contiene la parola "find" che e' gia' compresa nel buffer. e' solo per far tornare i conti con la sscanf
    int num_persone;
    int giorno;
    int mese;
    int anno;
    int ora;

    struct Prenotazione* tmp = NULL; //per creare la nuova prenotazione da inserire
    struct Prenotazione* tmp_dup = NULL;
    int nuovo_id_prenotazione;

    printf("Ho ricevuto un comando \"book\" dal client. Inserisco la prenotazione...\n");
    sscanf(p_buffer, "%s %d %s %s %d %d-%d-%d %d", comando, &id_tavolo_trovato, comando_find, cliente, &num_persone, &giorno, &mese, &anno, &ora);
    nuovo_id_prenotazione = genera_id_prenotazione(p_elencoPrenotazioni, id_tavolo_trovato);
    tmp = new_prenotazione(nuovo_id_prenotazione, cliente, num_persone, giorno, mese, anno, ora);
    tmp_dup = dup_prenotazione(tmp);
    ins_prenotazione(&p_elencoPrenotazioni, tmp);
    ins_prenotazione(&p_elencoTavoli[id_tavolo_trovato - 1].prenotazioni, tmp_dup);
    printf("Prenotazione inserita. Mando al client il codice della prenotazione...\n");
    sprintf(p_buffer, "%d", nuovo_id_prenotazione);
    if(!invia_messaggio(p_socket, p_buffer, "Errore in fase di invio codice prenotazione (comando book).")) return;
    printf("Codice prenotazione del client inviato: prenotazione cod. %d.\n", nuovo_id_prenotazione);
    return;
}

//riceve il comando prenotazione da parte del table device. In sostanza riceve il codice della prenotazione,
//controlla che questo codice esiste ed e' valido, e lo comunica al table device
void gestisci_comando_prenotazione_server(int p_socket, char* p_buffer, struct Prenotazione** p_elencoPrenotazioni, struct Tavolo* p_elencoTavoli, struct TableDevice** p_elencoTD){
    char comando[COMANDO_SIZE];
    int cod_prenotazione;
    int indice_tavolo;
    int ret;
    struct TableDevice* tmp = NULL;

    sscanf(p_buffer, "%s %d", comando, &cod_prenotazione);
    indice_tavolo = (cod_prenotazione % 10);

    //Devo controllare che il codice della prenotazione che ho ricevuto sia valido
    printf("Ricevuto un codice prenotazione da un table device, ne controllo la validita'...\n");
    if(prenotazione_valida(cod_prenotazione, *p_elencoPrenotazioni)){
        rem_prenotazione(p_elencoPrenotazioni, cod_prenotazione);
        rem_prenotazione(&p_elencoTavoli[indice_tavolo - 1].prenotazioni, cod_prenotazione);
        p_elencoTavoli[indice_tavolo - 1].num_prenotazioni--;
        tmp = new_td(p_socket, indice_tavolo);
        ins_td(p_elencoTD, tmp);
        printf("Codice valido. Restituisco il risultato al table device.\n");
        ret = send(p_socket, "OK", 3, 0);
        if (ret < 0){
            perror("Errore nell'avvisare il td cod prenotazione.\n");
            close(p_socket);
            return;
        }
    }
    else{
        printf("Codice NON valido. Restituisco il risultato al table device.\n");
        ret = send(p_socket, "NO", 3, 0);
        if (ret < 0){
            perror("Errore nell'avvisare il td cod prenotazione negativa.\n");
            close(p_socket);
            return;
        }
    }
    return;
}

//funzione che dopo aver ricevuto la richiesta di far vedere il menu, manda al table device la lista
//con tutti i piatti contenuti nel menu
void gestisci_comando_menu_server(int p_socket, char* p_buffer, struct Piatto* p_elencoPiatti){
    struct Piatto* tmp = p_elencoPiatti;
    printf("Ho ricevuto una richiesta di menu da parte del table device (socket) n. %d.", p_socket);
    while(tmp != NULL){
        sprintf(p_buffer, "%s) €%d\t%s", tmp->cod_piatto, tmp->prezzo, tmp->nome_piatto);
        if(!invia_messaggio(p_socket, p_buffer, "Errore in fase di invio menu.")) return;
        tmp = tmp->next;
    }
    if(!invia_messaggio(p_socket, "FINE", "Errore in fase di comunicazione menu.")) return;
    printf("Menu inviato.\n");
    return;
}

//ricevuta una comanda dal table device, prima di tutto deve controllare che sia valida (ossia che abbia almeno un piatto e che
//i piatti contenuti nella comanda facciano parte del menu'). Dopodiche', se valida, deve salvare la comanda con i suoi ordini nella lista comande
//e mandare un messaggio a tutti i kitchen device per avvisarli che una nuova comanda e' arrivata
void gestisci_comando_comanda_server(int p_socket, char* p_buffer, struct Piatto* p_elencoPiatti, struct Comanda** p_elencoComande, struct KitchenDevice* p_elencoKD){
    char comandotoken[COMANDO_SIZE];
    char* token = NULL;
    char comando[COMANDO_SIZE]; //conterra' la parola "comanda", da ignorare
    int id_tavolo;
    int numero_comanda;
    char comandointero[COMANDO_SIZE];
    char letterapiatto;
    char numeropiatto;
    char codicepiatto[COD_PIATTO_SIZE];
    int quantita;
    char pezzo_messaggio[RIGA_TESTO_SIZE]; //serve per comporre il messaggio da rimandare indietro al table device

    struct Ordine* head = NULL;
    struct Ordine* ordine_tmp = NULL;
    struct Comanda* comanda_tmp = NULL;

    printf("Ho ricevuto una comanda. Controllo che sia stata inserita correttamente...\n");
    sscanf(p_buffer, "%s %d %[^\n]", comando, &id_tavolo, comandointero);
    if(!controlla_piatti(comandointero, p_elencoPiatti)){
        printf("Il comando NON e' stato inserito correttamente, comunico il risultato.\n");
        if(!invia_messaggio(p_socket, "NO", "Errore in fase di invio comanda errata.")) return;
        return;
    }
    
    //se arrivo qui vuol dire che il comando e' inserito in un formato valido.
    //quindi inserisco i vari piatti in una lista di ordini, che comporranno una comanda.
    printf("Comanda corretta. Aggiungo la comanda alla lista di comande...\n");

    //copio il comando in un'altra stringa per poter usare la strtok
    //senza modificare il comando originale
    strcpy(comandotoken, comandointero);

    //tokenizzo il comando cosi' sono gia' pronto a controllare
    //i successivi parametri. So che ce n'e almeno uno perche'
    //lo controllo nella funzione controlla_piatti()
    token = strtok(comandotoken, " \n");

    //so che la prima parola sara' "comanda", quindi salto direttamente alla successiva
    token = strtok(NULL, " \n");

    numero_comanda = genera_numero_comanda(id_tavolo, *p_elencoComande);
    sprintf(p_buffer, "Comanda %d:", numero_comanda);

    while(token != NULL){
        sscanf(token, "%c%c-%d", &letterapiatto, &numeropiatto, &quantita);
        sprintf(pezzo_messaggio, " %s", token);
        strcat(p_buffer, pezzo_messaggio);
        sprintf(codicepiatto, "%c%c", letterapiatto, numeropiatto);
        ordine_tmp = new_ordine(codicepiatto, quantita);
        ins_ordine(&head, ordine_tmp);
        token = strtok(NULL, " \n");
    }

    comanda_tmp = new_comanda(head, "In attesa", id_tavolo, numero_comanda);
    ins_comanda(p_elencoComande, comanda_tmp);
    printf("Completato.\n");
    strcat(p_buffer, " -> In attesa...");
    notifica_kd(*p_elencoComande, p_elencoKD);
    printf("Mando al table device il messaggio che la sua comanda e' in attesa...\n");
    if(!invia_messaggio(p_socket, p_buffer, "Errore in fase di invio ricevuta comanda.")) return;
    printf("Messaggio inviato.\n");
    return;
}

int genera_numero_comanda(int p_id_tavolo, struct Comanda* p_elencoComande){
    struct Comanda* tmp = p_elencoComande;
    int ret = 1;
    while(tmp != NULL){
        if(tmp->id_tavolo == p_id_tavolo) ret++;
        tmp = tmp->next;
    }
    return ret;
}

//notifica tutti i kd del numero di comande attualmente in attesa
void notifica_kd(struct Comanda* p_elencoComande, struct KitchenDevice* p_elencoKD){
    struct Comanda* tmp = p_elencoComande;
    struct KitchenDevice* sendto = p_elencoKD;
    char buffer[RIGA_TESTO_SIZE] = "notifica ";

    if(tmp == NULL || sendto == NULL) return;
    while(tmp != NULL){
        if(strcmp(tmp->stato, "In attesa") == 0) strcat(buffer, "*");
        tmp = tmp->next;
    }

    printf("Notifico i kd del numero di comande aggiornato.\n");
    while(sendto != NULL){
        if(!invia_messaggio(sendto->socket, buffer, "Errore in fase di invio notifica numero comande.")) return;
        sendto = sendto->next;
    }
    return;
}

void gestisci_comando_conto_server(int p_socket, char* p_buffer, struct Piatto* p_elencoPiatti, struct Comanda* p_elencoComande){
    struct Piatto* tmp_piatto = NULL;
    struct Comanda* tmp_comanda = p_elencoComande;
    struct Ordine* tmp_ordini = NULL;
    int l_id_tavolo;
    char buffer[BUFFER_SIZE] = "";
    char pezzo_messaggio[RIGA_TESTO_SIZE];
    int parziale = 0;
    int totale = 0;

    sscanf(p_buffer, "conto %d", &l_id_tavolo);
    while(tmp_comanda != NULL){
        if(tmp_comanda->id_tavolo == l_id_tavolo){
            tmp_ordini = tmp_comanda->ordini;
            while(tmp_ordini != NULL){
                tmp_piatto = p_elencoPiatti;
                while(tmp_piatto != NULL){
                    if(strcmp(tmp_ordini->cod_piatto, tmp_piatto->cod_piatto) == 0){
                        parziale = tmp_ordini->quantita * tmp_piatto->prezzo;
                        totale += parziale;
                        sprintf(pezzo_messaggio, "%s %d %d\n", tmp_ordini->cod_piatto, tmp_ordini->quantita, parziale);
                        strcat(buffer, pezzo_messaggio);
                        break;
                    }
                    tmp_piatto = tmp_piatto->next;
                }
                tmp_ordini = tmp_ordini->next;
            }
        }
        tmp_comanda = tmp_comanda->next;
    }
    sprintf(pezzo_messaggio, "Totale: %d", totale);
    strcat(buffer, pezzo_messaggio);
    if(!invia_messaggio(p_socket, buffer, "Errore in fase di invio conto.")) return;
    return;
}

//ricevuto un comando take da un kitchen device, devo vedere qual e' la prima comanda in attesa che trovo
//(che e' di conseguenza quella in attesa da piu' tempo) e gliela mando, modificandone lo stato in
//"In preparazione" nel frattempo.
void gestisci_comando_take_server(int p_socket, char* p_buffer, struct Comanda* p_elencoComande, struct TableDevice* p_elencoTD, struct KitchenDevice* p_elencoKD){
    struct Comanda* tmp = p_elencoComande;
    struct TableDevice* td = p_elencoTD;
    char buffer_td[BUFFER_SIZE] = "take ";

    if(tmp == NULL){
        printf("Comanda NON trovata, lo comunico al kd...\n");
        if(!invia_messaggio(p_socket, "NO", "Errore in fase di invio mal riuscita comando take server.")) return;
        return;
    } 

    if(td == NULL){
        printf("Non ci sono ancora td connessi, lo comunico al kd...\n");
        if(!invia_messaggio(p_socket, "NO", "Errore in fase di invio mal riuscita comando take server.")) return;
        return;
    }  

    struct Ordine* ordini = NULL;
    char pezzo_messaggio[RIGA_TESTO_SIZE];

    printf("Ho ricevuto un comando take, trovo la comanda da mandare al kd...\n");
    while(tmp != NULL){
        ordini = tmp->ordini;
        if(strcmp(tmp->stato, "In attesa") == 0){
            printf("Comanda trovata, la mando al kd...\n");

            //preparo il messaggio da mandare anche al td
            while(td != NULL){
                //assumo che lo trovero' sempre visto che le comande vengono da td connessi, sono sicuramente combacianti, devo solo trovarlo.
                if(td->id_tavolo == tmp->id_tavolo) break;
                td = td->next;
            }
            sprintf(pezzo_messaggio, "Comanda %d:", tmp->num_comanda);
            strcat(buffer_td, pezzo_messaggio);
            /* ------------------------------------------ */

            strcpy(tmp->stato, "In preparazione");
            sprintf(p_buffer, "com%d T%d\n", tmp->num_comanda, tmp->id_tavolo);
            if(!invia_messaggio(p_socket, p_buffer, "Errore in fase di invio comando take server 1.")) return;
            while(ordini != NULL){
                sprintf(pezzo_messaggio, "%s %d", ordini->cod_piatto, ordini->quantita);
                if(!invia_messaggio(p_socket, pezzo_messaggio, "Errore in fase di invio comando take server 2.")) return;
                //altro pezzo di messaggio da mandare al td
                sprintf(pezzo_messaggio, " %s-%d", ordini->cod_piatto, ordini->quantita);
                strcat(buffer_td, pezzo_messaggio);
                /* ---------------------------------------- */
                ordini = ordini->next;
            }
            if(!invia_messaggio(p_socket, "FINE", "Errore in fase di invio comando take server 3.")) return;
            //parte finale messaggio da mandare al td
            strcat(buffer_td, " -> In preparazione...");
            if(!invia_messaggio(td->socket, buffer_td, "Errore in fase di invio comando take server 3 (al td).")) return;
            /* ------------------------------------- */
            notifica_kd(p_elencoComande, p_elencoKD);
            return;
        }
        tmp = tmp->next;
    }

    if(tmp == NULL){
        printf("Comanda NON trovata, lo comunico al kd...\n");
        if(!invia_messaggio(p_socket, "NO", "Errore in fase di invio mal riuscita comando take server.")) return;
        return;
    }    
}

//ricevuto il comando set dal kitchen device, devo mettere la comanda desiderata nello stato "In servizio"
//e poi avvisare il table device.
void gestisci_comando_set_server(int p_socket, char* p_buffer, struct Comanda* p_elencoComande, struct TableDevice* p_elencoTD){
    struct Comanda* tmp = p_elencoComande;
    struct TableDevice* td = p_elencoTD;
    struct Ordine* ordini_tmp = NULL;
    char comando[COMANDO_SIZE] = ""; //conterra' la parola set, da ignorare
    int l_id_tavolo;
    int l_num_comanda;
    char pezzo_messaggio[RIGA_TESTO_SIZE] = "";

    printf("Ho ricevuto un comando \"set\" da un kitchen device. Imposto la comanda desiderata nello stato \"In servizio\"...\n");
    sscanf(p_buffer, "%s com%d-T%d", comando, &l_num_comanda, &l_id_tavolo);

    //devo trovare la comanda giusta per cambiare lo stato, dopodiche' lo cambio.
    //posso assumere che la comanda esista, perche' il controllo che non esiste l'ho gia'
    //fatto lato kd
    while(tmp != NULL){
        if(tmp->id_tavolo == l_id_tavolo && tmp->num_comanda == l_num_comanda){
            strcpy(tmp->stato, "In servizio");
            ordini_tmp = tmp->ordini;
            break;
        }
        tmp = tmp->next;
    }

    printf("Avviso il td che la comanda e' andata in servizio...\n");
    //devo preparare il messaggio da mandare al td.
    while(td != NULL){
        if(td->id_tavolo == l_id_tavolo) break;
        td = td->next;
    }

    sprintf(p_buffer, "set Comanda %d:", l_num_comanda);
    while(ordini_tmp != NULL){
        sprintf(pezzo_messaggio, " %s-%d", ordini_tmp->cod_piatto, ordini_tmp->quantita);
        strcat(p_buffer, pezzo_messaggio);
        ordini_tmp = ordini_tmp->next;
    }
    strcat(p_buffer, " -> In servizio!");

    printf("Avviso il kd che la comanda e' andata in servizio...\n");
    if(!invia_messaggio(p_socket, "COMANDA IN SERVIZIO", "Errore in fase di invio comando set server.")) return;
    if(!invia_messaggio(td->socket, p_buffer, "Errore in fase di invio comando set server (al td).")) return;
    return;
}