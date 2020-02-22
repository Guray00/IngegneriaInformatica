#include "compito.h"
#include <cstring>    // strlen()

Scrabble::Scrabble(int n) {
    if (n < 4)
        n = 4;
    
    _dim = n;
    _tab = new char[_dim * _dim];
    
    // inizializzazione tabellone
    for (unsigned int r=0; r<_dim; r++)
        for (unsigned int c=0; c<_dim; c++)
            _tab[r*_dim+c] = '-';
}

Scrabble& Scrabble::operator=(const Scrabble& s) {
    if (this != &s) {  // controllo aliasing
        if (s._dim != _dim) {
            delete[] _tab;
            _dim = s._dim;
            _tab = new char[_dim * _dim];
        }
        
        for (unsigned int r=0; r<_dim; r++)
            for (unsigned int c=0; c<_dim; c++)
                _tab[r*_dim+c] = s._tab[r*_dim+c];
    }
    return *this;
}

bool Scrabble::aggiungi(const char* str, int r, int c, char dir) {
    // controllo bordi sinistro e superiore
    if (r < 0 || c < 0)
        return false;
    
    int len = strlen(str);

    // controllo bordo destro
    if (dir == 'O' && (r >= _dim || c+len > _dim))
        return false;
    
    // controllo bordo inferiore
    if (dir == 'V' && (r+len > _dim || c >= _dim))
        return false;
  
    // controllo che la parola possa essere inserita
    for (int k=0; k<len; k++) {
        if (dir == 'O') {
            if (_tab[r*_dim+(c+k)] != '-' && _tab[r*_dim+(c+k)] != str[k])
                return false;
        }
        else {
            if (_tab[(r+k)*_dim+c] != '-' && _tab[(r+k)*_dim+c] != str[k])
                return false;
        }
    }
    
    // inserisco la parola
    for (int k=0; k<len; k++) {
        if (dir == 'O')
            _tab[r*_dim+(c+k)] = str[k];
        else
            _tab[(r+k)*_dim+c] = str[k];
    }
    return true;
}

ostream& operator<<(ostream& os, const Scrabble& s) {
    for (unsigned int r=0; r<s._dim; r++) {
        for (unsigned int c=0; c<s._dim; c++) {
            os << s._tab[r*s._dim+c] << " ";
        }
        os << endl;
    }
    return os;
}

bool Scrabble::esiste(const char* str) const {
    int len = strlen(str);
    for (int r=0; r<_dim; r++) {
        for (int c=0; c<_dim; c++) {
            
            // controllo orizzontale
            if (c+len <= _dim) {
                bool trovata = true;
                for (int k=0; k<strlen(str); k++) {
                    if (_tab[r*_dim+(c+k)] != str[k]) {
                        trovata = false;
                        break;
                    }
                }
                if (trovata)
                    return true;
            }
            
            // controllo verticale
            if (r+len <= _dim) {
                bool trovata = true;
                for (int k=0; k<strlen(str); k++) {
                    if (_tab[(r+k)*_dim+c] != str[k]) {
                        trovata = false;
                        break;
                    }
                }
                if (trovata)
                    return true;
            }
        }
    }
    return false;
}

int Scrabble::operator!() const {
    int max=0;
    
    // cerco in orizzontale
    for (int r=0; r<_dim; r++) {
        int trovati=0;
        for (int c=0; c<_dim; c++) {
            if (_tab[r*_dim+c] == '-')
                trovati++;
            else {
                if (trovati > max)
                    max = trovati;
                trovati=0;
            }
        }
        if (trovati > max)
            max = trovati;
    }
    
    // cerco in verticale
    for (int c=0; c<_dim; c++) {
        int trovati=0;
        for (int r=0; r<_dim; r++) {
            if (_tab[r*_dim+c] == '-')
                trovati++;
            else {
                if (trovati > max)
                    max = trovati;
                trovati=0;
            }
        }
        if (trovati > max)
            max = trovati;
    }
    return max;
}

Scrabble::~Scrabble() {
    delete[] _tab;
}
