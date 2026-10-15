// Partecipante.java

import java.net.*;
import java.io.*;
import com.thoughtworks.xstream.*;

public class Partecipante {
  public static void main(String args[]) {
      try ( 
        Socket sock = new Socket("localhost", 8080);
        ObjectOutputStream oos = new ObjectOutputStream(sock.getOutputStream());
        ObjectInputStream ois = new ObjectInputStream(sock.getInputStream())
      ) {
        Taccuino taccuino = (Taccuino)ois.readObject();
        taccuino.proponi(Integer.parseInt(args[0]), args[1]);
        XStream xstream = new XStream();
        System.out.println(xstream.toXML(taccuino));
        oos.writeObject(taccuino);
     } catch (Exception e) { e.printStackTrace();}
  }
}
