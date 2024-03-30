//Soluzione personale Lorenzo Grassi
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

vector <string> nomi;
int N, H;

struct Nodo{

int H;
int chiave;
string nome;
Nodo* left;
Nodo* right;

Nodo(int k, string n, int h): chiave(k), nome(n), H(h), left(NULL), right(NULL){}

};


void insert(Nodo*& albero, int chiave, string nome, int h=0){

if(albero==NULL){
	albero = new Nodo(chiave, nome,h);
	return;
}
if(chiave<= albero->chiave)
	insert(albero->left, chiave,nome, h+1);
else if(chiave>albero->chiave)
	insert(albero->right, chiave,nome, h+1);
}

void inOrder(Nodo*& albero, int h){

if(albero){
	inOrder(albero->left, h);
	if(albero->H==h)
		nomi.push_back(albero->nome);
	inOrder(albero->right, h);
}
}

int main(){
cin>>N>>H;

int chiave;
string nome;
Nodo* albero= NULL;

for(int i=0; i<N;++i){
	cin>>chiave>>nome;
	insert(albero,chiave, nome);
}
inOrder(albero,H);

sort(nomi.begin(), nomi.end());

cout<<H<<endl;
for(int i=0; i< nomi.size(); ++i)
	cout<<nomi[i]<<endl;
}
