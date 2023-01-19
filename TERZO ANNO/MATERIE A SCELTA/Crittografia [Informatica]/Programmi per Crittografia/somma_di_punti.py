import EE
import point

# calcola l'inverso moltiplicativo di a mod b 
# cioè risolve l'equazione x = a^-1 mod b
# a, b devono essere coprimi!
def inverso_moltiplicativo(a: int, b: int):
    gcdab, x, y = EE.EE(a, b)
    if gcdab != 1:
        print(f'ERRORE: non posso calcolare l\'inverso moltiplicativo di {a} mod {b} poichè {a} e {b} non sono coprimi!')
        return 0
    else: return x
    
# controlla che il punto P appartenga alla curva ellittica sui reali E(a,b)
# accetta anche il parametro opzionale p per le curve ellittiche prime 
def appartiene_alla_curva(P: point.point, a: int, b: int, p = -1):
    if P.is_punto_infinito(): return True

    cubica = P.x ** 3 + a * P.x + b 
    if p != -1: cubica = cubica % p 

    ysquared = P.y ** 2
    if p != -1: ysquared = ysquared % p
    
    if ysquared == cubica: 
        P.x %= p
        return True 
    return False 

# calcola S = P + Q 
# accetta due point.point e ritorna un point.point
# la somma la effettua in una curva ellittica sui reali E(a,b)
# accetta il parametro opzionale p per operazioni sulle curve elittiche prime
# dovrebbe fungere anche se il punto è il punto all'infinito
def somma_di_punti(P: point.point, Q: point.point, a: int, b: int, p = -1):
    if p < -1 or p == 0:
        print(f'ERRORE: non posso fare la somma con p negativo o uguale a zero!')
        return -1

    S = point.point()
    
    if appartiene_alla_curva(P, a, b, p) == False:
        print(f'ERRORE: il punto P = {P} non appartiene alla curva ellittica specificata!')
        return -1 
    
    if appartiene_alla_curva(Q, a, b, p) == False:
        print(f'ERRORE: il punto Q = {Q} non appartiene alla curva ellittica specificata!')
        return -1
    
    if Q.is_punto_infinito(): 
        return P 

    if P.is_punto_infinito():
        return Q

    # caso in cui P = -Q
    if p - P.y == Q.y: 
        return S

    if P.x == Q.x and P.y == Q.y: 
        if p != -1: lambdaa = ((3 * (P.x ** 2) + a) * inverso_moltiplicativo(2 * P.y, p)) % p
        else: lambdaa = (3 * (P.x ** 2) + a) / (2 * P.y)
    else: 
        if p != -1: lambdaa = ((Q.y - P.y) * inverso_moltiplicativo(Q.x - P.x, p)) % p 
        else: lambdaa = (Q.y - P.y) / (Q.x - P.x)
    
    print(f'lambda = {lambdaa}')

    S.x = lambdaa ** 2 - P.x - Q.x
    if p != -1: S.x = S.x % p
    print(f'S.x = ({lambdaa})**2 - ({P.x}) - ({Q.x}) = {S.x}')
    
    S.y = -Q.y + lambdaa * (Q.x - S.x)
    if p != -1: S.y = S.y % p
    print(f'S.y = - ({Q.y}) + {lambdaa}({Q.x} - {S.x}) = {S.y}')
    
    return S 

P = point.point(1, 2)
Q = point.point(29,17)
a = 14
b = 12
p = 23

def main():
    S = somma_di_punti(P, Q, a, b, p)
    print(f'\nS = {S}')

if __name__ == "__main__":
   # stuff only to run when not called via 'import' here
   main()
