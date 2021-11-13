package it.unipi.dii;

/**
 * Ogni barista produce infiniti cappuccini.
 * Per produrre un cappuccino:
 *  1) attende che sul bancone ci sia un ingrediente (LATTE o CAFFE) e lo prende
 *  2) attende che sul bancone ci sia l'altro ingrediente (se al punto 1 ha preso 
 *     CAFFE attende LATTE e viceversa).
 */
public class Barista extends Thread {

    // Oggetto bancone condiviso tra baristi+fornitore
    private final Bancone b;
    
    // Crea un Barista dal nome specificato
    public Barista(String nome, Bancone b) {
        super(nome);
        this.b = b;
    }
    
    @Override
    public void run() {
        while(true) {
            try {
                // Prende il primo ingrediente
                Ingrediente i1 = b.prendiIngrediente(Ingrediente.NESSUNO);
                // Prende l'altro ingrediente
                Ingrediente i2 = b.prendiIngrediente(i1);
                System.out.println(getName() + ": ho preso " + i1 + " e poi " + i2 + ": cappuccino!!!");
            } catch (InterruptedException ex) {
                System.out.println(getName() + ": sono stato interrotto...");
            }
        }
    }
}
