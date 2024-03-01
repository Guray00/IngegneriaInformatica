/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.unipi.biblioteca;

/**
 *
 * @author loren
 */
public class Autore {
    private final String nome;
    private final String cognome;
    
    public Autore(String n, String c){
        nome = n;
        cognome = c;
    }
    
    public boolean uguale(Autore a){
        if(nome.equals(a.nome) && cognome.equals(a.cognome)) return true;
        else if(nome.equals(a.nome) && a.cognome == null) return true;
        else return (cognome.equals(a.cognome) && a.nome == null);
    }

    public String getNome() {
        return nome;
    }
    
    public String getCognome() {
        return cognome;
    }
    
    
    
}
