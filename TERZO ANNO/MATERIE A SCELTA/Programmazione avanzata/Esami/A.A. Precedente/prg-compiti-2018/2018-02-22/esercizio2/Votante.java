// Votante.java

import java.net.*;
import java.io.*;

public class Votante {
   
  public static void inviaProposta(int porta, Proposta pr) {
    try (Socket sock = new Socket("localhost", porta)) {
      ObjectOutputStream oos =
        new ObjectOutputStream(sock.getOutputStream());
      oos.writeObject(pr);
    } catch (IOException e) { e.printStackTrace();}
  } 
  
  public static Proposta riceviProposta(int porta) {
    Proposta pr = null;
    try ( 
      ServerSocket servsock = new ServerSocket(porta); 
      Socket sock = servsock.accept()
    ) {
      ObjectInputStream ois =
         new ObjectInputStream(sock.getInputStream());
      pr = (Proposta)ois.readObject();
    } catch (IOException | ClassNotFoundException e) { e.printStackTrace();}
    return pr;
  }
  
  public static void main(String[] args) {
    Proposta pr;            
    if (args.length > 3) {
      pr = new Proposta(args[3]);
      System.out.println(pr.restituisciContenuto());
      pr.vota(args[2]);
      inviaProposta(Integer.parseInt(args[1]), pr);
      pr = riceviProposta(Integer.parseInt(args[0]));
      pr.elabora();
      System.out.println(pr.restituisciRisultato());
      inviaProposta(Integer.parseInt(args[1]), pr);
      riceviProposta(Integer.parseInt(args[0]));
    } else {
      pr = riceviProposta(Integer.parseInt(args[0]));
      System.out.println(pr.restituisciContenuto());
      pr.vota(args[2]);
      inviaProposta(Integer.parseInt(args[1]), pr);
      pr = riceviProposta(Integer.parseInt(args[0]));
      System.out.println(pr.restituisciRisultato());
      inviaProposta(Integer.parseInt(args[1]), pr); 
    }   
  }
}