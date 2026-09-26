// Opinionista.java
import java.net.*;
import java.io.*;

public class Opinionista {
   
  public static void inviaComeStringa(int porta, Domanda p) {
    try (Socket sock = new Socket("localhost", porta);
      DataOutputStream dos =
        new DataOutputStream(sock.getOutputStream());
    ) {  dos.writeUTF(p.toString());
    } catch (IOException e) { e.printStackTrace();}
    System.out.println("- invio a " + porta);
  } 
  
  public static Domanda riceviComeStringa(int porta) {
    Domanda p = null;
    try ( 
      ServerSocket servsock = new ServerSocket(porta); 
      Socket sock = servsock.accept();
      DataInputStream dis =
         new DataInputStream(sock.getInputStream());
    ) {
      p = new Domanda(dis.readUTF());
    } catch (IOException e) { e.printStackTrace();}
    System.out.println("- ricevo");
    return p;
  }
  
  public static void main(String[] args) {
    System.out.println("- sono " + args[0]); //2
    Domanda d;            
    if (args.length > 3) { // e' interrogante
      d = new Domanda(args[3], Integer.parseInt(args[4]), Integer.parseInt(args[0])); //1
      d.esprimiOpinione(Double.parseDouble(args[2])); //2
      System.out.println(d); //3
      if (d.sufficientiOpinioni()) //11(a) 
        System.out.println(d.elaboraRisposta()); //11.1(a)
      else {
        inviaComeStringa(Integer.parseInt(args[1]), d); //4      
        d = riceviComeStringa(Integer.parseInt(args[0])); //9
        System.out.println(d); //10
        if (d.sufficientiOpinioni()) { //11(a)
            System.out.println(d.elaboraRisposta()); //11.1(a)
            inviaComeStringa(Integer.parseInt(args[1]), d); //11.2(a)
            riceviComeStringa(Integer.parseInt(args[0])); //16.1(a)
        }
      }
    }
    else {  //non è interrogante
      d = riceviComeStringa(Integer.parseInt(args[0])); //5
      d.esprimiOpinione(Double.parseDouble(args[2])); //6
      System.out.println(d); //7
      if (d.sufficientiOpinioni()) { //8(a) 
        inviaComeStringa(d.portaOpinionistaInterrogante(), d); //8.1(a)      
        d = riceviComeStringa(Integer.parseInt(args[0])); //12
        System.out.println(d); //13
        System.out.println(d.elaboraRisposta()); //14
        inviaComeStringa(d.portaOpinionistaInterrogante(), d); //15.1(a)      
      } else { //8(b)
        inviaComeStringa(Integer.parseInt(args[1]), d); //8.1(b)
        d = riceviComeStringa(Integer.parseInt(args[0])); //12
        System.out.println(d); //13
        System.out.println(d.elaboraRisposta()); //14
        inviaComeStringa(Integer.parseInt(args[1]), d); //15.1(b)
      }
    }      
  }    
}

