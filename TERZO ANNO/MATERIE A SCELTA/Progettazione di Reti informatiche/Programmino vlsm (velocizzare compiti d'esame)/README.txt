PROGRAMMINO PER CALCOLARE LE DIMENSIONI DELLE SOTTORETI
- Il programma è molto semplice e non è previsto un controllo su input non validi. Si da per scontato che chi inserisce i dati sappia cosa sta inserendo.
- Gli ingressi da tastiera hanno forma "nome numero_host numero_porte". Il programma in ogni caso va subito a sommare host e porte di accesso, quindi inserire "lan1 10 5" è uguale ad inserire "lan1 8 7".
- Negli esami, anche gli switch hanno un IP, quindi bisogna ricordarsi di includere il numero di switch per LAN.
- Il programma calcola, per ogni LAN, la maschera tale che "mask > host + porte + 2" in quanto servono due indirizzi riservati per broadcast e indirizzo di rete.
- Gli indirizzi assegnabili sono quelli nell'intervallo (rete, broadcast).
- A compilazione ci sono dei warning. Per toglierli basta includere "winsock2" tra le librerie.
- Winsock2 aveva le sue funzioni di conversione ntop e pton ma bho sembrano troppo complicate da usare, quindi le ho fatte da me.


###ESEMPIO DI UTILIZZO, CON L'ESAME 17/02/23
Ip di partenza: 172.16.0.0
LanA: ha uno switch, una porta di accesso (routerA) e richiede 25 host. -> (1 + 1), 25
LanB: ha uno switch, una porta di accesso (routerB) e richiede 120 host. -> (1 + 1), 120
LanC: ha uno switch, una porta di accesso (routerC) e richiede 55 host. -> (1 + 1), 55
LanS: ha uno switch, 3 porte di accesso (routerA, B e ASBR) e richiede 6 host. -> (1 + 3), 6
A-C: solo due porte di accesso, tra router A e C. -> 0, 2
B-C: solo due porte di accesso, tra router B e C. -> 0, 2

Input da tastiera richiesti:

    172.16.0.0

    lanA 25 2
    lanB 120 2
    lanC 55 2
    lanS 6 4
    AC 0 2
    BC 0 2
    done