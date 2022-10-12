/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.unipi.biblioteca;

/**
 *
 * @author loren
 */
public class Data {
    private final int giorno;
    private final int mese;
    private final int anno;
     
    public Data(int giorno, int mese, int anno){
        this.giorno = giorno;
        this.mese = mese;
        this.anno = anno;
    }
    
    public int confronta(Data d){
        if(this.anno < d.anno) return -1;
        else if(this.anno > d.anno) return 1;
        else {
            if(this.mese < d.mese) return -1;
            else if(this.mese > d.mese) return 1;
            else {
                if(this.giorno < d.giorno) return -1;
                else if(this.giorno > d.giorno) return 1;
                else return 0;
            }
        }
    }
}
