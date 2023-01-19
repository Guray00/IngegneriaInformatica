# calcola x^y mod p 
# stampa ogni passaggio
# l'algoritmo esegue O(logy) moltiplicazioni, complessivamente è O(n^3)
def quadrature_successive(x: int, y: int, p: int):
    if p <= 0:
        print(f'ERRORE: non posso eseguire l\'algoritmo se p <= 0')
        return -1
    if y < 0:
        print(f'ERRORE: non posso eseguire l\'algoritmo se y < 0, mica mi hai preso per EE?! Lol.')
        return -1
    if y == 0:
        print(f'{x}**0 mod {p} = 1')
        return 1
    if x >= p: 
        print(f'riduco {x} in {x % p} facendo {x} mod {p}')
        x = x % p
        
    biny = bin(y)[::-1][:-2]
    
    print(f'{x}**1 mod {p} = {x}')
    xpower = [x]
    maxexp = len(biny) # ceil(log(y, 2)) ma meno pesante 
    
    for i in range(1, maxexp):
        new = pow(xpower[-1], 2, p)
        print(f'{x}**{2**(i)} mod {p} = ({x}**{2**(i-1)})**2 mod {p} = {xpower[-1]}**2 mod {p} = {new}')
        xpower.append(new)
            
    result = 1 
    
    str = f'{x}**{y} mod {p} = '
    for i, digit in enumerate(biny):
        if(digit == '1'): 
            result *= xpower[i]
            str += f'({x}**{2**i} mod {p})'

    print('------------------------------------------------')
    fin = result % p
    str += f' mod {p} = {fin}'
    print('\n' + str)

    return fin
    
x = 3
y = 55
p = 881

def main():
    print(f'calcolo {x}**{y} mod {p}...')
    
    output = quadrature_successive(x,y,p)
    
    if(output != -1): print(f'\n{x}**{y} mod {p} = {output}.')

if __name__ == "__main__":
   # stuff only to run when not called via 'import' here
   main()