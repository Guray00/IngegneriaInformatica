package it.unipi.dii;

/**
 * Sul bancone può essere presente al più un ingrediente (latte o caffe). 
 * 
 */
public class Bancone {

    // L'ingrediente attualmente presente sul bancone
    private Ingrediente i = Ingrediente.NESSUNO;
    // Ingrediente che e' stato appena levato
    private Ingrediente levato;
    
    // Il fornitore si sblocca dopo questo ammontare di tempo
    private final long timeout = 3000;
    
    /**
     * Metodo chiamato dai baristi per prendere un ingrediente. 
     * 
     * @param p L'ingrediente gia' posseduto dal barista
     * @return L'ingrediente preso
     * @throws InterruptedException 
     */
    public synchronized Ingrediente prendiIngrediente(Ingrediente p) throws InterruptedException {
        // Il barista attende se il bancone e' vuoto o se non c'e' l'ingrediente diverso da p
        while(i == Ingrediente.NESSUNO || aspettaIngrediente(p))
            wait();
        // Prende l'ingrediente
        Ingrediente tmp = i;
        i = Ingrediente.NESSUNO;
        // Risveglia tutti i thread
        notifyAll();
        System.out.println(Thread.currentThread().getName() + ": ho preso " + tmp);
        return tmp;
    }

    public synchronized Ingrediente getLevato() {
        return levato;
    }
    
    /**
     * Metodo chiamato dal fornitore per mettere un nuovo ingrediente sul bancone.
     * 
     * @param n Il nuovo ingrediente.
     * @throws InterruptedException 
     */
    public synchronized void mettiIngrediente(Ingrediente n) throws InterruptedException {
        // Il fornitore si blocca se il bancone non e' vuoto (l'ingrediente messo in 
        // precedenza non e' stato ancora prelevato)
        while(i != Ingrediente.NESSUNO) {
            System.out.println(Thread.currentThread().getName() + ": il bancone non è vuoto, mi blocco.");
            wait(timeout);
            // Esce da wait() perche'
            //    - un barista ha preso l'ingrediente, il bancone e' adesso vuoto
            //    - e' scattato il timeout e il vecchio ingrediente e' ancora sul bancone
            if(i != Ingrediente.NESSUNO) {
                System.out.println(Thread.currentThread().getName() + ": nessuno può andare avanti, levo l'ingrediente (" + i + ")");
                levato = i;
                i = Ingrediente.NESSUNO;
                throw new InterruptedException();
             }
        }
        
        i = n;
        System.out.println(Thread.currentThread().getName() + ": ho inserito " + i);
        notifyAll();
    } 


    private boolean aspettaIngrediente(Ingrediente p) {
        switch(p){
            // Il barista non ha ingredienti, non deve attendere
            case NESSUNO: return false;
            // Il barista ha caffe, deve attendere latte
            case CAFFE: return i == Ingrediente.CAFFE;
            // Il barista ha latte, deve attendere caffe
            case LATTE: return i == Ingrediente.LATTE;
        }
        return true;
    }
}
