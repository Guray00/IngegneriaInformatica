// Terminale.java
import java.net.*;
import java.io.*;
import java.sql.*;

public class Terminale {
private static int portaRicezione, portaInvio;

  public static void invia(int porta, Parametro p) {
    try (Socket sock = new Socket("localhost", porta);
      DataOutputStream dos =
        new DataOutputStream(sock.getOutputStream());
    ) {  dos.writeUTF(p.toString());
    } catch (IOException e) { e.printStackTrace();}
    visualizzaSuLog("invia", p.toString()); //2
  }

  public static Parametro ricevi() {
    Parametro p = null;
    try (
      ServerSocket servsock = new ServerSocket(portaRicezione);
      Socket sock = servsock.accept();
      DataInputStream dis =
         new DataInputStream(sock.getInputStream());
    ) {
      p = new Parametro(dis.readUTF());
    } catch (IOException e) { e.printStackTrace();}
    visualizzaSuLog("ricevi", p.toString()); //2
    return p;
  }

  public static void visualizzaSuLog(String operazione, String risultato) {
    try (
      Connection co = DriverManager.getConnection("jdbc:mysql://localhost:3306/terminale", "root","");
      PreparedStatement ps = co.prepareStatement("INSERT INTO log VALUES (?,?,?)");
    ) {
      ps.setInt(1, portaRicezione); ps.setString(2, operazione); ps.setString(3, risultato);
      ps.executeUpdate();
    } catch (SQLException e) { System.err.println(e.getMessage());}
  }

  public static void main(String[] args) {
    portaRicezione = Integer.parseInt(args[1]);
    portaInvio = Integer.parseInt(args[2]);
    Parametro p;
    if (args[1].equals("8080")) { // è la radice
      visualizzaSuLog("inizio", "*****************************");
      p = new Parametro(Double.parseDouble(args[0])); //1
      visualizzaSuLog("nuovoParametro", p.toString()); //2
      invia(portaInvio, p); //3
      p = ricevi(); //6
      visualizzaSuLog("calcolaParametro", Double.toString(p.calcolaParametro())); //7
      visualizzaSuLog("fine", "*****************************");
    }
    else {  //non è la radice
      p = ricevi(); //4
      if (p.stabilitaCampioni()) {  //5.a
        invia(portaInvio, p); //5.a.1
      } else { //5.b
        p.aggiungiCampione(Double.parseDouble(args[0])); //5.b.1
        visualizzaSuLog("aggiungiCampione", p.toString()); //5.b.2
        if (args.length < 4) { //5.b.3.c foglia
          invia(portaInvio, p); //5.b.3.c.1
        } else { // 5.b.3.d nodo
          if (!p.stabilitaCampioni()) { //5.b.3.d.e nodo e campioni instabili
            invia(Integer.parseInt(args[3]), p); //5.b.3.d.e.1
            p = ricevi(); //5.b.3.d.e.2
          }
          invia(portaInvio, p); //  //5.b.3.d.1
        }
      }
    }
  }
}
