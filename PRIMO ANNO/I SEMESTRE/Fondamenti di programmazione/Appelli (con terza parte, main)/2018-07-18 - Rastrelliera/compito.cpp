#include "compito.h"

Rastrelliera::Rastrelliera(int ng, int nv, int nr, int nn)
{
    if (ng < 0) ng = 10;
    if (nv < 0) nv = 10;
    if (nr < 0) nr = 10;
    if (nn < 0) nn = 10;
    
    dischi[GIALLO-1] = ng;
    dischi[VERDE-1] = nv;
    dischi[ROSSO-1] = nr;
    dischi[NERO-1] = nn;
}

ostream& operator<<(ostream& o, const Rastrelliera& r)
{
    for (int i = 0; i < 4; i++)
    {
        switch(i+1)
        {
        case 1:
            o << "GIALLO\t<";
            break;
        case 2:
            o << "VERDE\t<";
            break;
        case 3:
            o << "ROSSO\t<";
            break;
        case 4:
            o << "NERO\t<";
            break;
        }
        o << r.dischi[i] << ">\t";
        for (int j = 0; j < r.dischi[i]; j++)
            o << "[] ";
        o << endl;
    }
    return o;
}

int* Rastrelliera::carica(int ng, int nv, int nr, int nn)
{
    if (ng < 0 || nv < 0 || nr < 0 || nn < 0)
        return NULL;

    if ( (ng > dischi[GIALLO-1]) || (nv > dischi[VERDE-1]) || (nr > dischi[ROSSO-1]) | (nn > dischi[NERO-1]) )
        return NULL;

    dischi[GIALLO-1] -= ng;
    dischi[VERDE-1] -= nv;
    dischi[ROSSO-1] -= nr;
    dischi[NERO-1] -= nn;
    int* b = new int[4];
    b[0] = ng;
    b[1] = nv;
    b[2] = nr;
    b[3] = nn;
    return b;
}

void Rastrelliera::scarica(int* b)
{
    if ( b == NULL )
        return;

    dischi[GIALLO-1] += b[GIALLO-1];
    dischi[VERDE-1] += b[VERDE-1];
    dischi[ROSSO-1] += b[ROSSO-1];
    dischi[NERO-1] += b[NERO-1];
    delete [] b;
}

int Rastrelliera::calcolaPeso(int* b)
{
    if ( b == NULL )
        return 0;

    return (GIALLO * b[0] + VERDE * b[1] + ROSSO * b[2] + NERO * b[3]);
}

int* Rastrelliera::unisci(int* b1, int* b2)
{
    if ( b1 == NULL || b2 == NULL )
        return NULL;

    int* b = new int[4];
    b[0] = b1[0] + b2[0];
    b[1] = b1[1] + b2[1];
    b[2] = b1[2] + b2[2];
    b[3] = b1[3] + b2[3];
    
    delete[] b1;
    delete[] b2;
    
    return b;
}

Rastrelliera& Rastrelliera::operator=(const Rastrelliera& r)
{
    dischi[GIALLO-1] = r.dischi[GIALLO-1];
    dischi[VERDE-1] = r.dischi[VERDE-1];
    dischi[ROSSO-1] = r.dischi[ROSSO-1];
    dischi[NERO-1] = r.dischi[NERO-1];
    return *this;
}
