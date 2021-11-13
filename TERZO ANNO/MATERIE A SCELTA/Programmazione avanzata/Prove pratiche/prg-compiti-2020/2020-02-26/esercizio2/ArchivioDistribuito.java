// ArchivioDistribuito.java
import java.net.*;
import java.io.*;
import java.util.*;
import com.thoughtworks.xstream.*;
import java.nio.file.*;

 public class ArchivioDistribuito {
    private static int portaRicevi, portaInvia;
    
 public static void inizializzaArchivio(int pR, int pI) {
    portaRicevi = pR; portaInvia = pI;
  }
    
  public static void inviaOperazione(Operazione o) {
    try (Socket sock = new Socket("localhost", portaInvia);
      DataOutputStream dos =
        new DataOutputStream(sock.getOutputStream());
    ) {  dos.writeUTF((new XStream()).toXML(o));
    } catch (IOException e) { e.printStackTrace();}
    System.out.println("- invio a " + portaInvia);
  } 
  
  public static Operazione riceviOperazione() {
    Operazione o = null;
    try ( 
      ServerSocket servsock = new ServerSocket(portaRicevi); 
      Socket sock = servsock.accept();
      DataInputStream dis =
         new DataInputStream(sock.getInputStream());
    ) { o = (Operazione)(new XStream()).fromXML(dis.readUTF());
    } catch (IOException e) { e.printStackTrace();}
    System.out.println("- ricevo");
    return o;
  }

  private static ArrayList leggiArchivio() {
    try { String x = new String(Files.readAllBytes(Paths.get(portaRicevi + "_archivio.xml")));
    return (ArrayList) (new XStream().fromXML(x));
    } catch (IOException e) { e.printStackTrace(); }
    return null;
  }
    
  private static void scriviArchivio(ArrayList a) {
    String x = (new XStream()).toXML(a);
    try { Files.write(Paths.get(portaRicevi + "_archivio.xml"), x.getBytes());
    } catch(IOException e) { e.printStackTrace(); }
  } 
  
  public static void crea(Operazione o) {
    scriviArchivio(new ArrayList());
    System.out.println((new XStream()).toXML(o) + "\nCreato:\n" + leggiArchivio());
    inviaOperazione(o);
    if (o.portaRichiedente == portaRicevi)
      riceviOperazione(); //08
  }
  
  public static void inserisci(Operazione o) {
    ArrayList al = leggiArchivio();
    int dimensioneDesiderata = 0;
    while(al.size() > dimensioneDesiderata) { //01
      inviaOperazione(o); //02
      o = riceviOperazione(); //03          
      dimensioneDesiderata++; //04
    } //05
    al.add(o.valore); 
    scriviArchivio(al);
    System.out.println((new XStream()).toXML(o) + "\nInserito:\n" + leggiArchivio());
  }

  public static void estrai(Operazione o) {
    ArrayList al = leggiArchivio();
    if (!al.remove(o.valore)) { //06
      inviaOperazione(o); //07
      if (o.portaRichiedente == portaRicevi)
        riceviOperazione(); //08
    }
    else {
      scriviArchivio(al); //09
      System.out.println((new XStream()).toXML(o) + "\nEstratto:\n" + leggiArchivio());
    }
  }
          
  public static void main(String[] args) {
    System.out.println("- sono " + args[0]);
    inizializzaArchivio(Integer.parseInt(args[0]), Integer.parseInt(args[1]));
    Operazione o;
    if (args.length > 2)  //10
      o = new Operazione (Integer.parseInt(args[0]), args[2], Double.parseDouble(args[3]));
    else  //11
      o =  riceviOperazione();
    switch(o.operazione) {
      case "crea": crea(o); break;
      case "inserisci": inserisci(o); break;
      case "estrai": estrai(o); break;
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