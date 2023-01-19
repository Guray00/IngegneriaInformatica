# risolve l'identità di Bézout ax + by = gcd(a,b) 
# ritorna gcd(a,b), x, y
def EE(a: int, b: int):
    if b == 0: 
        print([a,1,0])
        return [a,1,0]

    print(f'EE({b}, {a % b})')
    d_, x_, y_ = EE(b, a % b)
    
    dxy = [d_, y_, x_ - a//b * y_]
    print(dxy)
    return dxy 
    
a = 3
b = 7

# si usa anche per risolvere x = a^-1 mod b, ove a e b sono coprimi 
# il secondo parametro che torna EE è l'inverso, poichè
# x: ax equiv 1 mod b --> ax = bz + 1 ---> ax - bz = 1 ---> ax + by = 1 = gcd(a,b) (posto -z = y)  
# quindi il secondo parametro di EE torna l'inverso moltiplicativo
# l'algoritmo EE è in totale O(n^3) ove n è la dimensione dell'istanza di input (come Euclide)

def main():
    print(f'calcolo {a}x + {b}y = gcd(a, b)...')
    print(f'EE({a}, {b})')
    res = EE(a,b)
    print(f'\ngcd({a},{b}) = {res[0]}')
    print(f'x = {res[1]} (se a, b sono coprimi, questo valore indica a^-1 mod b)')
    print(f'y = {res[2]}\n')
    print(f'3({res[1]}) + 55({res[2]}) = {res[0]}')

if __name__ == "__main__":
   # stuff only to run when not called via 'import' here
   main()
