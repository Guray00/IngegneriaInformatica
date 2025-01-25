#!/bin/bash

# Controllo la presenza di gcc
if ! command -v gcc &> /dev/null
then
    echo "Errore: gcc non è installato."
    exit 1
fi

# Controllo la presenza di make
if ! command -v make &> /dev/null
then
    echo "Errore: make non è installato."
    exit 1
fi

# Lancio il comando make
make

# Controllo se il comando make è andato a buon fine
if [ $? -ne 0 ]; then
    echo "Errore: il comando make è fallito."
    exit 1
fi

# Apro due nuove finestre del terminale e lancio ./client 3000
gnome-terminal -- bash -c "./client 3000; exec bash"
gnome-terminal -- bash -c "./client 3000; exec bash"

# Lancio il comando ./server nella scheda corrente
./server