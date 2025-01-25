CC = gcc
CFLAGS = -Wall -std=c89
LDFLAGS = -L./lib

all: client server other

client: client.c lib/tcp.o lib/utility.o lib/game.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o client client.c lib/tcp.o lib/utility.o lib/game.o

server: server.c lib/tcp.o lib/utility.o lib/game.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o server server.c lib/tcp.o lib/utility.o lib/game.o

other: other.c lib/tcp.o lib/utility.o lib/game.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o other other.c lib/tcp.o lib/utility.o lib/game.o

lib/tcp.o: lib/tcp.c lib/tcp.h
	$(CC) $(CFLAGS) -c -o lib/tcp.o lib/tcp.c

lib/utility.o: lib/utility.c lib/utility.h
	$(CC) $(CFLAGS) -c -o lib/utility.o lib/utility.c

lib/game.o: lib/game.c lib/game.h
	$(CC) $(CFLAGS) -c -o lib/game.o lib/game.c

# dichiaro che il target "clean" non rappresenta un file fisico, se esistesse un file chiamato clean e non usassi l'annotazione .PHONY 
# il comando make potrebbe non funzionare correttamente
# .PHONY: clean

# pulisco rimuovendo 
clean:
	rm -f client server other lib/*.o