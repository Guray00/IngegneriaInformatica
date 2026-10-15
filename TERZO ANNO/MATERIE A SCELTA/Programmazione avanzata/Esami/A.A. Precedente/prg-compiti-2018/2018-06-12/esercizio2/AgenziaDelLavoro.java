// AgenziaDelLavoro.java

import java.net.*;
import java.io.*;
import java.sql.*;

public class AgenziaDelLavoro {
private static int portaRicezione, portaInvio;

  public static void invia(int porta, RichiestaDiCompetenze r) {
    try (Socket sock = new Socket("localhost", porta);
      DataOutputStream dos =
        new DataOutputStream(sock.getOutputStream());
    ) {  dos.writeUTF(r.toString());
    } catch (IOException e) { e.printStackTrace();}
    visualizzaSuLog(java.time.LocalTime.now().toString(), "invia", r.toString()); //2,...
  } 
  
  public static RichiestaDiCompetenze ricevi() {
    RichiestaDiCompetenze r = null;
    try ( 
      ServerSocket servsock = new ServerSocket(portaRicezione); 
      Socket sock = servsock.accept();
      DataInputStream dis =
         new DataInputStream(sock.getInputStream());      
    ) {
      r = new RichiestaDiCompetenze(dis.readUTF());
    } catch (IOException e) { e.printStackTrace();}
    visualizzaSuLog(java.time.LocalTime.now().toString(), "ricevi", r.toString()); //5,8,11
    return r;
  }
  
  public static void visualizzaSuLog(String marcaTemporale, String operazione, String risultato) {
    try (
      Connection co = DriverManager.getConnection("jdbc:mysql://localhost:3306/agenziadellavoro", "root","");
      PreparedStatement ps = co.prepareStatement("INSERT INTO log VALUES (?,?,?,?)");
    ) {
      ps.setString(1,marcaTemporale); ps.setInt(2, portaRicezione); ps.setString(3, operazione); ps.setString(4, risultato);
      ps.executeUpdate();
    } catch (SQLException e) { System.err.println(e.getMessage());}
  }
    
  public static void main(String[] args) {
    portaRicezione = Integer.parseInt(args[0]);
    portaInvio = Integer.parseInt(args[1]);
    RichiestaDiCompetenze r;            
    if (args.length==3 && args[2].endsWith("?")){   // richiedente
      visualizzaSuLog(java.time.LocalTime.now().toString(), "inizio", "*****************************");
      r = new RichiestaDiCompetenze(args[2], portaRicezione); //1
      visualizzaSuLog(java.time.LocalTime.now().toString(), "nuovaRichiesta", r.toString()); //2
      invia(portaInvio, r); //3
      r = ricevi(); //7
      invia(portaInvio, r); //9
      ricevi(); //13
      visualizzaSuLog(java.time.LocalTime.now().toString(), "fine", "*****************************");
    } else {  // altri
      r = ricevi(); //4 oppure 10
      if (args.length==2) { // 6.b oppure //10
        invia(portaInvio, r); //6.b.1 oppure 12
        if (!r.esistePortaProponente()) { // deve ancora fare 10
          r = ricevi(); //10
          invia(portaInvio, r); //12   
        } // se ha fatto 10 allora non deve fare altro
      }
      else if (args[2].endsWith("!")) { // 6.a ha competenze
        r.inserisciPortaProponente(portaRicezione);  //6.a.1
        invia(r.restituisciPortaRichiedente(), r); //6.a.2 
        r = ricevi(); //10
        invia(portaInvio, r); //12   
      }
    }
  }   
}