# ************************************************************************************
# NOTA: di seguito, tutti i device sono lanciati passando una un numero di porta
# a linea di comando, per generalità. Se si decide che un device si comporta da client
# non è necessario recuperare la porta nel codice, né effettuare la bind().
# Supporre che i dispositivi contattino il server sulla porta 4242, inserendola
# staticamente nel codice sorgente.
# ************************************************************************************

# 1. COMPILAZIONE
# Il comando 'make' necessita del makefile, che deve essere
# creato come descritto nella guida sulla pagina Elearn

  make

  read -p "Compilazione eseguita. Premi invio per eseguire..."

# 2. ESECUZIONE
# I file eseguibili devono chiamarsi come descritto in specifica, e cioè:
#    a) 'server' per il server;
#    b) 'td' per il table device;
#    c) 'kd' per il kitchen device;
#    d) 'cli' per il client.
# I file eseguibili devono essere nella current folder

# 2.1 esecuzione del server sulla porta 4242
  gnome-terminal -x sh -c "./server 4242; exec bash"

# 2.2 esecuzione di 3 table device sulle porte {5001,...,5003}
  for port in {5001..5003}
  do
     gnome-terminal -x sh -c "./td $port; exec bash"
  done

# 2.3 esecuzione di 2 kitchen device sulle porte 6001 e 6002
	gnome-terminal -x sh -c "./kd 6000; exec bash"
	gnome-terminal -x sh -c "./kd 6001; exec bash"

# 2.4 esecuzione di un client sulla porta 7000
	gnome-terminal -x sh -c "./cli 7000; exec bash"