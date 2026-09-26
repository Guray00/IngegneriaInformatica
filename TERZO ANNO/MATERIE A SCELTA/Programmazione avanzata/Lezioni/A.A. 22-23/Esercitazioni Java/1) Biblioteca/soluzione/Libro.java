/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.unipi.biblioteca;

/**
 * 
 * @author loren
 */
public class Libro {
    private final String titolo;
    private final Autore autore;
    private final Data data;
    
    /**
     * 
     * @param t
     * @param a
     * @param d 
     */
    public Libro(String t, Autore a, Data d){
        titolo = t;
        autore = a;
        data = d;
    }
    
    boolean piuRecente(Data d){
        return data.confronta(d) > 0;
    }
    
    public String getTitolo(){
        return titolo;
    }
    
    public Autore getAutore(){
        return autore;
    }
    
    public Data getData(){
        return data;
    }
}
