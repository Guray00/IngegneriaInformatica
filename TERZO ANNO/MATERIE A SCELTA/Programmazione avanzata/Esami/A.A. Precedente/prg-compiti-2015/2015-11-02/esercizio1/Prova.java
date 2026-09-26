package esercizio1;

import java.util.Scanner;

public class Prova {

  public static void main(String[] args) {
    Strada s =  new Strada();
    Scanner sc = new Scanner(System.in);
    while(true){
      int c = sc.nextInt();
      if(c == 1) {
        new Auto(s).start(); 
      } else {
        new Pedone(s).start(); 
      } 
    }
  }
}
