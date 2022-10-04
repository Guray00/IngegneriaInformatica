//Esercizio-02
#include <iostream>
#include <vector>
using namespace std;

bool CheckPositivita(vector<int> &input);
int Somma(vector<int> &input);
int Prodotto(vector<int> &input);

int main(){
	vector<int>inputValori;
	int singoloValore;
	int numeroLetture;
	cin >> numeroLetture;
	for(int i=0; i<numeroLetture; ++i){
		cin >> singoloValore;
		inputValori.push_back(singoloValore);
	}

	cout<<Somma(inputValori)<<endl;
	cout<<Prodotto(inputValori)<<endl;
	if(CheckPositivita(inputValori)){
		cout<<"yes\n";
	}else{
		cout<<"no\n";
	}
}

//Funzione che verifica se tutti i valori dell'array sono > 0
bool CheckPositivita(vector<int> &input){
	for(int i=0; i<input.size(); ++i){
		if(input[i]<=0)
			return false;
	}
	return true;
}

//Funzione effettua la somma di tutti gli elementi del vettore
int Somma(vector<int> &input){
	int sommaRisultate=0;
	for(int i=0; i<input.size(); ++i){
		sommaRisultate+=input[i];
	}
	return sommaRisultate;
}

//Funzione effettua il prodotto di tutti gli elementi del vettore
int Prodotto(vector<int> &input){
	int prodottoRisultate=1;
	for(int i=0; i<input.size(); ++i){
		prodottoRisultate*=input[i];
	}
	return prodottoRisultate;
}
