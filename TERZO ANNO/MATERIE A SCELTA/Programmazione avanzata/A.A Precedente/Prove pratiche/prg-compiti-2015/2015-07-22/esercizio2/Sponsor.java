// Sponsor.java

import java.net.*;
import java.io.*;

public class Sponsor {
   
  public static void inviaProgetto(int porta, Progetto p) {
    try (Socket sock = new Socket("localhost", porta)) {
      ObjectOutputStream oos =
        new ObjectOutputStream(sock.getOutputStream());
      oos.writeObject(p);
    } catch (IOException e) { e.printStackTrace();}
  } 
  
  public static Progetto riceviProgetto(int porta) {
    Progetto p = null;
    try ( 
      ServerSocket servsock = new ServerSocket(porta); 
      Socket sock = servsock.accept();
    ) {
      ObjectInputStream ois =
         new ObjectInputStream(sock.getInputStream());
      p = (Progetto)ois.readObject();
    } catch (IOException | ClassNotFoundException e) { e.printStackTrace();}
    return p;
  }
  
  public static void main(String[] args) {
    Progetto p;            
    if (args.length > 3) {
      p = new Progetto(args[3], Integer.parseInt(args[4]), Double.parseDouble(args[5]), Integer.parseInt(args[0])); //1
      p.sponsorizza(Double.parseDouble(args[2])); //2
      System.out.println("Sono " + Integer.parseInt(args[0]) + " ed offro " + Double.parseDouble(args[2]));
      System.out.println(p); //3
      inviaProgetto(Integer.parseInt(args[1]), p); //4
      p = riceviProgetto(Integer.parseInt(args[0])); //9
      if (p.verificaAttivazione()) { //10.a
        System.out.println("Quota: " + Double.parseDouble(args[2])/p.restituisciFinanziamentoCorrente() + "%"); //10.a.1
        inviaProgetto(Integer.parseInt(args[1]), p); //10.a.2
      }
    } else {
      System.out.println("Sono " + Integer.parseInt(args[0]) + " ed offro " + Double.parseDouble(args[2]));
      p = riceviProgetto(Integer.parseInt(args[0])); //5
      p.sponsorizza(Double.parseDouble(args[2])); //6
      System.out.println(p); //7
      if (p.verificaAttivazione()) { //8.a
        System.out.println("Quota: " + Double.parseDouble(args[2])/p.restituisciFinanziamentoCorrente() + "%"); //8.a.1
        inviaProgetto(p.restituisciPortaRicezioneProponente(), p); //8.a.2
        p = riceviProgetto(Integer.parseInt(args[0])); //8.a.3
      } else { //8.b
        inviaProgetto(Integer.parseInt(args[1]), p); //8.b.1
        p = riceviProgetto(Integer.parseInt(args[0])); //8.b.2
        System.out.println("Quota: " + Double.parseDouble(args[2])/p.restituisciFinanziamentoCorrente() + "%");//8.b.3
        inviaProgetto(Integer.parseInt(args[1]), p); //8.b.4
      }
    }
  }   
}