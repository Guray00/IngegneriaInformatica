/******************************************************************************

Welcome to GDB Online.
GDB online is an online compiler and debugger tool for C, C++, Python, Java, PHP, Ruby, Perl,
C#, VB, Swift, Pascal, Fortran, Haskell, Objective-C, Assembly, HTML, CSS, JS, SQLite, Prolog.
Code, Compile, Run and Debug online from anywhere in world.

*******************************************************************************/
using namespace std;
#include <iostream>
#include "funzioni.h"



int main()
{
    /*
    //Primo Esempio
  int b=7; double c=4.1;
	// ...
	b= maxT1(3,b); 
	cout<<b<<endl;

	 //   tipo=int   max<int>(int,int)

		 
	c=maxT1(3.6,c);     
	cout<<c<<endl;*/
	// tipo = double   max<double>(double,double)
	
	//secondo esempio
/*	int b=2; double c=6.1, d; int array[2]={3,4}; 
	 
	cout << max(array[0],b)<<endl;	// OK: int max<int >(int,int) 

	d = maxT1(3.6,c);     		
		// OK: double max<double>(double, double)
    cout<<d<<endl;
	b = maxT1(3.6,c);     		
	// OK: double max<double>(double, double) e conversione
    cout<<b<<endl;
           	 //d = max(3,c);    errore: non si deduce il tipo: 
			       		// 3 e' intero, c e' double    */ 
// Esempio con vettori
/*
    int array1[2]={3,4}; 
    double array2[2]={3.5,4.8};

	primo(array1);  

		// 3     tipo=int      void primo<int>(int*)

	primo(array2);  

		// 3.5  tipo=double   void primo<double>(double*)
	/*	
	primoP(array1);   
     	
		// 3    tipo=int*      void primo<int*>(int*)

	primoP(array2);        	

	// 3.5    tipo=double*     void primo<double*>(double*) */
	
//	primoP1(array2);        // errore
	

	
//Funzioni modello con più parametri	
   /* int b=2; double c=6.1; 
	
	cout << maxT2(3,b)<<endl;      //  int max<int,int>(int,int)

		//    tipo1=int, tipo2= int

	b = maxT2(3,c);       //   int max<int,double>(int,double)

		//    tipo1=int, tipo2= double
    cout<<b<<endl;
    
    //tre parametri
   // b = nuovomax(3,c); 
    //cout<<b<<endl;*/


//Parametri espliciti di funzioni modello
/*
    double d;
	cout <<  maxT1<int>(3,5.5)<<endl;               
	      //  5    max<int>(int,int); conversione del parametro

	cout <<  maxT1<double>(3,5.5)<<endl;        
	       //  5.5 max<double>(double,double) conversione 		       //del parametro

	d= maxT1<int>(3,5.5); 
	      // max<int>(int,int); conversione del valore 	restituito  	      	     //  assegnato: 5
    cout<<d<<endl;*/

//Funzioni modello con variabili statiche

cout << maxT<int>(101,102) << endl;              // 1  102
cout << maxT<int>(101,102)<< endl;               // 2  102 
cout << maxT<double>(101,102) << endl;       // 1  102


}
