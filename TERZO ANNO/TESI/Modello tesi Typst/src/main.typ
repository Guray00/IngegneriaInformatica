#import "template.typ": *

#import "@preview/cetz:0.1.2"

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Un fantastico titolo per la mia tesi di laurea!",
  author: "Nome Cognome",
  speakers: ("Prof. xx xx", "Ing. yy yy"),
  logo: "./images/unipi.svg",
  abstract: "abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract abstract ",
  bib: "Bibliografia.bib"
)

= Questo è un capitolo

== Questa è una sezione

=== Questa è una sottosezione

#figure(image("images/github.svg", height: 7.5em), caption: "Questa è un'immagine") <github>

É possibile riferire l'immagine, una volta assegnatagli una label ottenendo il seguente risultato: @github.

Questa è una citazione #cite(<LabelPerLaCitazione>)

=== Questa è un'altra sottosezione

Quello che segue è un esempio di codice. 

```cpp
#include <iostream>
#include <cmath>
using namespace std;

// Codice fittizio 1 2 3 check

void ciaoMarco(char* matr, int h, int w){
	for(int i=0; i<h; i++){
		for (int j=0; j<w; j++)
			cout << *( matr + i*w +j) << ' ';
		cout << endl;
	}
}

bool isThisRight (int x, int y){
	double eq= pow(0.1 * x - 1 .5 ,2) + pow(0.1 * y - 1.2 ,2);
	if(eq<1) return true;
	else return false;
}

bool isThisLeft (int x, int y){
	double eq = pow(0.1 * x - 3.5 ,2) + pow(0.1 * y - 1.2 ,2);
    if(eq < 1) return true;
    else return false;
}

bool AAAA (int x, int y){
	double eq= pow( 0.1*x-2.5 ,2) + pow( 0.1*y-5.8 ,2);
    if( eq<1 ) return true;
    else return false;
}

bool nomeSerio(int x, int y){
	if (x>15 && x<35 && y<60 && y>12) return true;
	else return false;
}
```

=== Questa è un'ennesima sezione

=== Sottosezione con una tabella

#figure(table(
  columns: (auto, auto, auto),
  inset: 10pt,
  align: horizon,
  [], [*Tempo di attesa*], [*Dati scaricati*],
  [*Senza cose \ e Online*], [709 ms], [393 kB],
  [*Con cose \ e Online*], [151 ms], [321 kB],
  [*Senza cose \ e Offline*], [$infinity$], [0 kB],
  [*Con cose \ e Offline*], [0 ms], [0 kB],
), caption: "Prestazioni al variare di cose") 

#footnote[questa è una nota]