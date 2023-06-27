#include <iostream>
using namespace std;

class Supermercato {

    const static int NUM_CARRELLI = 5;

    struct prodotto{
        char* nome;
        int quantita;
        float prezzo_unitario;
        prodotto* next;
    };

    struct carrello{

        struct elemento_carrello{
            prodotto* merce;
            int quantita;
            elemento_carrello* next;
        };

        int cliente;
        elemento_carrello* contenuto;
    };

    prodotto* prodotti;
    carrello carrelli[NUM_CARRELLI];

    prodotto* cerca_prodotto(const char* nome_prodotto) const;
    static void aggiorna_prodotto(prodotto* p, int quantita, float prezzo_unitario);
    static prodotto* alloca_ed_inizializza_prodotto(const char* nome_prodotto, float prezzo_unitario,
                                                    prodotto* next);

    carrello* cerca_cliente(int codice_cliente);
    carrello* cerca_carrello_libero();
    static void occupa_carrello(int codice_cliente, carrello* carrello_libero);

    static carrello::elemento_carrello* alloca_ed_inizializza_elemento_carrello(prodotto* p, int quantita,
                                                                               carrello::elemento_carrello* next);
    static void prendi_prodotto(carrello::elemento_carrello*& carrello_cliente, prodotto* p, int quantita);

public:

    Supermercato();
    ~Supermercato();
    void crea_prodotto(const char* nome_prodotto, float prezzo_unitario);
    void esponi(const char* nome_prodotto, int quantita, float prezzo_unitario=0.0);
    friend ostream& operator<<(ostream& os, const Supermercato& s);
    Supermercato& operator+=(int codice_cliente);
    void metti_nel_carrello(int codice_cliente, const char* nome_prodotto, int quantita);
    float acquista(int codice_cliente);
};