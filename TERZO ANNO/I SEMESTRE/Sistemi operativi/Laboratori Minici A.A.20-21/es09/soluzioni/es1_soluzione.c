#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define N_PRODUCERS 20
#define N_CONSUMERS 20

int balance;
pthread_mutex_t M;
pthread_cond_t LOW_BALANCE;

void withdraw(int amount, int tid){
    pthread_mutex_lock(&M);
    while (balance - amount < 0)
        pthread_cond_wait(&LOW_BALANCE, &M);
    balance = balance - amount;
    printf("[ Consumer %d ]: \tPrelevato %d. Credito residuo: %d.\n", tid, amount, balance);
    pthread_mutex_unlock(&M);
}

void deposit(int amount, int tid){
    pthread_mutex_lock(&M);
    balance = balance + amount;
    printf("[ Producer %d ]: \tDepositato %d. Credito residuo: %d.\n", tid, amount, balance);
    // In questo esempio devo usare la broadcast e non la signal. Infatti, dopo
    // il deposito non so quanti (e quali) thread consumatori potranno fare 
    // il prelievo (in questo esempio i valori di prelievo/deposito sono delle 
    // costanti, ma in realta' non sara' cosi'). Quindi la soluzione e' risvegliare
    // tutti i consumer in attesa (broadcast).
    pthread_cond_broadcast(&LOW_BALANCE);
    pthread_mutex_unlock(&M);
}

void* producer(void * id){
   int tid = *(int*)id; 
   for (int i = 0; i < 4; i++)
      deposit(25, tid); 
   free(id);
   pthread_exit(NULL); 
}

void* consumer(void * id){
   int tid = *(int*)id; 
   for (int i = 0; i < 10; i++)
       withdraw(10, tid);
   free(id);
   pthread_exit(NULL); 
}

int main(){
    pthread_t consumers[N_CONSUMERS];
    pthread_t producers[N_PRODUCERS];
    pthread_mutex_init(&M, NULL);
    pthread_cond_init(&LOW_BALANCE, NULL);
    balance = 0;
    // IDs
    int* consumerID[N_CONSUMERS];
    int* producerID[N_PRODUCERS];
    
    // Create prod/cons threads.
    for (int i = 0; i < N_CONSUMERS; i++){
    	consumerID[i] = (int*)malloc(sizeof(int));
    	*consumerID[i] = i+1;
        pthread_create(&consumers[i], NULL, consumer, consumerID[i]);
    }
    for (int i = 0; i < N_PRODUCERS; i++){
    	producerID[i] = (int*)malloc(sizeof(int));    
    	*producerID[i] = i+1;
        pthread_create(&producers[i], NULL, producer, producerID[i]);
    }
    
    // Wait for termination of all threads.
    for (int i = 0; i < N_PRODUCERS; i++)
        pthread_join(producers[i], NULL);
    for (int i = 0; i < N_CONSUMERS; i++)
        pthread_join(consumers[i], NULL);

	// Print final balance.
    printf("[ Main ]: \tCredito finale: %d.\n", balance);
    return 0;
}

