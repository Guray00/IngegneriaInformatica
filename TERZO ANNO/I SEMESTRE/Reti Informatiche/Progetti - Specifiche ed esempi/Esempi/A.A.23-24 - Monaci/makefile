all: client server other

client: client.o
	gcc -Wall -o client client.c

server: server.o
	gcc -Wall -o server server.c

other: other.o
	gcc -Wall -o other other.c

clean:
	rm *o client server other

start: client server other
	gnome-terminal -x bash -c "./server 4242 ; exec bash"
	gnome-terminal -x bash -c "./other ; exec bash"
	gnome-terminal -x bash -c "./client ; exec bash"
