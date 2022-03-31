
#include <vector>
#include <iostream>
using namespace std;

int OrdinamentoControllato(vector<int> &input);

int main(){
	vector<int> inputValori;
	int numeroValori;
	int singoloValore;
	cin >> numeroValori;
	for(int i=0; i<numeroValori; ++i){
		cin>>singoloValore;
		inputValori.push_back(singoloValore);
	}
	cout<<OrdinamentoControllato(inputValori)<<endl;
}

int OrdinamentoControllato(vector<int> &input){
	int contatoreScambi=0;
	int valoreRiferimento;
	int indiceControllo;
	for(int i=1; i<input.size(); ++i){
		valoreRiferimento=input[i];
		indiceControllo=i-1;
		while(indiceControllo>=0 && input[indiceControllo]>valoreRiferimento){
			++contatoreScambi;
			input[indiceControllo+1]=input[indiceControllo];
			--indiceControllo;
		}
		input[indiceControllo+1]=valoreRiferimento;
	}
	return contatoreScambi;
}
