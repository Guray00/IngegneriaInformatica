/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Project/Maven2/JavaApp/src/main/java/${packagePath}/${mainClassName}.java to edit this template
 */

package it.unipi.biblioteca;

import java.util.Arrays;

/**
 *
 * @author loren
 */
public class Biblioteca {
    private Libro[] libreria;
    
    public Biblioteca(int n){
        libreria = new Libro[n];
    }
    
    public boolean aggiungiLibro(Libro l){
       int j = 0;
       boolean spazio = false;
       for(int i=0; i<libreria.length; i++){
           if(libreria[i] == null) {
               j = i;
               spazio = true;
               break;
           }
       }
       if(!spazio) return false;
       libreria[j] = l;
       return true;
    }
    
    public Libro[] cercaPerAutore(Autore a){
        int nAutori = 0;
        for(Libro libro : libreria ){
            if(libro.getAutore().uguale(a)){
               nAutori ++;
            }
        }
        Libro[] libriTrovati = new Libro[nAutori];
        for(Libro libro : libreria ){
            if(libro.getAutore().uguale(a)){
               libriTrovati[(libriTrovati.length)-1] = libro;
            }
        }
        return libriTrovati;
    }
     
    public Libro[] cercaPerCognome(String c){
        int nAutori = 0;
        for(Libro libro : libreria ){
            if((libro.getAutore().getCognome().equals(c))){
               nAutori ++;
            }
        }
        Libro[] libriTrovati = new Libro[nAutori];
        for(Libro libro : libreria ){
            if((libro.getAutore().getCognome().equals(c))){
               libriTrovati[(libriTrovati.length)-1] = libro;
            }
        }
        return libriTrovati;
    }
    
    public Libro[] elenco(){
        return libreria;
    }
    
    public Libro[] cercaRecenti(Data d){
        int nLibri = 0;
        for(Libro libro : libreria ){
            if(libro.piuRecente(d)){
               nLibri ++;
            }
        }
        Libro[] libriTrovati = new Libro[nLibri];
        for(Libro libro : libreria ){
            if(libro.piuRecente(d)){
               libriTrovati[(libriTrovati.length)-1] = libro;
            }
        }
        return libriTrovati;
    }
       
    public boolean elimina(String t){
       int pos = 0;
       boolean trovato = false;
       for(int i=0; i<libreria.length;  i++){
           if(libreria[i].getTitolo().equals(t)) {
               pos = i;
               trovato = true;
               break;
           }
       }
       if(!trovato) return false;
       System.arraycopy(libreria, (pos+1), libreria, pos, (libreria.length - (pos +1)));
       libreria[libreria.length-1] = null;
       return true;
    }
    
    public String toString(Libro[] l){
        String out = "[\n";
        for(Libro libro : l){
            if(libro == null) break;
            String out2 = "\t[" + libro.getTitolo() + ", " + libro.getAutore().getNome() + " " + libro.getAutore().getCognome() + "]\n";
            out += out2;
        }
        out += "]\n";
        return out;
    }
    
    public static void main(String[] args) {
        Biblioteca b = new Biblioteca(3);
        Data d1 = new Data(27, 7, 2020);
        Data d2 = new Data(27, 01, 2001);
        Autore a1 = new Autore("Lorenzo", "Valtriani");
        Autore a2 = new Autore("GiacomoUrtis", null);
        Libro l1 = new Libro("Come Godere", a1, d1);
        Libro l2 = new Libro("Amore", a2, d2);
        b.aggiungiLibro(l1);
        b.aggiungiLibro(l2);
        System.out.println(b.toString(b.libreria));
        b.elimina(l2.getTitolo());
    }
}
