/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package es1;

/**
 *
 * @author aless_irdbul5
 */
public class NumeroPrimoCompito implements Compito {

    private final int tolleranza;
    private boolean finito;
    private Object risultato;
    private final int numero;
    private final long quando;
    private Exception ex;

    public NumeroPrimoCompito(int num, long q, int tol) {
        numero = num;
        quando = q;        
        tolleranza = tol;
    }

    @Override
    public synchronized void esegui() {
        boolean res = primo(numero);
        risultato = res;
        finito = true;
        notifyAll();
    }

    @Override
    public synchronized Object dammiRisultato() throws Exception {
        while (!finito) {
            wait();
        }
        if(ex != null)
            throw ex;
        return risultato;
    }

    @Override
    public synchronized boolean finito() {
        return finito;
    }

    @Override
    public int getTolleranza() {
        return tolleranza;
    }

    private boolean primo(int numero) {
        for (int i = 2; i < numero; i++) {
            if (numero % i == 0) {
                return false;
            }
        }
        return true;
    }

    @Override
    public long getQuando() {
        return quando;
    }

    @Override
    public synchronized void setException(Exception e) {
        finito = true;
        ex = e;
        notifyAll();
    }
    
    @Override
    public String toString(){
        return "[" + quando + ", " + tolleranza + "]";
    }
}
