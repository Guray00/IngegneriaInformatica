#include <iostream>
using namespace std;

class Portafoto{

    struct foto{
        int col;
        int pos;
        foto* ass;
        foto* next;
    };

    foto** supporto;
    int dim;

    //funzioni utilitÃ 
    static void incrementa_posizioni(foto*);
    static void decrementa_posizioni(foto*);
    void deassocia(const foto*);
    void dealloca();
    foto* get_foto(int, int) const;

    //Mascheramento costruttore di copia
    Portafoto(const Portafoto&);
public:

    explicit Portafoto(int);
    friend ostream& operator<<(ostream&, const Portafoto&);
    bool aggiungi(int, int);
    bool associa(int, int, int, int);
    bool elimina(int, int);
    Portafoto& operator=(const Portafoto&);
    ~Portafoto(){dealloca();};
};