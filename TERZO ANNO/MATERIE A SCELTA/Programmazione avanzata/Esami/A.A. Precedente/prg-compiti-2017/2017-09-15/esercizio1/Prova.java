import java.io.*;

public class Prova {
  public static void main(String[] args){
    try {
      Memorizzatore m = new Memorizzatore("aaa", 5);
      new Produttore(3, 10, m).start();    
      new Produttore(13, 100, m).start();    
      new Produttore(0, 3, m).start();    
    } catch (IOException e) {
      System.err.println(e.getMessage());
    }
  }
}
