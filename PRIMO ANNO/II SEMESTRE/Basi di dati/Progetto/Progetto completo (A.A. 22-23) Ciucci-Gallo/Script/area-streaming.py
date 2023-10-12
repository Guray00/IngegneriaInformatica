import random
from math import floor
import sys
   

def generate_single_server():
    max_connessioni = random.randint(5000, 25000)
    banda = random.uniform(100000, 256000)
    mtu = random.randint(576, 4464)
    lat = random.uniform(-90.0, 90.0)
    lon = random.uniform(-180.0, 180.0)
    return '(' + str(max_connessioni) + ', ' + str(banda) + ', ' + str(mtu) + ', POINT(' + str(lon) + ', ' + str(lat) + ')),\n'

def generate():
    server_number = 20
    
    
    file_out = open('area-streaming.sql', 'w')
    
    file_out.write('INSERT INTO `Server` (`MaxConnessioni`, `LunghezzaBanda`, `MTU`, `Posizione`) VALUES\n')
    
    for i in range(0, server_number):
        line = generate_single_server()
        if server_number == i + 1:
            line = line[:-2] + ';\n'
        file_out.write(line)
    file_out.write('\n')


    file_out.write('\nCALL `RandPoP`();\nCALL `RandPoP`();\n')
    file_out.write('\nCALL `AggiungiErogazioni`();\n')
    
    

if __name__ == '__main__':
    generate()