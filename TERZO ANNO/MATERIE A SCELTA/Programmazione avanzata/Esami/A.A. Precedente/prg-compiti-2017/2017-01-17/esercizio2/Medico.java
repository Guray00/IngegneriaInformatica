// Medico.java

import java.net.*;
import java.io.*;

public class Medico {
   
  public static void invia(int porta, Consultazione c) {
    try (Socket sock = new Socket("localhost", porta)) {
      ObjectOutputStream oos =
        new ObjectOutputStream(sock.getOutputStream());
      oos.writeObject(c);
    } catch (IOException e) { e.printStackTrace();}
  } 
  
  public static Consultazione ricevi(int porta) {
    Consultazione c = null;
    try ( 
      ServerSocket servsock = new ServerSocket(porta); 
      Socket sock = servsock.accept();
    ) {
      ObjectInputStream ois =
         new ObjectInputStream(sock.getInputStream());
      c = (Consultazione)ois.readObject();
    } catch (IOException | ClassNotFoundException e) { e.printStackTrace();}
    return c;
  }
  
  public static void main(String[] args) {
    Consultazione c;            
    if (args[args.length-1].startsWith("sintomi:")) { //è la radice
      c = new Consultazione(args[2]); //1
      invia(Integer.parseInt(args[1]), c); //2
      c = ricevi(Integer.parseInt(args[0])); //10
      System.out.println(java.time.LocalTime.now() + ") sono " + Integer.parseInt(args[0]) + ": " + c); //11
    }
    else {  //non è la radice
      c = ricevi(Integer.parseInt(args[0])); //3
      if (!c.diagnosiInserita()) { //4.a
        if (args.length>2 && args[2].startsWith("diagnosi:")) {  //4.a.b
          c.inserisciDiagnosi(args[2]); //4.a.b.1
        }
        else if (args.length>2 && !args[2].startsWith("diagnosi:")) { //4.a.c
          invia(Integer.parseInt(args[2]), c); //4.a.c.1
          c = ricevi(Integer.parseInt(args[0])); //4.a.c.2
        }
      }
      System.out.println(java.time.LocalTime.now() + ") sono " + Integer.parseInt(args[0]) + ": " + c); //5
      invia(Integer.parseInt(args[1]), c); //6
    }  
  }    
}