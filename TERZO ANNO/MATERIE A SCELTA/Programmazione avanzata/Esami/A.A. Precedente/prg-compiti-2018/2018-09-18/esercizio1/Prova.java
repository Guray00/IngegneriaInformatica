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
public class Prova {
    public static void main(String[] args) throws Exception {
        EsecutoreFuturo ef = new EsecutoreFuturo();
        Compito c1 = new NumeroPrimoCompito(1073676287, System.currentTimeMillis() + 10000, 1000);
        ef.assegna(c1);
        System.out.println("Assegnato primo compito");
        Compito c2 = new NumeroPrimoCompito(1017777, System.currentTimeMillis() + 12000, 5000);
        ef.assegna(c2);
        System.out.println("Assegnato secondo compito");
        
        
        boolean r1 = (boolean) c1.dammiRisultato();
        System.out.println("Preso risultato");
        System.out.println(r1);

        boolean r2 = (boolean) c2.dammiRisultato();
        System.out.println("Preso risultato");
        System.out.println(r2);
        
    }
}
