/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.unipi.programmaerrato;

/**
 *
 * @author loren
 */
public class ClasseErr {
    void metodo1(){
     if(Math.random() <= 0.1) throw new EccezioneC("E' stata lanciata l'eccezione C");   
    }
    void metodo2() throws EccezioneA {
      if(Math.random() <= 0.5) throw new EccezioneA("E' stata lanciata l'eccezione A");
      throw new EccezioneB("E' stata lanciata l'eccezione B");
    }
}
