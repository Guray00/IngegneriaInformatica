// PCList.java
import java.net.*;
import java.io.*;
import java.util.*;
import com.thoughtworks.xstream.*;
import java.sql.*;

 public class PCList {
    private static int receivePort, sendPort;
    
 public static void configure(int rp, int sp) {
    receivePort = rp; sendPort = sp;
  }
    
  public static void send(PCStatement o) {
    try (Socket sock = new Socket("localhost", sendPort);
      DataOutputStream dos =
        new DataOutputStream(sock.getOutputStream());
    ) {  dos.writeUTF((new XStream()).toXML(o));
    } catch (IOException e) { e.printStackTrace();}
    System.out.println("- invio a " + sendPort);
  } 
  
  public static PCStatement receive() {
    PCStatement o = null;
    try ( 
      ServerSocket servsock = new ServerSocket(receivePort); 
      Socket sock = servsock.accept();
      DataInputStream dis =
         new DataInputStream(sock.getInputStream());
    ) { o = (PCStatement)(new XStream()).fromXML(dis.readUTF());
    } catch (IOException e) { e.printStackTrace();}
    System.out.println("- ricevo");
    return o;
  }

  private static ArrayList read() {
    try {
      Connection co = DriverManager.getConnection("jdbc:mysql://localhost:3306/pclist", "root","");
      PreparedStatement ps = co.prepareStatement("SELECT xmlArrayList FROM pclist WHERE receivePort = ?");
      ps.setInt(1,receivePort);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
        String x = rs.getString("xmlarraylist");
        return (ArrayList) (new XStream().fromXML(x));
      }
    } catch (SQLException e) { System.err.println(e.getMessage());}
    return null;
  }
    
  private static void write(ArrayList a) {
    String x = (new XStream()).toXML(a);
    try (
      Connection co = DriverManager.getConnection("jdbc:mysql://localhost:3306/pclist", "root","");
      PreparedStatement ps = co.prepareStatement("UPDATE pclist SET xmlarraylist = ? WHERE receiveport = ?");
    ) {
      ps.setInt(2,receivePort); ps.setString(1, x);
      System.out.println("rows affected: " + ps.executeUpdate());
    } catch (SQLException e) { System.err.println(e.getMessage());}
  } 
  
  public static void create(PCStatement o) {
    write(new ArrayList());
    System.out.println((new XStream()).toXML(o) + "\nCreato:\n" + read());
    send(o);
    if (o.senderPort == receivePort)
      receive(); //08
  }
  
  public static void add(PCStatement o) {
    ArrayList al = read();
    int dimensioneDesiderata = 0;
    while(al.size() > dimensioneDesiderata) { //01
      send(o); //02
      o = receive(); //03          
      dimensioneDesiderata++; //04
    } //05
    al.add(o.item); 
    write(al);
    System.out.println((new XStream()).toXML(o) + "\nInserito:\n" + read());
  }

  public static void remove(PCStatement o) {
    ArrayList al = read();
    if (!al.remove(o.item)) { //06
      send(o); //07
      if (o.senderPort == receivePort)
        receive(); //08
    }
    else {
      write(al); //09
      System.out.println((new XStream()).toXML(o) + "\nEstratto:\n" + read());
    }
  }
          
  public static void main(String[] args) {
    System.out.println("- sono " + args[0]);
    configure(Integer.parseInt(args[0]), Integer.parseInt(args[1]));
    PCStatement o;
    if (args.length > 2)  //10
      o = new PCStatement (Integer.parseInt(args[0]), args[2], Double.parseDouble(args[3]));
    else  //11
      o =  receive();
    switch(o.statement) {
      case "create": create(o); break;
      case "add": add(o); break;
      case "remove": remove(o); break;
    }       
  }    
}

/* Note
01 finchè non trova la dimensione desiderata
02 invia al successivo
03 attende nel caso non si trovi la dimensione desiderata
04 incrementa la dimensione desiderata
05 se e' stata trovata la dimensione desiderata l'operazione non sara' propagata
06 se il valore non viene estratto
07 invia al prossimo se giro non completo
08 se richiedente rimani in attesa dell'ultimo
09 se viene estratto archivia e stampa
10 e' il richiedente 
11 non e' il richiedente
*/