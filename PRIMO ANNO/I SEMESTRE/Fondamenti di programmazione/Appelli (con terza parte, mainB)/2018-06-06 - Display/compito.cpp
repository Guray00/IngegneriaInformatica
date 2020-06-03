#include "compito.h"
#include <cstring>

Display::Display(int L, int C)
{
    if (L < 1 || C < 1)
    {
        L = 5;
        C = 8;
    }
    
    lin = L;
    col = C;
    
    dis = new char*[lin];
    for(int i = 0; i < lin; i++)
    {
        dis[i] = new char[col + 1];  // + 1 per carattere di fine stringa
        dis[i][0] = '\0';            // inizialmente, tutte le linee sono vuote
    }
    
    cur = 0;
}


Display::Display(const Display& d)
{
    lin = d.lin;
    col = d.col;
    cur = d.cur;
    
    // alloca nuova memoria per il display
    dis = new char*[lin];
    
    for (int i = 0; i < lin; i++)
    {
        dis[i] = new char[col + 1];
        strcpy(dis[i], d.dis[i]);
    }
}

ostream& operator<<(ostream& os, const Display& d)
{
    for (int i = 0; i < d.lin; i++)
    {
        os << "[" << i+1 << (i == d.cur? '>': ']') << d.dis[i] << endl;
    }
    return os;
}

void Display::writeT(const char* str)
{
    if (str == NULL || strlen(str) == 0)
        return;
    
    int i = 0;
    int j = 0;
    
    // scrivi un carattere per volta nella linea corrente
    while ( (str[i] != '\0') && (j < col) )
    {
        dis[cur][j] = str[i];
        i++;
        j++;
    }
    // inserisci il carattere di fine stringa
    dis[cur][j] = '\0';
    
    // posiziona il cursore sulla prossima linea
    cur = (cur + 1) % lin;
}

void Display::writeW(const char* str)
{
    if (str == NULL || strlen(str) == 0)
        return;
        
    int i = 0;

    bool finito = false;
    while (!finito)
    {
        int j = 0;
        while ( (str[i] != '\0') && (j < col) )
        {
            dis[cur][j] = str[i];
            i++;
            j++;
        }
        // inserisci il carattere di fine stringa
        dis[cur][j] = '\0';
        
        // posiziona il cursore sulla prossima linea
        cur = (cur + 1) % lin;
        
        // se la stringa e' stata scritta completamente, termina
        if ( str[i] == '\0')
            finito = true;
    }
}

Display& Display::operator=(const Display& d)
{
    if (this != &d) // anti-aliasing
    {
        // dealloca il display esistente
        for (int i = 0; i < lin; i++)
            delete [] dis[i];
        delete [] dis;
        
        lin = d.lin;
        col = d.col;
        cur = d.cur;
        
        // alloca nuova memoria per il display
        dis = new char*[lin];
        for (int i = 0; i < lin; i++)
        {
            dis[i] = new char[col + 1];
            strcpy(dis[i], d.dis[i]);
        }
    }
    return *this;
}

Display::~Display()
{
    for (int i = 0; i < lin; i++)
        delete [] dis[i];
    delete [] dis;
}


