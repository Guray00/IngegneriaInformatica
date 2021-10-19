#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>	

#define NUM_PLAYERS 7

int bet[NUM_PLAYERS]; // vettore con le ultime scommesse. La scommessa del
					  // player i è in posizione bet[i].
// intervallo min-max usato come suggerimento per facilitare i giocatori.
int max;
int min;

pthread_mutex_t m;
pthread_cond_t BETTING; // condizione "SCOMMESSE IN CORSO"
pthread_cond_t RESULTS; // condizione "RISULTATI NON ANCORA PRONTI"
int remaining;			// #giocatori che ancora devono fare la loro scommessa
int winner;				// vincitore

void * player(void * arg){
	int id = *(int*)arg;
    while(1) {
    	// Suggerimento: per fare la scommessa usare: rand()%(max+1-min) + min
    	// Il giocatore, dopo aver fatto la scommessa, deve svegliare il padre
    	// (main) se necessario. Poi deve attendere che i risultati siano pronti.
        //
        //
        //
        //
        //
	    //
        //
        //

        if (winner >= 0){
            if (winner == id){
                printf("[Thread %d]: Ho vinto\n", id);
            }
            else {
                printf("[Thread %d]: Ho perso\n", id);
            }
            free(arg);
            pthread_exit(NULL);
        }
    }
}

int main(){
	int x; // numero da indovinare
    min = 1;
    max = 2000;
    winner = -1;
    remaining = NUM_PLAYERS;
    pthread_mutex_init(&m, NULL);
    pthread_cond_init(&RESULTS, NULL);
    pthread_cond_init(&BETTING, NULL);

    pthread_t players[NUM_PLAYERS];
    int* playerIDs[NUM_PLAYERS];
    
    srand(time(NULL));
    x = rand()%(max+1-min) + min; // inizializzazione numero da indovinare
    printf("[Main]: Il numero da indovinare e' compreso tra %d e %d\n", min,max);

    for (int i = 0; i < NUM_PLAYERS; i++){
    	playerIDs[i] = (int*)malloc(sizeof(int));
    	*playerIDs[i] = i;
        pthread_create(&players[i], NULL, player, playerIDs[i]);
    }

    while(1) {
        	pthread_mutex_lock(&m);
        	// Qui ho usato if anziche' while... perche' funzioni devo essere
        	// sicuro che al risveglio remaining sia 0.
            if (remaining > 0){
                pthread_cond_wait(&BETTING, &m);
            }
            
            for (int i = 0; i < NUM_PLAYERS; i++){
                if (x == bet[i]){
                    winner = i;
                    pthread_cond_broadcast(&RESULTS);
                    break;
                }            
                if (bet[i]>min && bet[i]<x){
                    min = bet[i];
                }
                if (bet[i]>x && bet[i]<max){
                    max = bet[i];
                }
            }
           
            if (winner >=0){
                printf("[Main]: Vince il giocatore %d\n", winner);
                pthread_mutex_unlock(&m);
                break;
            }
            printf("[Main]: Nessun vincitore a questo giro. Il numero e' compreso tra %d e %d\n", min,max);
            remaining = NUM_PLAYERS;
            sleep(3);
            pthread_cond_broadcast(&RESULTS);
            pthread_mutex_unlock(&m);
    }
    
    pthread_exit(NULL);
    return 0;
}

