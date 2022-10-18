/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Project/Maven2/JavaApp/src/main/java/${packagePath}/${mainClassName}.java to edit this template
 */

package it.unipi.programmaerrato;
import java.util.Scanner;

/**
 *
 * @author loren
 */
public class ProgrammaErrato {

    public static void main(String[] args) throws EccezioneA {
        Scanner s = new Scanner(System.in);
        int n;
        
        do {
            do {
                System.out.println("Quale funzione vuoi eseguire? (1 o 2, uscita: 0)");
                n = s.nextInt();
            } while(n != 1 && n != 2 && n != 0);
            try {
                ClasseErr e = new ClasseErr();
                switch(n){
                    case 1: 
                        e.metodo1();
                        break;
                    case 2:
                        e.metodo2();
                        break;
                    case 0:
                        return;
                }
                System.out.println("NON e' stata lanciata alcuna eccezione");
            } catch(EccezioneC e){
                if(!e.getMessage().equals("")) System.out.println(e.getMessage());
                else System.out.println("NO CODE: E' stata lanciata la eccezione C");
            } catch(EccezioneB e){
                if(!e.getMessage().equals("")) System.out.println(e.getMessage());
                else System.out.println("NO CODE: E' stata lanciata la eccezione B");
            } catch(EccezioneA e){
                if(!e.getMessage().equals("")) System.out.println(e.getMessage());
                else System.out.println("NO CODE: E' stata lanciata la eccezione A");
            } 
        } while(true);    
    }
}
