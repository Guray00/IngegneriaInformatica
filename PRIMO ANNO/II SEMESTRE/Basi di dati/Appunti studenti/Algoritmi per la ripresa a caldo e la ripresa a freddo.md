## Ripresa a Caldo

1. Trovare l'ultimo checkpoint e inserire tutte le transazioni attive nell'ultimo $CK$ in UNDO lasciando REDO vuoto.
2. Dall'ultimo $CK$ andare in avanti e inserire in UNDO le transazioni iniziate ($B(T_i)$) e in REDO quelle "committate" ($C(T_i)$).
3. Ripercorrere <u>all'indietro</u> il log dalla fine fino all'inizio cercando le operazioni da disfare (ossia quelle delle transazioni contenute in UNDO) ricordandosi che per gli **update** e i **delete** vale: $$O_i=\text{BS} \text{, per i delete a volte si scrive }Reinsert(O_i=\text{BS}) $$e per gli **insert**: $$\text{Delete}(O_i)$$
4. Ripercorrere <u>in avanti</u> il log dall'inizio alla fine cercando le operazioni da rifare (ossia quelle delle transazioni contenute in REDO) ricordandosi che per gli **update** e gli **insert** vale: $$O_i=\text{AS}$$ e per i **delete**: $$\text{Delete}(O_i)$$

|          | Delete               | Update          | Insert               |
| -------- | -------------------- | --------------- | -------------------- |
| **UNDO** | $O_i=\text{BS}$      | $O_i=\text{BS}$ | $\text{Delete}(O_i)$ |
| **REDO** | $\text{Delete}(O_i)$ | $O_i=\text{AS}$ | $O_i=\text{AS}$      |

Esempio:
$$DUMP,B(T_1),B(T_2),B(T_3),I(T_1,O_1,A_1),D(T_2,O_2,B_2),B(T_4),U(T_4,O_3,B_3,A_3),U(T_1,O_4,B_4,A_4),C(T_2),CK(T_1,T_3,T_4),B(T_5),B(T_6),U(T_5,O_5,B_5,A_5),A(T_3),C(T_1),CK(T_4,T_5,T_6),B(T_7),A(T_4),U(T_7,O_6,B_6,A_6),U(T_7,O_3,B_7,A_7),B(T_8),C(T_7),I(T_8,O_2,A_8),D(T_8,O_2,B_8),GUASTO$$
1. Selezioniamo l'ultimo checkpoint, in questo caso $CK(T_4,T_5,T_6)$ e mettiamo le transazioni attive a quel checkpoint nell'insieme UNDO, lasciando per ora REDO vuoto. $$\text{UNDO}=\{T_4,T_5,T_6\}\hspace{4em}\text{REDO}=\varnothing$$
2. Inseriamo i ***begin*** in UNDO e spostiamo i ***commit*** in REDO.
	- $B(T_7)$ e $B(T_{8)}$ $\implies\text{UNDO}=\{T_4,T_5,T_6,T_7,T_8\}\hspace{1em}\text{REDO}=\varnothing$
	- $C(T_7)$ $\implies\text{UNDO}=\{T_4,T_5,T_6,T_8\}\hspace{1em}\text{REDO}=\{T_7\}$
	
	I nostri registri alla fine si presenteranno così: $$\text{UNDO}=\{T_4,T_5,T_6,T_8\}\hspace{4em}\text{REDO}=\{T_7\}$$
3. Andando a ritroso, cerchiamo le operazioni di *insert*, *delete* e *update* appartenenti alle transazioni contenute in UNDO. In questo caso considereremo solo le operazioni delle transazioni $T_4,T_5,T_6,T_8$ e seguiremo le regole viste precedentemente:
	- $D(T_8,O_2,B_8)\implies O_2=B_8$
	- $I(T_8,O_2,A_8)\implies\text{Delete}(O_2)$
	- $U(T_5,O_5,B_5,A_5)\implies O_5=B_5$
	- $U(T_4,O_3,B_3,A_3)\implies O_3=B_3$
	
4. Adesso facciamo il contrario, cerchiamo le operazioni di *insert*, *delete* e *update* appartenenti alle transazioni contenute in REDO. In questo caso considereremo solo le operazioni di $T_7$ e seguiremo le regole viste precedentemente:
	- $U(T_7,O_6,B_6,A_6)\implies O_6=A_6$
	- $U(T_7,O_3,B_7,A_7)\implies O_3=A_7$
---
## Ripresa a Freddo

1. Partendo dal DUMP, ripercorro in avanti il log selezionando le operazioni che coinvolgono gli oggetti corrotti, e i vari *commit* e *abort*.![[Pasted image 20240902171138.png]]
2. Si fa la ripresa a caldo come prima.