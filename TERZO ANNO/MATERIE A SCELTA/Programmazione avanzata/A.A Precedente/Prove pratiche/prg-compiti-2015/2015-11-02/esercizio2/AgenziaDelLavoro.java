// AgenziaDelLavoro.java

import java.net.*;
import java.io.*;

public class AgenziaDelLavoro {
   
  public static void invia(int porta, RichiestaDiCompetenze r) {
    try (Socket sock = new Socket("localhost", porta)) {
      ObjectOutputStream oos =
        new ObjectOutputStream(sock.getOutputStream());
      oos.writeObject(r);
    } catch (IOException e) { e.printStackTrace();}
  } 
  
  public static RichiestaDiCompetenze ricevi(int porta) {
    RichiestaDiCompetenze r = null;
    try ( 
      ServerSocket servsock = new ServerSocket(porta); 
      Socket sock = servsock.accept();
    ) {
      ObjectInputStream ois =
         new ObjectInputStream(sock.getInputStream());
      r = (RichiestaDiCompetenze)ois.readObject();
    } catch (IOException | ClassNotFoundException e) { e.printStackTrace();}
    return r;
  }
  
  public static void main(String[] args) {
    System.out.println(java.time.LocalTime.now() + ") Sono " + args[0] + ":");
    RichiestaDiCompetenze r;            
    if (args.length==3 && args[2].endsWith("?")){   // richiedente
      r = new RichiestaDiCompetenze(args[2], Integer.parseInt(args[0])); //1
      System.out.println(java.time.LocalTime.now() + ")\n" + r); //2
      invia(Integer.parseInt(args[1]), r); //3
      r = ricevi(Integer.parseInt(args[0])); //7
      System.out.println(java.time.LocalTime.now() + ")\n" + r); //8
      invia(Integer.parseInt(args[1]), r); //9
      r = ricevi(Integer.parseInt(args[0])); //13
    } else {  // altri
      r = ricevi(Integer.parseInt(args[0])); //4 oppure 10
      System.out.println(java.time.LocalTime.now() + ")\n" + r); //5 oppure 11
      if (args.length==2) { // 6.b oppure //10
        invia(Integer.parseInt(args[1]), r); //6.b.1 oppure 12
        if (!r.esistePortaProponente()) { // deve ancora fare 10
          r = ricevi(Integer.parseInt(args[0])); //10
          System.out.println(java.time.LocalTime.now() + ")\n" + r); //11
          invia(Integer.parseInt(args[1]), r); //12   
        } // se 10 lo aveva fatto allora non deve fare altro
      }
      else if (args[2].endsWith("!")) { // 6.a ha competenze
        r.inserisciPortaProponente(Integer.parseInt(args[0]));  //6.a.1
        invia(r.restituisciPortaRichiedente(), r); //6.a.2 
        r = ricevi(Integer.parseInt(args[0])); //10
        System.out.println(java.time.LocalTime.now() + ")\n" + r); //11
        invia(Integer.parseInt(args[1]), r); //12   
      }
    }
  }   
}