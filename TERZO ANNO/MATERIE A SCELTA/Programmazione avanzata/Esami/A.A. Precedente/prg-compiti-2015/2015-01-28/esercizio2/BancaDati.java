// BancaDati.java

import java.net.*;
import java.io.*;

public class BancaDati {
   public static void main(String[] args) {
    try {
      ServerSocket servsock = new ServerSocket(8081);
        Socket sock = servsock.accept();
        ObjectInputStream ois = 
          new ObjectInputStream(sock.getInputStream());
        Dati dati = (Dati)ois.readObject();
      servsock.close(); sock.close();
      
      ObjectOutputStream oos =
        new ObjectOutputStream(
          new FileOutputStream("data.bin"));
        oos.writeObject(dati);
      oos.close();

      ois = new ObjectInputStream(
        new FileInputStream("data.bin"));
        dati = (Dati)ois.readObject();
      ois.close();
      
      sock = new Socket("localhost", 8080); //(1)
        oos = new ObjectOutputStream(sock.getOutputStream());
        oos.writeObject(dati);
      sock.close();
      
    } catch (IOException | ClassNotFoundException e) 
    { e.printStackTrace(); }
  }
}

/*
(1) L'invio avviene su una diversa connessione rispetto alla ricezione, per 
    consentire protocolli applicativi a più banche dati connesse ad anello.
*/