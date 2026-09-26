package it.unipi.dii;

/**
 * Il fornitore mette sul bancone un ingrediente alla volta.
 * Se il bancone non è vuoto attende. 
 * Se, dopo aver messo un ingrediente sul bancone, rimane bloccato per 3 secondi 
 * sostituisce l'ingrediente precedentemente messo con l'altro.
 */
public class Fornitore extends Thread {
    
    // Oggetto bancone
    private final Bancone b;
    
    public Fornitore(String nome, Bancone b) {
        super(nome);
        this.b = b;
    }
    
    @Override
    public void run() {
        Ingrediente r = Ingrediente.aCaso();
        while(true) {
            try {
                // Mette l'ngrediente sul bancone
                b.mettiIngrediente(r);
                // Sceglie un nuovo ingrediente
                r = Ingrediente.aCaso();
            } catch (InterruptedException ex) {
                System.out.println(getName() + ": ero bloccato, cambio ingrediente.");
                // Se c'era latte mette caffe e viceversa
                Ingrediente presente = b.getLevato();
                Ingrediente altro = (presente == Ingrediente.CAFFE ? Ingrediente.LATTE : Ingrediente.CAFFE);
                r = altro;
            }
        }
    }
}
