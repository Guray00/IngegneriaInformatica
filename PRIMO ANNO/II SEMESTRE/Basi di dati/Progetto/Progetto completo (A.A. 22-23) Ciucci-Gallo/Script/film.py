import random
import sys
from math import floor
import os

case_prod = [
    'Cartoon One',
    'Cemofilm',
    'Cinecittà',
    'Colonna',
    'Cristaldifilm',
    'Mad Entertainment',
    'Maga Animation Studio',
    'Mari Film',
    'Medusa Film',
    'Mikado Film',
    'Milano Films',
    'Minerva Film',
    'Mood Film',
    'Morgana film',
    'Moviemax',
    'Leone Film',
    'Latium Film ',
    'Lucky Red',
    'Fandango',
    'Warner',
]
        
artisti = [
    ('Vincenzino', 'Fiore', 8.43),
    ('Fernando', 'De Simone', 3.79),
    ('Sara', 'Scognamiglio', 8.84),
    ('Giulio', 'Esposito', 9.12),
    ('Luca', 'Zannelli', 2.1),
    ('Luca', 'Fiore', 3.15),
    ('Loris', 'Zannelli', 5.55),
    ('Sara', 'Della Valle', 2.33),
    ('Jasmine', 'Gallo', 4.48),
    ('Giada', 'Della Valle', 7.67),
    ('Giacomo', 'Rossi', 1.66),
    ('Gianmarco', 'Fabbricatore', 0.58),
    ('Pasquale', 'Fabbricatore', 6.24),
    ('Jacopo', 'Fabbricatore', 2.88),
    ('Antonio', 'Scognamiglio', 5.84),
    ('Alessio', 'Gallo', 7.21),
    ('Lorenzo', 'Fiore', 6.48),
    ('Costanza', 'Gallo', 3.68),
    ('Lorenza', 'Fiore', 8.0),
    ('Diego', 'Scognamiglio', 8.32),
    ('Tom', 'Rossi', 1.28),
    ('Tom', 'Fabbricatore', 7.18),
    ('Vincenzino', 'Esposito', 9.05),
    ('Lorenzo', 'Zannelli', 1.65),
    ('Alessio', 'Zannelli', 3.09),
    ('Jasmine', 'Zannelli', 2.87),
    ('Boris', 'Esposito', 7.47),
    ('Giulio', 'Fabbricatore', 5.01),
    ('Giacomo', 'Zannelli', 0.16),
    ('Carmen', 'Zannelli', 6.18),
    ('Alessio', 'Fabbricatore', 9.97),
    ('Guido', 'Bianchi', 6.92),
    ('Costanza', 'Esposito', 0.48),
    ('Gabriele', 'Fabbricatore', 7.66),
    ('Guido', 'Fabbricatore', 4.18),
    ('Gabriele', 'Rossi', 0.17),
    ('Simone', 'Bianchi', 4.17),
    ('Letizia', 'De Simone', 2.74),
    ('Lorenza', 'Bianchi', 3.58),
    ('Michele', 'Fiore', 2.78),
    ('Giacomo', 'Fabbricatore', 8.53),
    ('Jasmine', 'Esposito', 3.13),
    ('Yarov', 'Gallo', 7.84),
    ('Lorenzo', 'De Simone', 1.92),
    ('Lorenza', 'Della Valle', 1.56),
    ('Costanza', 'Della Valle', 4.96),
    ('Antonino', 'Rossi', 1.19),
    ('Diego', 'Della Valle', 9.53),
    ('Michele', 'Scognamiglio', 5.84),
    ('Carmen', 'Bianchi', 4.71),
    ('Michele', 'Fabbricatore', 3.89),
    ('Antonio', 'De Simone', 7.3),
    ('Christian', 'Zannelli', 6.62),
    ('Gabriele', 'Della Valle', 0.8),
    ('Luca', 'Esposito', 1.96),
    ('Giuseppe', 'Della Valle', 7.42),
    ('Federico', 'Gallo', 6.31),
    ('Tom', 'Bianchi', 2.32),
    ('John', 'Gallo', 0.77),
    ('Letizia', 'Scognamiglio', 1.17),
    ('Fernando', 'Zannelli', 1.51),
    ('Costanza', 'Fiore', 7.72),
    ('Jim', 'De Simone', 7.34),
    ('Riccardo', 'Scognamiglio', 9.54),
    ('John', 'De Simone', 7.01),
    ('Antonio', 'Della Valle', 2.88),
    ('Giuseppe', 'De Simone', 8.93),
    ('Gabriele', 'Gallo', 4.05),
    ('Yarov', 'Fiore', 5.57),
    ('Lorenzo', 'Della Valle', 5.16),
    ('Diego', 'Fabbricatore', 4.21),
    ('Gabriele', 'Gallo', 0.54),
    ('Vincenzo', 'Fabbricatore', 2.8),
    ('Boris', 'De Simone', 2.62),
    ('Federico', 'Della Valle', 7.03),
    ('Jacopo', 'Zannelli', 1.38),
    ('Luca', 'Fabbricatore', 7.64),
    ('Federico', 'Fiore', 6.48),
    ('Gabriele', 'Zannelli', 0.7),
    ('Giulio', 'Scognamiglio', 3.61),
    ('Riccardo', 'Esposito', 5.0),
    ('Lorenza', 'Zannelli', 4.08),
    ('Carmen', 'De Simone', 0.04),
    ('Gianmarco', 'Fiore', 6.2),
    ('Fernando', 'Esposito', 4.05),
    ('Letizia', 'Bianchi', 4.67),
    ('Costanza', 'Bianchi', 8.02),
    ('Pasquale', 'Zannelli', 6.6),
    ('Vincenzo', 'De Simone', 0.55),
    ('Simone', 'Zannelli', 4.92),
    ('Simone', 'Della Valle', 4.6),
    ('Loris', 'Fabbricatore', 7.9),
    ('Marcello', 'De Simone', 3.13),
    ('Sara', 'Rossi', 0.16),
    ('Guido', 'Della Valle', 7.73),
    ('Jim', 'Scognamiglio', 3.51),
    ('Jim', 'Esposito', 4.55),
    ('Michele', 'Esposito', 2.15),
    ('Gianmarco', 'Bianchi', 0.42),
    ('Antonino', 'Scognamiglio', 2.02),
    ('Alessandro', 'Gallo', 6.25),
    ('Carmen', 'Della Valle', 2.48),
    ('Diego', 'Rossi', 9.82),
    ('Christian', 'Scognamiglio', 4.88),
    ('Gabriele', 'Della Valle', 9.38),
    ('Marcello', 'Gallo', 8.33),
    ('Sara', 'Zannelli', 5.61),
    ('Giulia', 'Esposito', 0.93),
    ('Giacomo', 'De Simone', 9.3),
    ('Pasquale', 'Della Valle', 6.68),
    ('Vincenzo', 'Della Valle', 3.69),
    ('Jacopo', 'Esposito', 5.81),
    ('Pasquale', 'Fiore', 2.18),
    ('Fernando', 'Gallo', 3.4),
    ('Giuseppe', 'Rossi', 8.36),
    ('Tom', 'Gallo', 4.11),
    ('Lorenzo', 'Bianchi', 5.5),
    ('Giada', 'Gallo', 6.41),
    ('Michele', 'Zannelli', 2.32),
    ('Carmen', 'Fiore', 4.09),
    ('Michele', 'De Simone', 4.26),
    ('Boris', 'Gallo', 0.67),
    ('Alessio', 'Rossi', 3.61),
    ('Imma', 'Della Valle', 3.53),
    ('Alessandro', 'Esposito', 9.12),
    ('Pasquale', 'De Simone', 7.77),
    ('Antonino', 'Esposito', 3.31),
    ('Jim', 'Fabbricatore', 2.43),
    ('Christian', 'Della Valle', 2.47),
    ('Simone', 'Fabbricatore', 1.59),
    ('Giulio', 'Rossi', 0.45),
    ('Federico', 'De Simone', 4.81),
    ('Pasquale', 'Rossi', 5.04),
    ('Michele', 'Gallo', 5.57),
    ('Luca', 'Scognamiglio', 5.88),
    ('Antonino', 'Della Valle', 7.2),
    ('Lorenzo', 'Rossi', 2.36),
    ('Giulia', 'Bianchi', 3.97),
    ('John', 'Fiore', 4.14),
    ('Giuseppe', 'Esposito', 6.11),
    ('Tom', 'Fiore', 8.05),
    ('Vincenzino', 'Gallo', 0.49),
    ('Giada', 'Fiore', 7.5),
    ('Giulia', 'Fiore', 4.0),
    ('Loris', 'Rossi', 4.35),
    ('Riccardo', 'Zannelli', 2.6),
    ('Letizia', 'Zannelli', 4.38),
    ('Diego', 'Bianchi', 7.27),
    ('Sara', 'Bianchi', 7.33),
    ('Antonio', 'Gallo', 6.18),
    ('Gabriele', 'Fiore', 1.57),
    ('Jacopo', 'De Simone', 0.63),
    ('Guido', 'Scognamiglio', 0.26),
    ('Pasquale', 'Esposito', 0.85),
    ('Giuseppe', 'Zannelli', 4.6),
    ('Lorenza', 'Scognamiglio', 1.36),
    ('Letizia', 'Fiore', 5.7),
    ('Vincenzino', 'Fabbricatore', 2.7),
    ('Jacopo', 'Bianchi', 4.85),
    ('Alessandro', 'Scognamiglio', 1.29),
    ('Jasmine', 'De Simone', 2.0),
    ('Marcello', 'Bianchi', 0.44),
    ('Giacomo', 'Esposito', 3.53),
    ('Giada', 'Bianchi', 1.34),
    ('Antonino', 'Fabbricatore', 2.12),
    ('Gianmarco', 'De Simone', 7.2),
    ('Alessandro', 'Della Valle', 7.63),
    ('Sara', 'De Simone', 6.15),
    ('Riccardo', 'Fiore', 2.34),
    ('Marcello', 'Fiore', 9.86),
    ('Giulia', 'Della Valle', 1.09),
    ('Jim', 'Bianchi', 0.4),
    ('Giulia', 'Rossi', 3.18),
    ('Marcello', 'Esposito', 4.74),
    ('Jim', 'Fiore', 6.19),
    ('Alessio', 'Bianchi', 5.99),
    ('John', 'Bianchi', 4.92),
    ('Jasmine', 'Scognamiglio', 5.41),
    ('Luca', 'De Simone', 2.74),
    ('Christian', 'De Simone', 5.86),
    ('Boris', 'Bianchi', 1.86),
    ('Giacomo', 'Della Valle', 8.7),
    ('Gabriele', 'De Simone', 0.67),
    ('Fernando', 'Fabbricatore', 0.3),
    ('Antonino', 'Gallo', 7.79),
    ('Tom', 'De Simone', 7.81),
    ('Jacopo', 'Rossi', 2.11),
    ('Tom', 'Esposito', 1.63),
    ('Alessio', 'Esposito', 3.87),
    ('Loris', 'De Simone', 1.11),
    ('Costanza', 'Fabbricatore', 7.55),
    ('Christian', 'Fabbricatore', 3.98),
    ('Loris', 'Bianchi', 9.78),
    ('Guido', 'Rossi', 2.88),
    ('Federico', 'Rossi', 0.47),
    ('Marcello', 'Zannelli', 9.73),
    ('Federico', 'Zannelli', 5.72),
    ('Alessandro', 'Fiore', 4.37),
    ('Carmen', 'Fabbricatore', 7.43),
    ('Jasmine', 'Bianchi', 0.02),
    ('Antonio', 'Esposito', 3.56),
    ('Antonino', 'Fiore', 6.84),
    ('Giulio', 'Bianchi', 1.65),
    ('John', 'Rossi', 5.03),
    ('Lorenza', 'Esposito', 1.54),
    ('Jacopo', 'Della Valle', 8.45),
    ('Luca', 'Della Valle', 3.33),
    ('Simone', 'De Simone', 8.77),
    ('Vincenzo', 'Fiore', 7.39),
    ('Simone', 'Gallo', 8.55),
    ('Yarov', 'Zannelli', 8.95),
    ('Carmen', 'Gallo', 9.84),
    ('John', 'Esposito', 9.34),
    ('Vincenzo', 'Gallo', 9.52),
    ('Jacopo', 'Fiore', 5.72),
    ('Antonio', 'Bianchi', 9.0),
    ('Loris', 'Esposito', 7.96),
    ('Michele', 'Bianchi', 5.62),
    ('Boris', 'Zannelli', 4.29),
    ('Carmen', 'Esposito', 5.5),
    ('Gabriele', 'Scognamiglio', 7.8),
    ('Luca', 'Gallo', 5.71),
    ('Federico', 'Bianchi', 5.59),
    ('Alessio', 'De Simone', 2.44),
    ('Fernando', 'Della Valle', 6.57),
    ('Letizia', 'Esposito', 7.6),
    ('Giada', 'Zannelli', 2.7),
    ('Diego', 'De Simone', 0.4),
    ('Sara', 'Fiore', 0.29),
    ('Riccardo', 'Della Valle', 2.71),
    ('Simone', 'Esposito', 4.98),
    ('Vincenzino', 'Bianchi', 4.73),
    ('Loris', 'Scognamiglio', 6.25),
    ('Gabriele', 'Fabbricatore', 2.02),
    ('Vincenzo', 'Bianchi', 9.29),
    ('Federico', 'Fabbricatore', 2.42),
    ('Federico', 'Scognamiglio', 9.12),
    ('Christian', 'Bianchi', 7.59),
    ('Antonino', 'De Simone', 4.27),
    ('Imma', 'Fiore', 6.48),
    ('Riccardo', 'Rossi', 0.07),
    ('Riccardo', 'Gallo', 0.27),
    ('Vincenzo', 'Rossi', 5.44),
    ('Christian', 'Rossi', 4.04),
    ('Giulio', 'Zannelli', 5.76),
    ('Lorenzo', 'Gallo', 1.6),
    ('Marcello', 'Rossi', 4.5),
    ('Simone', 'Fiore', 3.63),
    ('Guido', 'Gallo', 2.39),
    ('Loris', 'Gallo', 0.39),
    ('Costanza', 'Scognamiglio', 2.95),
    ('Lorenzo', 'Esposito', 9.2),
    ('Vincenzino', 'Rossi', 3.61),
    ('Alessio', 'Scognamiglio', 6.36),
    ('Diego', 'Zannelli', 5.63),
    ('Riccardo', 'Bianchi', 5.67),
    ('Letizia', 'Della Valle', 8.4),
    ('Vincenzino', 'Della Valle', 4.38),
    ('Pasquale', 'Gallo', 2.64),
    ('Luca', 'Rossi', 1.86),
    ('Giada', 'Scognamiglio', 8.54),
    ('Giulio', 'Gallo', 2.2),
    ('Gianmarco', 'Zannelli', 0.8),
    ('Jacopo', 'Scognamiglio', 1.57),
    ('Giuseppe', 'Scognamiglio', 8.08),
    ('Imma', 'Bianchi', 4.76),
    ('Letizia', 'Fabbricatore', 0.3),
    ('Vincenzo', 'Zannelli', 7.94),
    ('Vincenzo', 'Esposito', 8.8),
    ('Alessio', 'Fiore', 6.08),
    ('Christian', 'Fiore', 0.4),
    ('Gabriele', 'Bianchi', 5.29),
    ('Giacomo', 'Bianchi', 0.1),
    ('Costanza', 'De Simone', 5.95),
    ('Fernando', 'Rossi', 3.53),
    ('John', 'Della Valle', 2.88),
    ('Giada', 'De Simone', 4.52),
    ('Jasmine', 'Della Valle', 6.37),
    ('Lorenza', 'Rossi', 4.0),
    ('Lorenzo', 'Scognamiglio', 2.74),
    ('Guido', 'Zannelli', 0.29),
    ('Jasmine', 'Fabbricatore', 8.93),
    ('Diego', 'Gallo', 3.46),
    ('Giuseppe', 'Gallo', 4.38),
    ('Jim', 'Gallo', 3.5),
    ('Jasmine', 'Rossi', 1.15),
    ('Jim', 'Zannelli', 4.48),
    ('Marcello', 'Della Valle', 1.29),
    ('Vincenzo', 'Scognamiglio', 1.95),
    ('Imma', 'Scognamiglio', 7.6),
    ('Sara', 'Gallo', 1.04),
    ('Guido', 'Esposito', 3.13),
    ('Letizia', 'Gallo', 4.43),
    ('Costanza', 'Zannelli', 1.47),
    ('Loris', 'Fiore', 8.9),
    ('Giacomo', 'Gallo', 2.16),
    ('Vincenzino', 'Zannelli', 5.22),
    ('Antonio', 'Fiore', 6.0),
    ('Antonino', 'Bianchi', 3.91),
    ('Giulio', 'Fiore', 2.29),
    ('Simone', 'Scognamiglio', 2.9),
    ('Loris', 'Della Valle', 4.66),
    ('Giuseppe', 'Fabbricatore', 5.93),
    ('Luca', 'Bianchi', 2.94),
    ('Riccardo', 'De Simone', 9.96),
    ('Imma', 'Fabbricatore', 3.87),
    ('Gabriele', 'Bianchi', 6.95),
    ('Gianmarco', 'Esposito', 6.18),
    ('Yarov', 'Bianchi', 3.17),
    ('Gabriele', 'Rossi', 5.26),
    ('Imma', 'Zannelli', 9.68),
    ('Giacomo', 'Fiore', 2.27),
    ('Tom', 'Della Valle', 6.64),
    ('Yarov', 'Scognamiglio', 5.37),
    ('Fernando', 'Scognamiglio', 2.75),
    ('Tom', 'Zannelli', 6.48),
    ('Vincenzino', 'Scognamiglio', 6.59),
    ('Carmen', 'Rossi', 4.86),
    ('Giulio', 'De Simone', 5.99),
    ('Gabriele', 'Esposito', 0.83),
    ('Jim', 'Della Valle', 0.73),
    ('Diego', 'Esposito', 4.15),
    ('Antonio', 'Rossi', 3.47),
    ('Marcello', 'Scognamiglio', 1.24),
    ('Lorenza', 'Gallo', 8.32),
    ('Gabriele', 'De Simone', 0.81),
    ('Boris', 'Scognamiglio', 7.19),
    ('Tom', 'Scognamiglio', 0.24),
    ('Gianmarco', 'Rossi', 9.96),
    ('Yarov', 'De Simone', 8.62),
    ('Alessio', 'Della Valle', 5.76),
    ('Antonio', 'Zannelli', 8.6),
    ('Gabriele', 'Scognamiglio', 6.99),
    ('Antonino', 'Zannelli', 4.33),
    ('Yarov', 'Fabbricatore', 7.26),
    ('Federico', 'Esposito', 9.86),
    ('Imma', 'Esposito', 6.16),
    ('John', 'Fabbricatore', 8.67),
    ('Lorenza', 'Fabbricatore', 7.71),
    ('Imma', 'Gallo', 0.73),
    ('Vincenzino', 'De Simone', 3.58),
    ('Giulia', 'Zannelli', 5.77),
    ('Lorenza', 'De Simone', 1.96),
    ('Giada', 'Esposito', 1.3),
    ('Jim', 'Rossi', 0.95),
    ('Alessandro', 'Fabbricatore', 0.34),
    ('Pasquale', 'Bianchi', 6.8),
    ('Boris', 'Fabbricatore', 1.66),
    ('Alessandro', 'Bianchi', 4.61),
    ('Sara', 'Esposito', 0.72),
    ('Giacomo', 'Scognamiglio', 9.95),
    ('Yarov', 'Esposito', 7.57),
    ('Jacopo', 'Gallo', 4.24),
    ('Alessandro', 'Rossi', 8.51),
    ('Yarov', 'Della Valle', 2.86),
    ('Michele', 'Rossi', 5.23),
    ('Guido', 'Fiore', 5.46),
    ('Boris', 'Della Valle', 3.44),
    ('Fernando', 'Fiore', 4.85),
    ('Boris', 'Fiore', 0.06),
    ('Imma', 'Rossi', 4.86),
    ('John', 'Scognamiglio', 7.1),
    ('Riccardo', 'Fabbricatore', 2.01),
    ('Gabriele', 'Zannelli', 4.59),
    ('Gianmarco', 'Scognamiglio', 0.52),
    ('Fernando', 'Bianchi', 7.02),
    ('Letizia', 'Rossi', 0.49),
    ('Christian', 'Esposito', 5.08),
    ('Giulia', 'Gallo', 9.78),
    ('Marcello', 'Fabbricatore', 3.21),
    ('Gabriele', 'Fiore', 4.82),
    ('Simone', 'Rossi', 1.05),
    ('Lorenzo', 'Fabbricatore', 1.76),
    ('Diego', 'Fiore', 0.36),
    ('Giuseppe', 'Bianchi', 6.61),
    ('Sara', 'Fabbricatore', 1.99),
    ('Giada', 'Rossi', 1.88),
    ('Michele', 'Della Valle', 4.44),
    ('Pasquale', 'Scognamiglio', 2.36),
    ('Alessandro', 'Zannelli', 9.05),
    ('Giada', 'Fabbricatore', 3.85),
    ('Giulio', 'Della Valle', 7.38),
    ('Giulia', 'De Simone', 9.67),
    ('Giulia', 'Scognamiglio', 4.94),
    ('Giulia', 'Fabbricatore', 7.84),
    ('Boris', 'Rossi', 0.91),
    ('Jasmine', 'Fiore', 4.64),
    ('Alessandro', 'De Simone', 7.93),
    ('Costanza', 'Rossi', 1.2),
    ('Carmen', 'Scognamiglio', 4.68),
    ('Imma', 'De Simone', 2.12),
    ('Christian', 'Gallo', 9.53),
    ('Guido', 'De Simone', 1.12),
    ('Gianmarco', 'Della Valle', 6.35),
    ('Antonio', 'Fabbricatore', 7.19),
    ('Gianmarco', 'Gallo', 2.91),
    ('Gabriele', 'Esposito', 2.42),
    ('Yarov', 'Rossi', 9.74),
    ('John', 'Zannelli', 3.55),
    ('Giuseppe', 'Fiore', 9.14)
]

premi = [
    ('Academy Award (Oscar)', 'Al miglior attore', 'attore1'),
    ('Academy Award (Oscar)', 'Al miglior attore non protagonista', 'attore2'),
    ('Academy Award (Oscar)', 'Al miglior Film', 'nessuno'),
    ('Academy Award (Oscar)', 'Alla miglior regia', 'regista'),

    ('Leone d\\\'oro', 'Al miglior Film', 'nessuno'),

    ('David di Donatello', 'Al miglior Film', 'nessuno'),
    ('David di Donatello', 'Alla miglior regia', 'regista'),
    ('David di Donatello', 'Al miglior attore protagonista', 'attore1'),
    ('David di Donatello', 'Al miglior attore non protagonista', 'attore2')
]


def next_line(file, rec=0):
    if rec > 5:
        raise Exception('Problema in lettura file!')
    try:
        line = file.readline()
    except:
        return next_line(file=file, rec=rec + 1)
    if not line:
        file.seek(0)
        return next_line(file=file, rec=rec)
    return str(line).replace('\r', '').replace('\n', '').replace('\t', '')

premi_vinti = []

def premio_vinto(premio, anno):
    for p in premi_vinti:
        if p[0] == premio[0] and p[1] == premio[1] and p[2] == anno:
            return True
    return False

def generate_film(ID, film):
    global premi_vinti
    
    # Dati estratti dal File
    line = next_line(file=film).split(',')
    excludedIndices = [0, len(line) - 1]
    desc = [x for i, x in enumerate(line) if i not in excludedIndices]
    titolo = line[0].strip().replace('\\', '\\\\').replace('\'', '\\\'') + ' ' + str(random.randint(1, 6))
    descrizione = "".join(desc).strip()[1:-1].replace('\\', '\\\\').replace('\'', '\\\'')
    anno = min(int(line[-1].strip()) + random.randint(0, 4), 2020)
    
    # Dati sorteggiati
    casa_prod = random.choice(case_prod)
    regista = random.choice(artisti)
    attore_p = random.choice(artisti)
    while attore_p[0] == regista[0] and attore_p[1] == regista[1]:
        attore_p = random.choice(artisti)
    attore_np = random.choice(artisti)
    while (attore_np[0] == regista[0] and attore_np[1] == regista[1]) or (attore_np[0] == attore_p[0] and attore_np[1] == attore_p[1]):
        attore_np = random.choice(artisti)

    # Inserimento in Film
    line_film = f'({ID}, \'{titolo}\', \'{descrizione}\', {anno}, \'{casa_prod}\', \'{regista[0]}\', \'{regista[1]}\'),\n'
    
    # Inserimento in Recitazione
    attori = f'({ID}, \'{attore_p[0]}\', \'{attore_p[1]}\'), ({ID}, \'{attore_np[0]}\', \'{attore_np[1]}\'),\n'

    # Inserimento in VincitaPremio
    line_premio = ''
    if random.randint(0, 5) > 4:
        premio = random.choice(premi)
        i = 0
        while premio_vinto(premio, anno):
            i = i + 1
            premio = random.choice(premi)
            if i > 10:
                premio = None
                break
        if premio:
            premi_vinti.append((premio[0], premio[1], anno))
            line_premio = f'(\'{premio[0]}\', \'{premio[1]}\', {anno}, {ID}, '
            match premio[2]:
                case 'nessuno':
                    line_premio += 'NULL, NULL),\n'
                case 'attore1':
                    line_premio += f'\'{attore_p[0]}\', \'{attore_p[1]}\'),\n'
                case 'attore2':
                    line_premio += f'\'{attore_np[0]}\', \'{attore_np[1]}\'),\n'
                case 'regista':
                    line_premio += f'\'{regista[0]}\', \'{regista[1]}\'),\n'
                case _:
                    raise Exception('Valori non coerenti!')
                    

    return line_film, attori, line_premio

def generate(number):
    assert number > 1
    with open('film.csv', 'r', encoding='utf-8') as film, open('film.sql', 'w', encoding='utf-8') as out, open('recitaz.sql', 'w', encoding='utf-8') as out_attori, open('premi.sql', 'w', encoding='utf-8') as out_premi:
        
        # Prima linea da scrivere
        out.write('INSERT INTO `Film` (`ID`, `Titolo`, `Descrizione`, `Anno`, `CasaProduzione`, `NomeRegista`, `CognomeRegista`) VALUES\n')
        out_attori.write('INSERT INTO `Recitazione` (`Film`, `NomeAttore`, `CognomeAttore`) VALUES\n')
        out_premi.write('INSERT INTO `VincitaPremio` (`Macrotipo`, `MicroTipo`, `Data`, `Film`, `NomeArtista`, `CognomeArtista`) VALUES\n')
        
        for i in range(1, number):
            line_out, line_att, line_premio  = generate_film(ID=i, film=film)
            if i + 1 == number:
                line_out = line_out[:-2] + ';\n'
                line_att = line_att[:-2] + ';\n'
            out.write(line_out)
            out_attori.write(line_att)
            if line_premio:
                out_premi.write(line_premio)
        out_premi.write('(\'FilmSphere\', \'Primo Film inserito\', YEAR(CURRENT_DATE), 1, NULL, NULL);\n')

    # Concatenare i file
    with open('film.sql', 'a', encoding='utf-8') as file:
        
        with open('recitaz.sql', 'r', encoding='utf-8') as attori:
            for line in attori:
                file.write(line)
        os.remove('recitaz.sql')

        with open('premi.sql', 'r', encoding='utf-8') as vincite:
            for line in vincite:
                file.write(line)
        os.remove('premi.sql')



if __name__ == "__main__":
    if len(sys.argv) < 2:
        number = number = 0.1
    else:
        number = sys.argv[1]
        if not number:
            number = 0.1
        else:
            number = max(float(number), 0.1)
    generate(floor(number * 1000))

        

        
