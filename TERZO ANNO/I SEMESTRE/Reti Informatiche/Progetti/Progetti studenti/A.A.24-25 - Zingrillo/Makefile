# Variabili
CC = gcc
CFLAGS = -Wall
LDFLAGS = 

# File sorgente
SERVER_SOURCES = server.c modules/quiz.c modules/game.c modules/common.c modules/database.c modules/dashboard.c
CLIENT_SOURCES = client.c modules/common.c

# File oggetto
SERVER_OBJECTS = $(SERVER_SOURCES:.c=.o)
CLIENT_OBJECTS = $(CLIENT_SOURCES:.c=.o)

# Eseguibili
SERVER_EXECUTABLE = server
CLIENT_EXECUTABLE = client

# Regola per costruire tutto
all: $(SERVER_EXECUTABLE) $(CLIENT_EXECUTABLE)

# Regola per costruire il server
$(SERVER_EXECUTABLE): $(SERVER_OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^

# Regola per costruire il client
$(CLIENT_EXECUTABLE): $(CLIENT_OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^

# Regola per costruire i file oggetto
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

# Regola per pulire i file generati
clean:
	rm -f $(SERVER_OBJECTS) $(CLIENT_OBJECTS) $(SERVER_EXECUTABLE) $(CLIENT_EXECUTABLE)