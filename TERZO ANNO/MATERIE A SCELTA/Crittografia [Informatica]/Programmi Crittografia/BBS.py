from genera_numeri_primi import genera_numero_primo
import math
import secrets 

# p, q devono verificare questi requisiti
# ritorna False se si deve rigenerare p E q
def check(p: int, q: int, m: int, nbit: int, k: int):
    while(p % 4 != 3): 
        print("p non rispetta i requisiti, lo rigenero...")
        p = genera_numero_primo(nbit, k)

    while(q % 4 != 3): 
        print("q non rispetta i requisiti, lo rigenero...")
        q = genera_numero_primo(nbit, k)

    if math.gcd(2*math.ceil(q/4) + 1, 2*math.ceil(p/4) + 1) != 1: 
        print("La condizione brutta non è rispettata, devo rigenerare p, q...")
        return False 

    if p*q <= m: 
        print("Siccome m è maggiore di p * q, devo rigenerarli...")
        return False

# algoritmo BBS
# genera una sequenza casuale di m < n bit
# funziona per sequenze m < 2**nbit
def BBS(m: int): 
    nbit = 2048 # più è alto questo numero, più è lento ma più è sicuro (2048 è per renderlo crittograficamente sicuro)

    if m <= 0:
        print(f'ERRORE: scegliere come m un valore >= 0')
        return -1 

    if nbit < len(bin(m)):
        print(f'ERRORE: non posso calcolare una sequenza lunga m = {m} poichè è più lunga di {nbit} bit')
        return -1

    k = 5 # genera un numero primo con probabilità >99.9%

    print("Genero p...")
    p = genera_numero_primo(nbit//2, k)
    print("Genero q...")
    q = genera_numero_primo(nbit//2, k)

    # questo purtroppo è da fare, è molto pesante ma ah well
    while check(p,q, m, nbit//2, k) == False:
        p = genera_numero_primo(nbit//2, k)
        q = genera_numero_primo(nbit//2, k)

    print("Genero n...")
    n = p * q 

    #print(f'p = {p}')
    #print(f'q = {q}')
    #print(f'n = {n}')

    print("Genero y...")
    y = secrets.randbelow(n)
    while math.gcd(y, n) != 1:
        print("Ho generato un y non coprimo con n, ritento...")
        y = secrets.randbelow(n)

    #print(f'y = {y}')

    print("Calcolo il seme...")
    seme = pow(y, 2, n)

    #print(f'seme = {seme}')

    print("Genero la sequenza...")
    x = [seme]
    b = [str(seme % 2)]
    for i in range(1, m):
        xi = pow(x[-1], 2, n)
        #print(f'x[{i}] = {xi}')
        x.append(xi)
        b.append(str(x[i] % 2))
        #print(f'b[{i}] = {b[i]}')

    # inverto l'array
    b = b[::-1]

    return ''.join(b)

def main():
    n = 10000
    print(f'Genero una sequenza casuale di {n} bit, abbi pazienza...')
    print(f'Ecco la sequenza: {BBS(n)}')


if __name__ == "__main__":
   # stuff only to run when not called via 'import' here
   main()