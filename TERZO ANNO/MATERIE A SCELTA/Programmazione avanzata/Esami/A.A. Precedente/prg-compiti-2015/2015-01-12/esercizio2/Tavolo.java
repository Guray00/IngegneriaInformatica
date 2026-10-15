// Tavolo.java

import java.net.*;
import java.io.*;

public class Tavolo {
  public static void main(String[] args) {
    Taccuino taccuino = new Taccuino(Integer.parseInt(args[0]), args[1]);
    ServerSocket servsock;
    Socket sock;
    ObjectOutputStream oos;
    ObjectInputStream ois;

    try {
      servsock = new ServerSocket(8080);
      while(true) {
        sock = servsock.accept();
        oos = new ObjectOutputStream(sock.getOutputStream());
        ois = new ObjectInputStream(sock.getInputStream());
          oos.writeObject(taccuino);
          taccuino = (Taccuino)ois.readObject();
        ois.close();
        oos.close();
        sock.close();
      }
    } catch (Exception e) { e.printStackTrace();}
  }
}