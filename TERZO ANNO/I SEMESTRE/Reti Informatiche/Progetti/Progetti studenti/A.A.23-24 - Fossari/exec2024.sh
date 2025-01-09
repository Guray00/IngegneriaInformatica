make
read -p "Compilazione eseguita. Premi invio per eseguire..."
gnome-terminal -x sh -c "./server 4242; exec bash"
gnome-terminal -x sh -c "./client 4242; exec bash"
gnome-terminal -x sh -c "./client 4242; exec bash"