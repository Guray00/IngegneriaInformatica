import java.io.*;

public class MaxFileProcessor extends FileProcessor {

  /* Richiama costruttore della superclasse */
  public MaxFileProcessor(String f) throws FileNotFoundException, IOException {
    super(f);
  }

  /* Trova il massimo nel blocco */
  protected byte processBlock(byte[] b) {
    byte x = b[0];
    for(int i=1; i<b.length; i++)
      if(b[i] > x)
        x = b[i];
    return x;
  }
}
