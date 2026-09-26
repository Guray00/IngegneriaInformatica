// Opinionista.java
import java.net.*;
import java.io.*;
import java.sql.*;

public class Opinionista {
  private static int portaRicezione, portaInvio;
  
  public static void invia(int porta, Domanda d) {
    try (Socket sock = new Socket("localhost", porta);
      DataOutputStream dos =
        new DataOutputStream(sock.getOutputStream());
    ) {  dos.writeUTF(d.toString());
    } catch (IOException e) { e.printStackTrace();}
    visualizzaSuLog("invia", d.toString());
  } 
  
  public static Domanda ricevi() {
    Domanda d = null;
    try ( 
      ServerSocket servsock = new ServerSocket(portaRicezione); 
      Socket sock = servsock.accept();
      DataInputStream dis =
         new DataInputStream(sock.getInputStream());
    ) {
      d = new Domanda(dis.readUTF());
      visualizzaSuLog("ricevi", d.toString());
    } catch (IOException e) { e.printStackTrace();}
    return d;
  }
  
  public static void visualizzaSuLog(String operazione, String risultato) {
    try (
      Connection co = DriverManager.getConnection("jdbc:mysql://localhost:3306/opinionista", "root","");
      PreparedStatement ps = co.prepareStatement("INSERT INTO log VALUES (?,?,?)");              
    ) {
      ps.setInt(1, portaRicezione); ps.setString(2, operazione); ps.setString(3, risultato);
      ps.executeUpdate();
    } catch (SQLException e) { System.err.println(e.getMessage());}
  } 
  
  public static void main(String[] args) {
    portaRicezione = Integer.parseInt(args[0]);
    portaInvio = Integer.parseInt(args[1]);
    Domanda d;            
    if (args.length > 3) { // e' interrogante
      visualizzaSuLog("inizio", "**********************************************");
      d = new Domanda(args[3], Integer.parseInt(args[4]), portaRicezione); //1
      d.esprimiOpinione(Double.parseDouble(args[2])); //2
      visualizzaSuLog("esprimiOpinione", d.toString()); //3
      if (d.sufficientiOpinioni()) //11(a) 
        visualizzaSuLog("elaboraRisposta",Double.toString(d.elaboraRisposta()));//11.1(a)
      else {
        invia(portaInvio, d); //4  
        d = ricevi(); //9,10
        if (d.sufficientiOpinioni()) { //11(a)
            visualizzaSuLog("elaboraRisposta", Double.toString(d.elaboraRisposta())); //11.1(a)
            invia(portaInvio, d); //11.2(a)
            ricevi(); //16.1(a)
        }
      }
      visualizzaSuLog("fine", "**********************************************");
    }
    
    else {  //non è interrogante
      d = ricevi(); //5
      d.esprimiOpinione(Double.parseDouble(args[2])); //6
      visualizzaSuLog("esprimiOpinione", d.toString()); //7
      if (d.sufficientiOpinioni()) { //8(a) 
        invia(d.portaOpinionistaInterrogante(), d); //8.1(a)      
        d = ricevi(); //12,13
        visualizzaSuLog("elaboraRisposta", Double.toString(d.elaboraRisposta())); //14
        invia(d.portaOpinionistaInterrogante(), d); //15.1(a)      
      } else { //8(b)
        invia(portaInvio, d); //8.1(b)
        d = ricevi(); //12, 13
        visualizzaSuLog("elaboraRisposta", Double.toString(d.elaboraRisposta())); //14
        invia(portaInvio, d); //15.1(b)
      }
    }      
  }    
}

