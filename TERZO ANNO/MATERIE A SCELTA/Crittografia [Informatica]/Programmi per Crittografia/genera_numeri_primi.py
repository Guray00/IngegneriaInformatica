import secrets # cryptographically secure pseudonumeber generator
#import random # questo generatore non è crittograficamente sicuro, quindi usare a vostra discrezione (richiede di dover usare random.seed())
import MR


# genera un numero primo di n bit dichiarato primo con probabilità >1-(1/4)^k
# l'algoritmo è O(n^4)
def genera_numero_primo(n: int, k: int):
    #random.seed() # not the best
    N = str(bin(secrets.randbits(n-2)))
    
    #print(N)
    N = int('1' + N[2:] + '1', base=2)
    #print(f'ho generato {N}, testo se sia primo')
    
    while 'composto' in MR.MR(N, k): 
        #print(f'{N} non è primo, incremento di 2')
        N += 2
    return N 

n = 1024
k = 5

def main():
    print(f"Genero un numero primo di {n} bit...")
    primo = genera_numero_primo(n, k)
    print(f'Ecco il numero dichiarato primo: {primo} con probabilità > {(1-(1/4)**k) * 100}%')

if __name__ == "__main__":
   # stuff only to run when not called via 'import' here
   main()