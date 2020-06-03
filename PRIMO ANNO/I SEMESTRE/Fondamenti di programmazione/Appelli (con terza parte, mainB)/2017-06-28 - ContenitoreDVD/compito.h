#include <iostream>
using namespace std;

struct elem {
   int genere; // 0: DVD vergine
	           // 1: DVD dati
		       // 2: DVD video
	elem *pun;
};
		
class ContenitoreDVD{
		elem *primo, *ultimo;
		int quanti[3];
		// quanti[0]: numero di DVD vergini
		// quanti[1]: numero di DVD dati
		// quanti[2]: numero di DVD video
		
		void inserisci(int);		
		int char2int(char g);
		
   public:
	    // PRIMA PARTE 18 pt
		ContenitoreDVD();	
		void aggiungi(){inserisci(0);}
		void aggiungi(char g){inserisci(char2int(g));}
		bool masterizza(char g);
		friend ostream & operator <<(ostream &, const ContenitoreDVD &);
		
		// SECONDA PARTE
		void elimina(int n=0); // 3pt
		int operator~(){return quanti[0];} //2pt
		int operator%(char g); // 2pt
		ContenitoreDVD(const ContenitoreDVD&); //3pt
		~ContenitoreDVD();     // 2pt
};
