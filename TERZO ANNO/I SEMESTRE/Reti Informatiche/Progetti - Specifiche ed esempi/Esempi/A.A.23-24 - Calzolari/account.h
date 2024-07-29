#ifndef ACCOUNT_H
#define ACCOUNT_H
#define online 1
#define offline 0
#include "tuttigli.h"


/* Account con login basilare costituito da email e password, organizzati in lista non ordinata */
struct Account{
    int id;
    char email[30];
    char passw[20];
    bool status;
    struct Account* next;
};


struct Account* new_account();
void del_account(struct Account**, struct Account*);
void ins_account(struct Account**, struct Account*);
struct Account* check_account(struct Account** lista, char* email, char* passw);
struct Account* check_account_solo_email(struct Account** lista, char* email);
void offline_account_by_id(struct Account **lista, int id);

#endif