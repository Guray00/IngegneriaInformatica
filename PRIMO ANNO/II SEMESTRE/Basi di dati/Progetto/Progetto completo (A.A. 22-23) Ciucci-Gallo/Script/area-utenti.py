from Cryptodome.Hash import SHA224
import random
import string
import datetime
import sys
from math import floor
import os

abbonamenti = [
    'Basic',
    'Premium',
    'Pro',
    'Deluxe',
    'Ultimate'
]

domini_email = [
    'libero.it',
    'virgilio.it',
    'hotmail.it',
    'gmail.com',
    'yahoo.com',
    'aol.com',
    'live.com',
    'msn.com',
    'yahoo.it',
    'alice.it',
    'facebook.com',
    'tiscali.it'
]

user_agents = [
    # Windows user agents
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36 Edg/114.0.1823.51",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/114.0",
    "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 OPR/95.0.0.0 (Edition Campaign 34)"
    # Mac user agents
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.5 Safari/605.1.1",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36",
    # Linux user agents
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36",
    "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/114.0",
    "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/114.0",
    "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/110.0",
    "Mozilla/5.0 (X11; Linux aarch64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36"
    # Chrome OS user agent
    "Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"
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
def next_nome_cognome(nomi, cognomi):
    nome = next_line(file=nomi)
    cognome = next_line(file=cognomi)

    nome = nome.replace('\'', '').replace('"', '')
    cognome = cognome.replace('\'', '').replace('"', '')

    return nome, cognome
def hash(password):
    h = SHA224.new()
    h.update(str(password).encode())
    return h.hexdigest()
def rand_email(user):
    start = user + '-' + ''.join(random.choices(population=string.ascii_letters+string.digits, k=random.randint(2, 4))) 
    dominio = random.choice(domini_email)
    return start + '@' + dominio
def abbonamento():
    return random.choice(abbonamenti)
def data(min=None, max=None):
    if not min:
        return data(min=datetime.datetime.now() - datetime.timedelta(days=random.randint(1, 7)), max=max)
    if not max:
        new_max = min + datetime.timedelta(days=random.randint(1, 101))
        return data(min=min, max=new_max)
    
    delta = max - min
    days = random.randint(0, delta.days)
    hours = random.randint(0, 23)
    minutes = random.randint(0, 59)
    seconds = random.randint(0, 59)
    return min + datetime.timedelta(days=days, hours=hours, minutes=minutes, seconds=seconds)

def date_to_str(date):
    if not date:
        return ''
    return str(date.year) + '-' + str(date.month).zfill(2) + '-' + str(date.day).zfill(2)

def datetime_to_str(date):
    if not date:
        return ''
    return date_to_str(date=date) + ' ' + str(date.hour).zfill(2) + ':' + str(date.minute).zfill(2) + ':' + str(date.second).zfill(2)

def generate_single_fattura(user, pagata, fatture_pagate, fatture_da_pagare, carte_di_credito):
    if not pagata:
        with open(fatture_da_pagare, 'a') as file:
            file.write('(\'' + user + '\', \'' +  date_to_str(data()) + '\'),\n')
    
    pan = ''.join(random.choices(population=string.digits, k=16))
    cvv = random.randint(1, 999)
    emissione = data()
    scadenza = data(min=emissione)

    pagamento = data(min=emissione, max=scadenza)

    scadenza = str(scadenza.year) + '-' + str(scadenza.month).zfill(2) + '-01'
    emissione = date_to_str(emissione)
    pagamento = date_to_str(pagamento)

    with open(carte_di_credito, 'a') as file:
        line = '(' + str(pan) + ', \'' + scadenza + '\', ' + str(cvv) + '),\n'
        file.write(line)
    with open(fatture_pagate, 'a') as file:
        line = '(\'' + user + '\', \'' +  emissione + '\', \'' + pagamento + '\', ' + str(pan) + '),\n'
        file.write(line)
def generate_connessione(user, connessione):

    ip = int.from_bytes(random.randbytes(4), 'big')
    while ip < 16777216:
        ip = int.from_bytes(random.randbytes(4), 'big')
    ip = str(ip)
    inizio = data()
    fine = inizio + datetime.timedelta(hours=random.randint(0, 4), minutes=random.randint(0, 59), seconds=random.randint(0, 59))
    fine = datetime_to_str(fine)
    inizio = datetime_to_str(inizio)
    hw = random.choice(user_agents)
    with open(connessione, 'a') as file:
        line = f'(\'{user}\', {ip}, \'{inizio}\', \'{fine}\', \'{hw}\'),\n'
        file.write(line)
    

def generate_single_user(
        users, pws, nomi, cognomi, 
        fatture_pagate, fatture_non_pagate, carte_di_credito,
        connessione, recensione):
    user = next_line(users).replace('\'', '').replace('"', '')
    user = user + ''.join(random.choices(population=string.ascii_letters+string.digits,k=random.randint(1, 5)))
    email = rand_email(user=user)
    password = hash(next_line(pws))
    nome, cognome = next_nome_cognome(nomi, cognomi)
    abb = abbonamento()
    iscrizione = date_to_str(data())
    
    sql = '(\'' + user + '\', \'' + nome + '\', \'' + cognome + '\', \'' + email + '\', \'' + password + '\', \'' + abb + '\', \'' + iscrizione + '\'),\n'
    
    # Fatture e Pagamenti
    numero_fatture = random.randint(1, 11)
    for i in range(0, numero_fatture):
        generate_single_fattura(user, i < 10, fatture_pagate, fatture_non_pagate, carte_di_credito)

    # Recensioni
    with open(recensione, 'a') as file:
        if random.randint(0, 10) > 9:
            file.write('CALL `RecensioneCasuale`(\'' + user + '\');\n')

    # Connessioni e Visualizzazioni
    numero_connessioni = random.randint(0, 10)
    for i in range(0, numero_connessioni):
        generate_connessione(user, connessione)

    return sql

def generate(number):
    assert number != 0
    # https://github.com/danielmiessler/SecLists
    usernames = open('user-names.txt', 'r')
    passwords = open('passwords.txt', 'r')

    # https://github.com/filippotoso/nomi-cognomi-italiani/
    nomi = open('nomi.csv', 'r')
    cognomi = open('cognomi.csv', 'r')

    fatture_p = 'fatture-pagate.sql'
    fatture = 'fatture-non-pagate.sql'
    carte = 'carte-di-credito.sql'
    connessione = 'connessione.sql'
    recensione = 'recensione.sql'
    
    checkpoint = floor(number / 100)
    
    with open(fatture, 'w') as file_temp:
        file_temp.write('INSERT INTO `Fattura` (`Utente`, `DataEmissione`) VALUES\n')

    with open(fatture_p, 'w') as file_temp:
        file_temp.write('INSERT INTO `Fattura` (`Utente`, `DataEmissione`, `DataPagamento`, `CartaDiCredito`) VALUES\n')

    with open(carte, 'w') as file_temp:
        file_temp.write('REPLACE INTO `CartaDiCredito` (`Pan`, `Scadenza`, `CVV`) VALUES\n')

    with open(connessione, 'w') as file_temp:
        file_temp.write('REPLACE INTO `Connessione` (`Utente`, `IP`, `Inizio`, `Fine`, `Hardware`) VALUES\n')

    open(recensione, 'w').close()
    
    file_out = open('area-utenti.sql', 'w')
    
    file_out.write('INSERT INTO `Utente` (`Codice`, `Nome`, `Cognome`, `Email`, `Password`, `Abbonamento`, `DataInizioAbbonamento`) VALUES\n')
    
    for i in range(1, number):
        if i % checkpoint == 0:
            print(str(floor(i / number * 100)) + '%\t' + str(i) + '/' + str(number))
        line = generate_single_user(
            users=usernames, 
            pws=passwords, 
            nomi=nomi, 
            cognomi=cognomi,
            fatture_pagate=fatture_p,
            fatture_non_pagate=fatture,
            carte_di_credito=carte,
            connessione=connessione,
            recensione=recensione)
        file_out.write(line)
    
    usernames.close()
    passwords.close()
    nomi.close()
    cognomi.close()
    file_out.write('(\'richie-314\', \'Nome\', \'Cognome\', \'email@prova.it\', \'hash\', \'Pro\', CURRENT_DATE);\n')
    
    with open(fatture_p, 'a') as file:
        file.write('(\'richie-314\', CURRENT_DATE, NULL, NULL);\n')
    with open(fatture, 'a') as file:
        file.write('(\'richie-314\', CURRENT_DATE);\n')
    with open(connessione, 'a') as file:
        file.write('(\'richie-314\', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, \'' + random.choice(user_agents) + '\');\n')
    with open(carte, 'a') as file:
        file.write('(1, CURRENT_DATE, 314);\n\n')
    files_to_append = [
        carte,
        fatture,
        fatture_p,
        connessione,
        recensione
    ]
    for file in files_to_append:
        with open(file, 'r') as file_in:
            file_out.write('\n\n\n')
            for line in file_in:
                file_out.write(line)
        # Assets used are removed
        os.remove(file)
    file_out.write('\nCALL `VisualizzazioniCasuali`();\n')

if __name__ == '__main__':
    if len(sys.argv) < 2:
        number = number = 0.1
    else:
        number = sys.argv[1]
        if not number:
            number = 0.1
        else:
            number = float(number)
    generate(floor(number * 1000000))