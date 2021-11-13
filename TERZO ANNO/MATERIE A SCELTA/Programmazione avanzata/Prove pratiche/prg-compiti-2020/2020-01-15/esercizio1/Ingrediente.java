package it.unipi.dii;

/**
 * Tipo enumerazione che rappresenta i due ingredienti del cappuccino e 
 * l'assenza di ingredienti
 * 
 */
public enum Ingrediente {
    
    NESSUNO, LATTE, CAFFE;
    
    /**
     * Restituisce un ingrediente a caso: LATTE o CAFFE
     * 
     * @return ingrediente a caso (LATTE o CAFFE) 
     */
    public static Ingrediente aCaso(){
        return Math.random() < 0.5 ? LATTE : CAFFE;
    }
}
