// Commerciante.java

import java.net.*;
import java.io.*;

public class Commerciante {
   
  public static void inviaInserzione(int porta, Inserzione i) {
    try (Socket sock = new Socket("localhost", porta)) {
      ObjectOutputStream oos =
        new ObjectOutputStream(sock.getOutputStream());
      oos.writeObject(i);
    } catch (IOException e) { e.printStackTrace();}
  } 
  
  public static Inserzione riceviInserzione(int porta) {
    Inserzione i = null;
    try ( 
      ServerSocket servsock = new ServerSocket(porta); 
      Socket sock = servsock.accept();
    ) {
      ObjectInputStream ois =
         new ObjectInputStream(sock.getInputStream());
      i = (Inserzione)ois.readObject();
    } catch (IOException | ClassNotFoundException e) { e.printStackTrace();}
    return i;
  }
  
  public static void main(String[] args) {
    Inserzione i;            
    if (args.length > 3) {
      i = new Inserzione(args[4], Double.parseDouble(args[2]), Double.parseDouble(args[3]), Integer.parseInt(args[0])); //1
      System.out.println(i); //2
      inviaInserzione(Integer.parseInt(args[1]), i); //3
      i = riceviInserzione(Integer.parseInt(args[0])); //12
      System.out.println(i); //13
      inviaInserzione(Integer.parseInt(args[1]), i); //14
      i = riceviInserzione(Integer.parseInt(args[0])); //19
      System.out.println(i); //20
    } else {
      i = riceviInserzione(Integer.parseInt(args[0])); //4
      System.out.println(i); //5
      i.effettuaOfferta(Double.parseDouble(args[2])); //6
      System.out.println("Sono " + Integer.parseInt(args[0]) + " ed offro " + Integer.parseInt(args[2]));
      inviaInserzione(Integer.parseInt(args[1]), i);  //7
      i = riceviInserzione(Integer.parseInt(args[0])); //15
      if (i.restituisciMiglioreOfferta() == Double.parseDouble(args[2])) { // 16
        i.inserisciPortaCompratore(Integer.parseInt(args[0])); //17
        inviaInserzione(i.restituisciPortaProponente(), i); //18
      } else {
        inviaInserzione(Integer.parseInt(args[1]), i); //18 alternativo 
      } 
    }
  }   
}