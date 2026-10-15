// SportelloDati.java

import java.net.*;
import java.io.*;

public class SportelloDati {
  public static void main(String args[]) {
    Dati datiBackup, dati = new Dati(Integer.parseInt(args[0]));
    dati.inizializza(Double.parseDouble(args[1]));
    try {
        Socket sock = new Socket("localhost", 8081);
        ObjectOutputStream oos = 
          new ObjectOutputStream(sock.getOutputStream());    
        oos.writeObject(dati);
        sock.close();
        
        ServerSocket servsock = new ServerSocket(8080);
        sock = servsock.accept(); // (1)
        ObjectInputStream ois = 
          new ObjectInputStream(sock.getInputStream());
        datiBackup = (Dati)ois.readObject();
        servsock.close(); sock.close();

        System.out.println(dati.equals(datiBackup));
     } catch (IOException | ClassNotFoundException e) 
     { e.printStackTrace();}
  }
}

/*
(1) Si mette in ascolto su una diversa connessione rispetto alla trasmissione,
    per consentire protocolli applicativi a più banche dati connesse ad anello.
*/

