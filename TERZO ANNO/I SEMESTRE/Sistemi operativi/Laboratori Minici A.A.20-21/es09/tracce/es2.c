#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>

#define NTHREADS	4

pthread_mutex_t M;
pthread_cond_t CHECKPOINT; // condition variable 
int checked_threads = 0; // conto dei thread che hanno eseguito la sleep() e 
						 // e si sono "registrati" al checkpoint.

void* thread_function(void * arg)
{
	int delay = rand()%15;
	int id = *(int*)arg;
	printf("[Thread %d] Waiting for %d secs...\n", id, delay);
	sleep(delay);
	printf("[Thread %d] ...awake, waiting for the other threads...\n",id);
	
	// Checkpoint -- assicurare che i thread "si aspettino a vicenda" prima
	// di terminare e stampare "OK".
	//
	//
	//
	//
	//
	//
	//
	//
	
	printf("[Thread %d] ...ok!\n",id);
	free(arg);
	pthread_exit(NULL);
}

int main(void)
{
	pthread_mutex_init(&M, NULL);
	pthread_cond_init(&CHECKPOINT, NULL);
	pthread_t threads[NTHREADS];

	int* params[NTHREADS];
	int i, rc;

	srand ( time(NULL) );

	printf("[Main] Starting...\n");
	for (i=0; i<NTHREADS; i++) {
		params[i] = (int*)malloc(sizeof(int));
		*params[i] = i+1;
		rc = pthread_create(&threads[i], NULL, thread_function, params[i]);
		if (rc){
			perror("[Main] ERROR from pthread_create()\n");
			exit(-1);
		}
	}

	pthread_exit(NULL);
}


