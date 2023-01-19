import math 
import secrets
from quadrature_successive import quadrature_successive # è ESTREMAMENTE SCONSIGLIATO renderli verbose, se non non si capisce una minchia

# algoritmo di Miller-Rabin
# accetta un numero dispari N, dice se il numero N è primo con probabilità > 1-1/4^k
# è O(n^3) ove n = logN, quindi polinomiale (usa l'algoritmo delle quadrature successive)
def MR(N: int, k: int):
    if N % 2 == 0:
        return 'sicuramente composto (è divisibile per 2)'
    if(2+k > N-1):
        return 'ERRORE: valore di k troppo elevato rispetto ad N'
    
    w = 0
    z = N-1
    
    while z % 2 == 0:
        z //= 2
        w += 1 
        
    # print di debug 
    #print(2**w * z == N-1) # se torna True, vuoldire che w, z sono giusti 
    #print(f'w={w}')
    #print(f'z={z}')
    
    # pescaggio dei testimoni (randomizzato)
    ygen = [0, 1]
    for i in range(0, k):

        y = secrets.randbelow(N)
        while y in ygen:
            y = secrets.randbelow(N)

        ygen.append(y)

        #print(f'provo y = {y}')
        
        # predicato P1 
        if math.gcd(y, N) == 1: 
            # predicato P2 
            # è possibile usare il modulo "quadrature_successive" anzichè pow(), tanto pow() implementa l'algoritmo delle quadrature successive!
            # con quadrature_successive() è più lento 

            #if quadrature_successive(y, z, N) == -1 or quadrature_successive(y, z, N) == 1:
            if pow(y, z, N) == -1 or pow(y, z, N) == 1:
                continue 
            else:
                for i in range(0, w):
                    # attenzione a NON fare y ** ((2**i) * z) % N, poichè in quest'ultimo caso MOLTIPLICA y PER SÈ STESSO (2**i) * z VOLTE! SAREBBE ESPONENZIALE!
                    
                    #if quadrature_successive(y, (2**i) * z, N) == N-1:
                    if pow(y, (2**i) * z, N) == N-1:
                        break
                    #print(f'i={i}')
                else: 
                    return 'sicuramente composto (non rispetta P2)'
        else: 
            return 'sicuramente composto (non rispetta P1)'
    return f'primo con probabilità > {(1-(1/4)**k) * 100}%'
    
N = 113
k = 5 
    
def main():
    print(f'{N} è {MR(N, k)}')

if __name__ == "__main__":
   # stuff only to run when not called via 'import' here
   main()