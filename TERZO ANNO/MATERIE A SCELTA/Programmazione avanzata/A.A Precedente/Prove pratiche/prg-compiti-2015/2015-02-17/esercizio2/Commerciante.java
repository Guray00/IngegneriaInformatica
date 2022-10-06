// Commerciante.java

import java.net.*;
import java.io.*;

public class Commerciante {
   
  public static void inviaSommaPrezzi(int porta, SommaPrezzi sp) {
    try (Socket sock = new Socket("localhost", porta)) {
      ObjectOutputStream oos =
        new ObjectOutputStream(sock.getOutputStream());
      oos.writeObject(sp);
    } catch (IOException e) { e.printStackTrace();}
  } 
  
  public static SommaPrezzi riceviSommaPrezzi(int porta) {
    SommaPrezzi sp = null;
    try ( 
      ServerSocket servsock = new ServerSocket(porta); 
      Socket sock = servsock.accept()
    ) {
      ObjectInputStream ois =
         new ObjectInputStream(sock.getInputStream());
      sp = (SommaPrezzi)ois.readObject();
    } catch (IOException | ClassNotFoundException e) { e.printStackTrace();}
    return sp;
  }
  
  public static void main(String[] args) {
    SommaPrezzi sp;            
    if (args[0].equals("8080")) {
      sp = new SommaPrezzi();
      double prezzoFittizio = Math.random();
      sp.aggiungiPrezzo(prezzoFittizio);
      inviaSommaPrezzi(Integer.parseInt(args[1]), sp);
      sp = riceviSommaPrezzi(Integer.parseInt(args[0]));
      sp.rimuoviPrezzo(prezzoFittizio);
      sp.aggiungiPrezzo(Double.parseDouble(args[2]));
      System.out.println(sp.calcolaPrezzoMedio());
    } else {
      sp = riceviSommaPrezzi(Integer.parseInt(args[0]));
      sp.aggiungiPrezzo(Double.parseDouble(args[2]));
      inviaSommaPrezzi(Integer.parseInt(args[1]), sp);        
    }   
  }
}