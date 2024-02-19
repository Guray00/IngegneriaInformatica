#include "utility.h"

/* converte una stringa in intero */
int string_to_int(char* string){
    char* endptr;
    return strtol(string, &endptr, 10);
}

/* mostra a video il timestamp sotto forma di stringa, usata per il log */
char* timestamp(){
    time_t current_time;
    time(&current_time);
    
    struct tm *local_time = localtime(&current_time);

    /* utilizza asctime per ottenere una stringa di caratteri leggibile */
    char *time_str = asctime(local_time);

    /* rimuovi il carattere di nuova linea, se presente */
    size_t len = strlen(time_str);
    if (len > 0 && time_str[len - 1] == '\n') {
        time_str[len - 1] = '\0';
    }
    return time_str;
}

/* leggere una intera riga dal flusso di stdin */
void read_from_stdin(char* buff){
    char c;
    scanf("%1023[^\n]", buff);
    while ((c = getchar()) != '\n' && c != EOF);
}

/* ritorna una stringa con il tempo rimanente */
char* remaining_time(int remaining_seconds){
    char* str = malloc(sizeof(64));
    int remaining_minutes;
    
    if (remaining_seconds == 0) {  
        sprintf(str, "%s", "tempo scaduto!");
        return str;
    }

    remaining_minutes = remaining_seconds / 60;
    remaining_seconds = remaining_seconds % 60;
    sprintf(str, "%dmin %dsec rimanenti", remaining_minutes, remaining_seconds);
    return str;
}

/* implementazione della funzione substr */
void substr(const char* str, char* dest, int start, int length) {
    int i;
    if (start < 0 || start >= strlen(str))
        return;

    if(length == 0){
        /* voglio prendere la sottostringa fino in fondo */
        strcpy(dest, str + start);
    } else {
        /* voglio prendere la sottostringa di quella dimensione */
        for (i = 0; i < length && str[start + i] != '\0'; i++)
            dest[i] = str[start + i];
        dest[i] = '\0';
    }
}

/* implementazione della funzione trim */
void trim(char *str) {
    int start = 0;
    int end = strlen(str) - 1;
    int i, j;
    
    /* Trova l'indice del primo carattere non spazio all'inizio della stringa */
    while (isspace(str[start]))
        start++;

    /* Trova l'indice dell'ultimo carattere non spazio alla fine della stringa */
    while (end > start && isspace(str[end]))
        end--;

    /* Sposta la parte non spazio della stringa all'inizio */
    memmove(str, str + start, end - start + 1);

    /* Aggiunge il terminatore di stringa alla fine della nuova stringa */
    str[end - start + 1] = '\0';

    /* Rimuove gli spazi doppi all'interno della stringa */
    for (i = 0, j = 0; str[i]; i++) {
        if (!isspace(str[i]) || (i > 0 && !isspace(str[i - 1]))) {
            str[j++] = str[i];
        }
    }

    /* Aggiunge il terminatore di stringa alla fine della stringa risultante */
    str[j] = '\0';
}

