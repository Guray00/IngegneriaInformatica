// Terminale.java
import java.net.*;
import java.io.*;

public class Terminale {
   
  public static void inviaComeStringa(int porta, Parametro p) {
    try (Socket sock = new Socket("localhost", porta);
      DataOutputStream dos =
        new DataOutputStream(sock.getOutputStream());
    ) {  dos.writeUTF(p.toString());
    } catch (IOException e) { e.printStackTrace();}
    System.out.println("- invio a " + porta); //2
  } 
  
  public static Parametro riceviComeStringa(int porta) {
    Parametro p = null;
    try ( 
      ServerSocket servsock = new ServerSocket(porta); 
      Socket sock = servsock.accept();
      DataInputStream dis =
         new DataInputStream(sock.getInputStream());
    ) {
      p = new Parametro(dis.readUTF());
    } catch (IOException e) { e.printStackTrace();}
    System.out.println("- ricevo\n" + p); //2
    return p;
  }
  
  public static void main(String[] args) {
    System.out.println("- sono " + args[1]); //2
    Parametro p;            
    if (args[1].equals("8080")) { // è la radice
      p = new Parametro(Double.parseDouble(args[0])); //1
      System.out.println(p); //2
      inviaComeStringa(Integer.parseInt(args[2]), p); //3
      p = riceviComeStringa(Integer.parseInt(args[1])); //6
      System.out.println(p.calcolaParametro()); //7
    }
    else {  //non è la radice
      p = riceviComeStringa(Integer.parseInt(args[1])); //4
      if (p.stabilitaCampioni()) {  //5.a 
        inviaComeStringa(Integer.parseInt(args[2]), p); //5.a.1
      } else { //5.b 
        p.aggiungiCampione(Double.parseDouble(args[0])); //5.b.1
        System.out.println("- aggiunto campione\n" + p); //5.b.2
        if (args.length < 4) { //5.b.3.c foglia
          inviaComeStringa(Integer.parseInt(args[2]), p); //5.b.3.c.1
        } else { // 5.b.3.d nodo
          if (!p.stabilitaCampioni()) { //5.b.3.d.e nodo e campioni instabili
            inviaComeStringa(Integer.parseInt(args[3]), p); //5.b.3.d.e.1
            p = riceviComeStringa(Integer.parseInt(args[1])); //5.b.3.d.e.2
          }
          inviaComeStringa(Integer.parseInt(args[2]), p); //  //5.b.3.d.1
        } 
      }      
    }
  }    
}
