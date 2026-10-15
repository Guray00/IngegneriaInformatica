/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package es1;

import java.util.PriorityQueue;

/**
 *
 * @author aless_irdbul5
 */
public class EsecutoreFuturo implements Runnable {

    private static class Elemento implements Comparable<Elemento> {

        Compito comp;

        Elemento(Compito comp) {
            this.comp = comp;
        }

        @Override
        public int compareTo(Elemento o) {
            if (comp.getQuando() < o.comp.getQuando()) {
                return -1;
            }
            if (comp.getQuando() > o.comp.getQuando()) {
                return 1;
            }
            return 0;
        }

        @Override
        public String toString(){
            return comp.toString();
        }
    }

    private final Thread t;
    private final PriorityQueue<Elemento> pq;

    public EsecutoreFuturo() {
        pq = new PriorityQueue<Elemento>();
        t = new Thread(this);
        t.start();
    }

    public synchronized void assegna(Compito c) {
        Elemento el = new Elemento(c);
        pq.add(el);
        notify();
    }

    @Override
    public void run() {
        try {
            while (true) {
                Elemento e = attendiProssimoCompito();
                Compito c = e.comp;
                long start = c.getQuando();
                long tol = c.getTolleranza();
                if (start + tol > System.currentTimeMillis()) {
                    try {
                        c.esegui();
                    }catch(Exception ex) {
                        c.setException(ex);
                    }
                } else {
                    c.setException(new TroppoRitardoException());
                }
            }
        } catch (InterruptedException i) {
            System.out.println("Esco");
        }
    }

    private synchronized Elemento attendiProssimoCompito() throws InterruptedException {
        while (pq.isEmpty() || System.currentTimeMillis() < pq.peek().comp.getQuando()) {
            long attesa = pq.isEmpty() ? 0 :  pq.peek().comp.getQuando() - System.currentTimeMillis();
            wait(attesa);
        }
        return pq.poll();
    }
}
