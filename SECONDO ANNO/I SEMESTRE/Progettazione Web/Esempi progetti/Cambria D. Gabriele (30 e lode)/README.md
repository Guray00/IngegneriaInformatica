# 1. Titles - a pweb project

Il gioco si basa su combattimenti nel classico stile _Pokémon_(R), ma con mosse, strumenti, statistiche e stile dei personaggi più vicino a giochi di ruolo, come ad esempio _Dungeons & Dragons_(R).

Il gioco è <u>_**decisamente**_</u> più grande di quanto richiesto per un buon progetto, una dimostrazione è il fatto che tutte le immagini svg sono state create manualmente tramite codice e/o applicazione [inkscape](https://inkscape.org/it/).
Tuttavia può essere un buono spunto principalemnte nella parte [php](./php).

Potete trovare delle immagini nella cartella [./images/png](./images/png).

# 2. Informazioni sul gioco

Ogni account può creare fino a un massimo di **5 personaggi** (_PG_) con cui giocare contro i personaggi (di livello al massimo di 1 più alto) degli altri utenti comandati da una CPU.

## 2.1. Statistiche dei Personaggi
Ogni personaggio possiede le seguenti statistiche:
- **Nome**: il nome del personaggio.
- **Livello**: aumenta ogni volta che l'esperienza arriva a **100 punti**. Al level-up si ottengono:
  - **+40 monete**
  - **+3 PU** (Punti Upgrade), utilizzabili per aumentare di un punto le statistiche del personaggio
  - **1 box comune**
- **Esperienza**: si guadagna tramite le partite giocate:
  - `+5` per le sconfitte
  - `+15` per le vittorie
- **Punti Ferita (PF)**: determinano la salute del personaggio. Alla creazione il personaggio ha **50 PF**.
- **Forza (FOR)**: determina il danno inflitto secondo la [tabella dei danni](#tabella-dannischivata).
- **Destrezza (DES)**: determina la probabilità di schivare un attacco, secondo la [tabella della schivata](#tabella-dannischivata).
- **Elemento**: a scelta tra 5 (_acqua_, _fuoco_, _terra_, _aria_, _elettro_). Ogni elemento fornisce bonus e malus fissi secondo la [tabella degli elementi](#tabella-elementi). Esiste il concetto di **prevalenza**: quando un elemento prevale su un altro, il danno inflitto aumenta di **1 punto** e la probabilità di schivata del personaggio prevalso viene **dimezzata**. In relazione agli strumenti esistono i concetti di:
  - **Allineato**: l'elemento dello strumento è uguale a quello del personaggio
  - **Opposto**: l'elemento dello strumento è quello che prevale su quello del personaggio
- **Arma e Armatura**: determinano rispettivamente il danno inflitto e la diminuzione del danno subito ([tabella armi](#informazioni-sulle-armi), [tabella armature](#informazioni-sulle-armature)). Si ottengono comprandole dallo shop o aprendo box. Effetti di allineamento:
  - Se l'elemento dell'arma è allineato a quello del personaggio, il danno inflitto aumenta di **1 punto**; se opposto fornisce prevalenza anche sull'elemento stesso del personaggio.
  - Se l'elemento dell'armatura è allineato a quello del personaggio, la diminuzione del danno subito aumenta di **1 punto**; se opposto rimuove gli effetti della prevalenza dell'avversario.
- **Zaino**: può contenere fino a **3 oggetti** assegnati dall'inventario dell'account, utilizzabili in battaglia al posto dell'attacco per fornire buff alle statistiche. Gli oggetti si ottengono dallo shop o dalle box ([tabella pozioni](#informazioni-sulle-pozioni)).

## 2.2. Inventario e Shop
Ogni account ha un **inventario** in cui può conservare fino a **40 oggetti** diversi prima di assegnarli ai personaggi o venderli in cambio di monete (per metà del loro valore). Gli oggetti possono essere acquistati nel **Negozio**, che si aggiorna **ogni 3 minuti**.

## 2.3. Box
Le box si differenziano in **box comuni** e **box rare** e contengono quanto segue ([tabella box](#informazioni-sulle-box)):
- **Box Comune**: monete, 1 pozione, 2 oggetti (armi e/o armature)
- **Box Rara**: monete, 2 pozioni, 2 armi e 2 armature

## 2.4. Tabelle di riferimento

### 2.4.1. Tabella Danni/Schivata
|          |FOR - Danni|DES - % schivata|
|---------:|:---------:|:--------------:|
|`-10`/`-9`|    `0`    |      `0%`      |
|`-8`/`-7` |    `1`    |     `10%`      |
|`-6`/`-5` |    `2`    |     `15%`      |
|`-4`/`-3` |    `3`    |     `20%`      |
|`-2`/`-1` |    `4`    |     `25%`      |
|`+0`/`+1` |    `5`    |     `30%`      |
|`+2`/`+3` |    `6`    |     `35%`      |
|`+4`/`+5` |    `7`    |     `40%`      |
|`+6`/`+7` |    `8`    |     `45%`      |
|`+8`/`+9` |    `9`    |     `50%`      |
|  `+10`   |    `10`   |     `60%`      |

### 2.4.2. Tabella Elementi
|Elementale|FOR |DES | PF |Totale|Prevale|Prevalsa da|
|:--------:|:--:|:--:|:--:|:----:|:-----:|:---------:|
|_Acqua_   |`-3`|`+2`|`+5`| `+4` |Fuoco  |  Elettro  |
|_Fuoco_   |`+4`|`+3`|`-3`| `+4` |Aria   |   Acqua   |
|_Terra_   |`+0`|`-2`|`+6`| `+4` |Elettro|    Aria   |
|_Elettro_ |`+6`|`+0`|`-2`| `+4` |Acqua  |   Terra   |
|_Aria_    |`-1`|`+6`|`-1`| `+4` |Terra  |   Fuoco   |

### 2.4.3. Informazioni sulle armi
| Nome               | Descrizione                        | Elemento | Tipologia | Costo | Danno | ModificatoreFor  | ModificatoreDes  |
|--------------------|------------------------------------|----------|-----------|-------|-------|------------------|------------------|
| Spada d'Acqua      | Una spada affilata e leggera.      | Acqua    | arma      | 20    | 6     | 2                | 1                |
| Spada di Fuoco     | Una spada infuocata.               | Fuoco    | arma      | 30    | 8     | 0                | 1                |
| Mazza di Terra     | Una mazza pesante e robusta.       | Terra    | arma      | 30    | 8     | 1                | 0                |
| Bastone Elettrico  | Un bastone che emette elettricità. | Elettro  | arma      | 25    | 7     | 1                | 1                |
| Pugnale d'Aria     | Un pugnale leggero e veloce.       | Aria     | arma      | 20    | 6     | 1                | 2                |

### 2.4.4. Informazioni sulle armature
| Nome               | Descrizione             | Elemento | Tipologia | Costo | Armatura |  ModificatoreFor  | ModificatoreDes  |
|--------------------|-------------------------|----------|-----------|-------|----------|-------------------|------------------|
| Armatura d'Acqua   | Leggera e impermeabile. | Acqua    | armatura  | 40    | 4        | -1                |  0               |
| Armatura di Fuoco  | Resistente al calore.   | Fuoco    | armatura  | 40    | 4        |  0                | -1               |
| Armatura di Terra  | Robusta e pesante.      | Terra    | armatura  | 45    | 5        | -1                | -2               |
| Armatura Elettrica | Robusta e conduttiva.   | Elettro  | armatura  | 45    | 5        | -2                | -1               |
| Armatura d'Aria    | Leggera e flessibile.   | Aria     | armatura  | 35    | 3        |  0                |  0               |

### 2.4.5. Informazioni sulle pozioni
| Nome                 | Descrizione                                       | Tipologia | Costo | RecuperoVita  | ModificatoreFor | ModificatoreDes |
|----------------------|---------------------------------------------------|-----------|-------|---------------|-----------------|-----------------|
| Pozione di Vita      | Ripristina 20 PF.                                 | pozione   | 15    | 20            | 0               | 0               |
| Pozione di Energia   | Ripristina 10 PF.                                 | pozione   | 10    | 10            | 0               | 0               |
| Pozione di Forza     | Aumenta la forza temporaneamente di 3 punti.      | pozione   |  8    | 0             | 3               | 0               |
| Pozione di Destrezza | Aumenta la destrezza temporaneamente di 3 punti.  | pozione   |  8    | 0             | 0               | 3               |

### 2.4.6. Informazioni sulle box
| Nome               | Descrizione                     | Tipologia | Costo |
|--------------------|---------------------------------|-----------|-------|
| Box Comune         | Contiene monete, pozione, 2 oggetti (armi e/o armature). | box       | 50    |
| Box Rara           | Contiene monete, 2 pozioni, 2 armi e 2 armature. | box       | 100   |
