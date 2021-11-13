package it.unipi.dii;

/**
 * Classe di prova che crea un bancone, tre baristi e un fornitore
 * 
 */
public class Prova {
    public static void main(String[] args) {
        
        // Crea gli oggetti
        Bancone b = new Bancone();
        Barista b1 = new Barista("Barista 1", b);
        Barista b2 = new Barista("Barista 2", b);
        Barista b3 = new Barista("Barista 3", b);
        Fornitore f = new Fornitore("Fornitore", b);

        // Fa partire i thread
        b1.start();
        b2.start();
        b3.start();
        f.start();
    }
}
