#include<stdio.h>
#include<string.h>
//#include<winsock2.h>

struct sottorete {
    char * nome [16];
    unsigned int total;
    struct sottorete * next;
};

struct sottorete *testa = NULL;

// mi faccio le mie funzioni di conversione, con blackjack e squillo di lusso
void ntop(unsigned int num, char * target){
    char tmp[3];
    unsigned int iter = num, mask = 0xff000000;
    iter = iter >> 24;
    sprintf(target, "%u", iter);
    for(int i = 0; i < 3;i++){
        mask = mask >> 8;
        iter = num & mask;
        iter = iter >> 8*(2-i);
        sprintf(tmp, "%u", iter);
        strcat(target,".");
        strcat(target, tmp);
    };
}

unsigned int pton(char * str){
    char * token;
    unsigned int res = 0, iter;
    unsigned int i = 0;
    char del[] = ".";
    token = strtok(str, del);
    while (token != NULL) {
        iter = (unsigned int) strtoul(token, NULL, 10);
        iter = iter << 8 * (3 - i);
        res = res | iter;
        i++;
        token = strtok(NULL, del);
    }
    return res;
}

void aggiungi(struct sottorete* elem) {
    struct sottorete* iter = testa;
    if (!iter || elem->total > iter->total) {
        elem->next = iter;
        testa = elem;
        return;
    }
    while (iter->next && iter->next->total > elem->total) {
        iter = iter->next;
    }
    elem->next = iter->next;
    iter->next = elem;
}

void pulisci (){
    struct sottorete * iter;
    while(testa && testa->next){
        iter = testa->next;
        free(testa);
        testa = iter;
    }
    if(testa) free(testa);
}

void clearInputBuffer() {
    int c;
    while ((c = getchar()) != '\n' && c != EOF);
}

int main(){
    char nome[16], buffer[64], pre_ip[16], pre_ip2[16];
    unsigned int num_ip, host, port, start, k, mask, args;
    struct sottorete * rete;

    printf("Inserisci l'indirizzo iniziale.\n");
    scanf("%s", pre_ip);
    num_ip = pton(pre_ip);
    start = num_ip;

    printf("Inserici le sottoreti come \"nome h i\", dove:\n\t>nome: nome rete.\n\t>h: numero host.\n\t>i: altri IP, come le interfacce di accesso o gli switch.\nScrivi \"done\" per terminare l'inserimento.\n");
    while(1){
        fgets(buffer, 64, stdin);
        args = sscanf(buffer, "%s %u %u", nome, &host, &port);
        if(!strcmp(nome, "done")) break;
        if(args != 3) continue;
        else {
            nome[15] = '\0';
            rete = (struct sottorete *) malloc (sizeof(struct sottorete));
            rete->total = host + port;
            strcpy((void*) rete->nome, nome);
            aggiungi(rete);
        }
    }
    rete = testa;
    printf("NOME\t\tMASK\tMASK DECIMALE\t\t[SUBNET     ,   BROADCAST]\t\tIND.RIMASTI\n");
    while(rete){
        k = 1;
        mask = 0x0002;
        while(1){
            if(mask >= (rete->total + 2)){
                printf("%s\t\t/%u\t", rete->nome, 32 - k);
                ntop(~(mask - 1), pre_ip);
                printf("%s\t\t", pre_ip);
                ntop(num_ip, pre_ip);
                ntop(num_ip + mask - 1, pre_ip2);
                printf("[%s , %s]\t\t", pre_ip, pre_ip2);
                printf("%u\n", mask - rete->total - 2);
                num_ip += mask;
                break;
            }
            k++;
            mask = mask << 1;
        }
        rete = rete->next;
    }
    k = 1;
    mask = 0x0002;
    while(1){
        if(mask >= num_ip - start - 1) break;
        k++;
        mask = mask << 1;
    }
    ntop(start + mask, pre_ip);
    ntop(start, pre_ip2);
    printf(">In totale e' richiesto un blocco di %u indirizzi (%s/%u).\n>Il primo indirizzo libero e' %s.\n", mask, pre_ip2, 32 - k, pre_ip);
    pulisci();
    printf("Calcolo terminato, premi un tasto per continuare.\n");
    getchar();
    return 0;
}