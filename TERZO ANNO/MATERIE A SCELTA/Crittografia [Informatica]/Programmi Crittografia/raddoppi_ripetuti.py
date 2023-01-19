import somma_di_punti
import point 

# calcola Q = kP ove P appartiene alla curva ellittica prima Ep(a,b)
def raddoppi_ripetuti(P: point.point, k: int, a: int, b: int, p: int):
    if k <= 0:
        print(f'ERRORE: non posso fare i raddoppi se k <= 0')
        return -1

    if p <= 0:
        print(f'ERRORE: non posso fare i raddoppi se p <= 0')
        return -1
    
    if somma_di_punti.appartiene_alla_curva(P, a, b, p) == False:
        print(f'ERRORE: il punto P = {P} non appartiene alla curva ellittica specificata!')
        return -1 

    bink = bin(k)[::-1][:-2]
    maxk = len(bink) # ceil(log(k, 2)) ma meno pesante 
    points = [P]

    for i in range(1, maxk):
        new = somma_di_punti.somma_di_punti(points[-1], points[-1], a, b, p)
        print(f'{2**i}P = {new}')
        points.append(new)        

    str = f'{k}P = '
    result = -1
    for i, digit in enumerate(bink):
        if(digit == '1'): 
            if result == -1: result = points[i]
            else: result = somma_di_punti.somma_di_punti(result, points[i], a, b, p)

            str += f'{2**i}P + '

    str = str[:-2] + f'= {result}'
    print(str)
    return result

P = point.point(1, 2)
a = 14
b = 12
p = 23

def main():
    raddoppi_ripetuti(P, 11, a, b, p)


if __name__ == "__main__":
   # stuff only to run when not called via 'import' here
   main()