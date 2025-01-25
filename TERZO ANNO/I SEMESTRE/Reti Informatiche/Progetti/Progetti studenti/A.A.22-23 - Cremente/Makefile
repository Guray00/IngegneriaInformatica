CCOPTIONS = -Wall -g -c
SERVEROBJS = server.o funz_serv.o Tavolo.o Prenotazione.o Piatto.o Ordine.o Comanda.o TableDevice.o KitchenDevice.o utility.o
#make rule primaria con dummy target 'all'

all: server cli td kd

#make rule per il server
server: server.o funz_serv.o Tavolo.o Prenotazione.o Piatto.o Ordine.o Comanda.o TableDevice.o KitchenDevice.o utility.o
	gcc -Wall funz_serv.o Tavolo.o Prenotazione.o Piatto.o Ordine.o Comanda.o TableDevice.o KitchenDevice.o utility.o server.o -o server

#make rule per il client
cli: cli.o funz_cli.o utility.o TavoloTrovato.o
	gcc -Wall cli.o funz_cli.o utility.o TavoloTrovato.o -o cli

#make rule per il td
td: td.o funz_td.o utility.o
	gcc -Wall td.o funz_td.o utility.o -o td

#make rule per il kd
kd: kd.o funz_kd.o utility.o ComInPrep.o Ordine.o
	gcc -Wall kd.o funz_kd.o utility.o ComInPrep.o Ordine.o -o kd

server.o: server.c
	gcc $(CCOPTIONS) server.c -o server.o

cli.o: cli.c
	gcc $(CCOPTIONS) cli.c -o cli.o

td.o: td.c
	gcc $(CCOPTIONS) td.c -o td.o

kd.o: kd.c
	gcc $(CCOPTIONS) kd.c -o kd.o

funz_serv.o: funz_serv.c funz_serv.h
	gcc $(CCOPTIONS) funz_serv.c -o funz_serv.o

Piatto.o: Piatto.c Piatto.h
	gcc $(CCOPTIONS) Piatto.c -o Piatto.o

Ordine.o: Ordine.c Ordine.h
	gcc $(CCOPTIONS) Ordine.c -o Ordine.o

Comanda.o: Comanda.c Comanda.h
	gcc $(CCOPTIONS) Comanda.c -o Comanda.o

TableDevice.o: TableDevice.c TableDevice.h
	gcc $(CCOPTIONS) TableDevice.c -o TableDevice.o

KitchenDevice.o: KitchenDevice.c KitchenDevice.h
	gcc $(CCOPTIONS) KitchenDevice.c -o KitchenDevice.o

Tavolo.o: Tavolo.c Tavolo.h
	gcc $(CCOPTIONS) Tavolo.c -o Tavolo.o

Prenotazione.o: Prenotazione.c Prenotazione.h
	gcc $(CCOPTIONS) Prenotazione.c -o Prenotazione.o

TavoloTrovato.o: TavoloTrovato.c TavoloTrovato.h
	gcc $(CCOPTIONS) TavoloTrovato.c -o TavoloTrovato.o

ComInPrep.o: ComInPrep.c ComInPrep.h
	gcc $(CCOPTIONS) ComInPrep.c -o ComInPrep.o

utility.o: utility.c utility.h
	gcc $(CCOPTIONS) utility.c -o utility.o

funz_cli.o: funz_cli.c funz_cli.h
	gcc $(CCOPTIONS) funz_cli.c -o funz_cli.o

funz_td.o: funz_td.c funz_td.h
	gcc $(CCOPTIONS) funz_td.c -o funz_td.o

funz_kd.o: funz_kd.c funz_kd.h
	gcc $(CCOPTIONS) funz_kd.c -o funz_kd.o

#pulizia dei file della compilazione
clean:
	rm *.o server cli td kd