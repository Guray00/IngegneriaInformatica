#include <ostream>
#include <cstring>
using namespace std;

class Battaglia{
  int *p;
  int m;
  int n;
  // funzioni private
  bool nonvalido(int);
public:
  Battaglia(int,int);
  bool aggiungi(int, int, int, int, int);
  bool fuoco(int, int);
  friend ostream & operator<<(ostream &, const Battaglia &);
  // SECONDA PARTE
  bool operator+=(const Battaglia &);     
  bool operator==(int);
  ~Battaglia(){delete []p;}
};