import java.io.*;

public class Prova {
  public static void main(String[] args){
    try {
      Logger m = new Logger("logfile.txt", 5);
      new Produttore(0, 10, m).start();
      new Produttore(11, 100, m).start();
      new Produttore(101,103, m).start();    
    } catch (IOException e) {
      System.err.println(e.getMessage());
    }
  }
}
