#include <iostream>
#include <cstring>
#include <vector>

using namespace std;

//exchange generica
/*
void exchange(int& a,int& b){
    int c=a;
    a=b;
    b=c;
}
*/

//VAGLINI, cose inutili(MCD,Euclide,setaccio eratostene,stringa palindroma)
/*
//calcola il massimo comun divisore
int MCD(int x,int y){
    while (x!=y)
        if (x<y)y=y-x;
        else x=x-y;
    return x;
}

//Algoritmo di Euclide mcd
int MCD(int x,int y){
    while (y!=0){
        int k=x;
        x=y;
        y=k%y;
    }
    return x;
}

//setaccio di eratostene per i numeri primi
void setaccio(int n){
    bool primi[n];
    primi[0]= false; primi[1]= false;
    for (int i = 2; i < n; ++i) { //inizializza
        primi[i]= true;
    }
    int i=1;

    for (i++; i*i<n ; ++i) { //scorre a partire da 2 (gli altri sono sicuramete primi)
        while (!primi[i])i++; //cerca il prossimo possibile primo
        for (int k = i*i; k <n ;k+=i) { //scorri i numeri successivi a partire da i*i, cancellando i multipli
            primi[k]= false;
        }
        for (int j = 2; j < n ; ++j) {
            if (primi[j])cout<<j<<endl; //stampa i numeri primi
        }
    }
}

 //stringa palindroma
int palindroma(char* a, int j,int i=0){
    if (j<i)return 1;
    if (a[i]==a[j])return palindroma(a,i+1,j-1);
    return 0;
}
*/

//fibonacci(tutti e tre)                       b,b+a
/*
//hanoi e divite et impera non li metto perchè pseudocodice (stanno in slide 4 vaglini)

int fibonacci1 (int n){ //(2^n)
    if (n==0)return 0;
    if (n==1)return 1;
    return fibonacci1(n-1) + fibonacci1(n-2);
}

int fibonacci2(int n) {//(n)
    int k;
    int j = 0;
    int f = 1;
    for (int i=1;i<=n;i++){
        k=j;j=f;f=k+j;
    }
    return j;
}

int fibonacciricorsivo(int n, int a=0, int b=1){ //(n)
    if(n==0)return a;
    return fibonacciricorsivo(n-1,b,a+b);
}
*/


/////////////////////////////sorting (Quelli sui confronti non scendono più di nlogn)

//boubblesort    (n^2   scambi n^2)
/*
void bubbleSort(int *vett, int n) {
    for (int i = 0; i < n; ++i) {
        for(int j = n-1; j > i; j--){
            if(vett[j-1]>vett[j])
                exchange(vett[j-1],vett[j]);
        }
    }
}
*/

//selectionsort    (n^2   scambi n)
/*
void selectionSort(int* vett, int n) {
    for (int i = 0; i < n; ++i) {
        int min = i;
        for (int j = i+1; j < n; ++j)
            if(vett[j]<vett[min]) min = j;
        exchange(vett[i],vett[min]);
    }
}
*/

//insertionsort  (n^2 n^2 n)
/*
void insertionSort(int a[],int len){
    int mano=0;
    int occhio=0;
    for (int i = 1; i < len; ++i) {
        mano=a[i];
        occhio=i-1;
        while (occhio>=0 && a[occhio]>mano){
            a[occhio+1]=a[occhio];
            --occhio;
        }
        a[occhio+1]=mano;
    }
}

//versione ricorsiva

void ins(int* a, int dim,int i=1){
    if (i<dim) {
        int mano = a[i];
        int occhio = i - 1;
        while (occhio >= 0 && a[occhio] > mano) {
            a[occhio + 1] = a[occhio];
            --occhio;
        }
        a[occhio + 1] = mano;
        ins(a, dim,++i);
    }
}
*/

//QuicKsort  (n^2 nlogn nlogn)
/*
void quicksort(int A[], int inf, int sup){
    int perno=A[(inf+sup)/2];
    int s=inf;
    int d=sup;

    while (s<=d){
        while (A[s]<perno)s++;
        while (A[d]>perno)d--;
        if (s>d)break;
        exchange(A[s],A[d]);
        s++;
        d--;
    }

    if (inf<d)quicksort(A,inf,d);
    if (s<sup)quicksort(A,s,sup);
}

*/


//mergesort con liste (nlogn nlogn nlogn)
/*
///////////mergesort con liste

void split(Elem* & s1, Elem* &s2){ //n
    if (!s1 || !(s1->next))return; //se è vuota s1 o c'è un solo elemento, non mi serve andare avanti

    Elem* p=s1->next;
    s1->next=p->next;
    p->next=s2;
    s2=p;
    split(s1->next,s2);
}

void merge(Elem* &s1, Elem* &s2){ //n
    if (!s2)return;
    if (!s1){
        s1=s2;
        return;}

    if (s1->info<=s2->info) merge(s1->next,s2);

    else {merge(s2->next,s1);
    s1=s2;}
}

void mergeSort(Elem* & s1){ //nlogn
    if (!s1 || !(s1->next))return;
    Elem* s2= nullptr;

    split(s1,s2);
    mergeSort(s1);
    mergeSort(s2);
    merge(s1,s2);

}
*/

//mergesort con array
/*
void merge(int* v, int inf, int sup) {
    int aux[++sup];
    for(int i = 0; i < sup; i++) aux[i] = v[i];

    int i, a, b, mean;
    i = a = inf;
    b = mean = 1+(inf+sup-1)/2;
    while(a<mean && b<sup)
        v[i++] = (aux[a] < aux[b]) ? aux[a++] : aux[b++];
    while(a<mean) v[i++] = aux[a++];
    while(b<sup) v[i++] = aux[b++];
}

void mergeSort(int *v, int inf, int sup) {
    if(inf==sup) return;

    int mean = (inf+sup)/2;
    mergeSort(v,inf,mean);
    mergeSort(v,mean+1,sup);
    merge(v,inf,sup);
}
*/

//countingsort (n+k)
/*
void countingsort(int A[],int k, int n){
    int C[k+1]; int i ,j;

    for (i = 0; i <=k; ++i) {
        C[i]=0;
    }

    for (j = 0; j < n;j ++) {
        C[A[j]]++;
    }
    j=0;
    for (i = 0; i<=k ; i++) {
        while (C[i]>0){
            A[j]=i;
            C[i]--;
            j++;
        }
    }
}
*/

//raddixsort  (d(n+k))
/*
void bucketSort(int *v, int n, int b, int t) {
    std::queue<int> bucket[b];
    for (int i = 0; i < n; ++i) {
        int c = (v[i]/t)%10;
        bucket[c].push(v[i]);
    }
    int j = 0;
    for (int i = 0; i < b; ++i) {
        while(!bucket[i].empty()){
            v[j++] = bucket[i].front();
            bucket[i].pop();
        }
    }
}


void bucket(int* v, int n, int b, int t){
    elem* bucket[b];
    for (int i = 0; i < b; i++) bucket[i] = nullptr;
    for (int i = 0; i < n; ++i) {
        int c = (v[i]/t)%10;
        if(!bucket[c]){
            bucket[c] = new elem(v[i]);
        }else {
            elem *last = bucket[c];
            while(last->next) last = last->next;
            last->next = new elem(v[i]);
        }
    }
    int j = 0;
    for (int i = 0; i < b; ++i) {
        while(bucket[i]){
            v[j++] = bucket[i]->info;
            elem* aux = bucket[i];
            bucket[i] = aux->next;
            delete aux;
        }
    }
}
void radixSort(int *v, int n) {
    int t = 1;
    while(check(v,n,t)){
        bucket(v,n,10,t);
        t*=10;
    }
}


bool check(int *v, int n, int t) {
    for (int i = 0; i < n; ++i) {
        if((v[i]/t)%10) return true;
    }
    return false;
}
*/




//////////////////////////////////////////algoritmi di ricerca



//search(linear e bin)
/*

int linearsearch(int A[], int x, int dim, int i=0){ //(n)
    if (i==dim)return 0;
    if (A[i]==x)return 1;
    return linearsearch(A,x,dim,i+1);
}


int binsearch(int A[], int x, int i,int j){ //ricorda che il vettore deve essere ordinato    (logn)
    if (i>j)return 0;
    int k=(i+j)/2;
    if (x==A[k])return 1;
    if (x<A[k])return binsearch(A,x,i,k-1);
    else return binsearch(A,x,k+1,j);
}
*/

//hash (ricerca più efficiente non basata su confronti)
/*
////////////////////////////hash


//per indirizzamento aperto e legge di scansione lineare

int h(x){
    return x%k;
}
bool hashSearch(int * A, int k, int x){
    int i=h(x);
    for (int j = 0; j < k; ++j) {
        int pos=(i+j)%k; //array circolare
        if (A[pos]==-1)return false; //caso di prima posizone libera(da lì in poi non si può trovare sicuramente l'elemento)
        if (A[pos]==x)return true;      //ATTENZIONE: ricorda di non mettere qui opzione del -2 (le eliminazioni stanno anche dentro i cluster)
    }
    return false;//caso in cui è tutto occupato ma non trovo nuòòa
}

int hashInsert(int* A,int k,int x){
    int i=h(x);
    int b=0;
    for (int j = 0;!b && j < k; ++j) {
        int pos=(i+j)%k;
        if (A[pos]==-1){  //Se c'è cancellazione bisogna aggiungere ||A[pos]==-2
            A[pos]=x;
            b=1;
        }
    }
    return b;
}

//non nelle slide(aggiunta da me per completezza)
bool hashdelete(int x){
    if (hashsearch(x)!=-1){
        int pos =hashsearch(x);
        a[pos]=-2;
        return true;
    }
    return false;

*/








///////////////propedeutica alberi

//liste
/*
///////////////////////////////////////roba sulle liste

struct Elem{
    int info;
    Elem* next;
};

int lenght(Elem* p){  //calcola la lunghezza della lista
    if (p== nullptr)return 0;
    return 1+lenght(p->next);
}

int howmany(Elem* p, int x){ //quanti elementi dello stesso valore indicato ci sono
    if (p== nullptr)return 0;
    return (p->info==x)+ howmany(p->next,x);
}

int find(Elem* i, int x){ //trova elemento specifico
    if (i== nullptr)return 0;
    if (i->info==x)return 1;
    return find(i->next,x);
}

void taildelete(Elem* & i){ //elimina l'ultimo elemento
    if (i== nullptr)return;
    if (i->next== nullptr){
        delete i;
        i= nullptr;
    } else taildelete(i->next);
}

void tailinsert(Elem * & i, int x){ //aggiungi elemento in coda
    if (i== nullptr){
        i=new Elem;
        i->info=x;
        i->next= nullptr;
    }
    else tailinsert(i->next,x);
}

Elem* append(Elem* & lista1, Elem* & lista2){ //attacca due liste
    if (lista1==nullptr)return lista2;
    lista1->next=append(lista1->next,lista2);
    return lista1;
}

//////////////////////////////////////////////////////////////////
*/

//classe lista(sembra non funzionare append)
/*
template <class tipo>
class lista{
    struct elem{
        tipo info;
        elem* next;
    };
    elem* testa;

    int howmany(elem* p,tipo val){
        if (!p)return 0;
        if(p->info==val) return 1+howmany(p->next,val);
        else return howmany(p->next,val);
    }
    int lenght(elem* p){
        if(!p)return 0;
        return 1+lenght(p->next);
    }

    bool find(elem* p,tipo val){
        if (!p)return false;
        if (val==p->info) return true;
        return find(p->next,val);
    }
    void tailinsert(elem* &p,tipo val){
        if (!p){
            p=new elem;
            p->next= nullptr;
            p->info=val;
            return;
        }
        tailinsert(p->next,val);
    }
    void taildelete(elem* &p){
        if (!p)return;
        if (!(p->next)){
            delete p->next;
            p=nullptr;
        }
        else taildelete(p->next);
    }

    void append(elem* &s1, elem* &s2){
        if (!s1) s1=s2;
        else append(s1->next,s2);
    }


    void cancella(){
        if (!testa)return;
        elem* aux=testa;
        testa=testa->next;
        delete aux;
        cancella();
    }
    void stamp(elem* p){
        if (!p){
            cout<<'\n';
            return;
        }
        cout<<p->info<<' ';
        stamp(p->next);
    }
public:
    lista(){
        testa=nullptr;
    }
    int quanti(tipo val){
       return howmany(testa,val);
    }
    int lunghezza(){
        return lenght(testa);
    }
    bool trovato(tipo val){
        return find(testa,val);
    }

    void inserisci(tipo val){
        tailinsert(testa,val);
    }

    void elim(){
        taildelete(testa);
    }

    void appendi(lista<tipo> s2){
        append(testa,s2.testa);
    }
    ~lista(){
        cancella();
    }

    void stampa(){
        stamp(testa);
    }

};

*/



//fattoriale sia ricorsivo sia iterativo è troppo semplice per essere chiesto







////////////////////////////alberi

//classe bintree classico (non di ricerca, nè figlio-fratello)
/*
//////////////////albero binario

class BinTree{
    struct Node{
        int label;
        Node* left;
        Node* right;
    };

    Node *root;
    Node* findNode(int n, Node* tree){ //n se degenere , logn altrimenti
        if (!tree)return nullptr;
        if (tree->label==n)return tree;
        Node* a=findNode(n,tree->left);
        if (a)return a;
        else return findNode(n,tree->right);
    }

    //le visite hanno complessità lineare per i nodi, esponenziale per livelli
    void preOrder(Node* tree){
        if (!tree)return;
        cout<<tree->label<<' ';
        preOrder(tree->left);
        preOrder(tree->right);
    }
    void inOrder(Node* tree){
        if (!tree)return;
        inOrder(tree->left);
        cout<<tree->label<<' ';
        inOrder(tree->right);
    }
    void postOrder(Node* tree){
        if (!tree)return;
        postOrder(tree->left);
        postOrder(tree->right);
        cout<<tree->label<<' ';
    }

    void delTree(Node* & tree){
        if (tree){
            delTree(tree->left);
            delTree(tree->right);
            delete tree;
            tree= nullptr;
        }
    }

    int insertNode(Node* &tree, int son, int father, char c){ //logn
        if (!tree){ //albero vuoto
            tree=new Node;
            tree->label=son;
            tree->left=tree->right= nullptr;
            return 1;
        }

        Node* a=findNode(father,tree);
        if (!a)return 0;
        if (c=='l' && !a->left){
            a->left=new Node;
            a->left->label=son;
            a->left->left=a->left->right= nullptr;
            return 1;
        }


        if (c=='r' && !a->right){
            a->right=new Node;
            a->right->label=son;
            a->right->left=a->right->right= nullptr;
            return 1;
        }
        return 0;
    }

    //deletenode:findnode+sutura della delete (difficile da scrivere senza sapere le priority, per questo non l'ha messa)

 public:
    BinTree(){root= nullptr;};
    ~BinTree(){delTree(root);};
    Node* find(int x){return findNode(x,root);};
    void pre(){preOrder(root);};
    void post(){postOrder(root);};
    void in(){inOrder(root);};
    int insert(int son,int father, char c){
        insertNode(root,son,father,c);
    };
};


int nodes (Node* tree){ //n
    if (!tree)return 0;
    return 1+nodes(tree->left)+nodes(tree->right);
}

int leaves(Node* tree){ //n
    if (!tree)return 0;
    if (!(tree->left) && !(tree->right)) return 1;
    return leaves(tree->left)+leaves(tree->right);
}
*/

//bintree generico (figlio fratello)
/*
// solo quelle che cambiano(findnode per esempio è la stessa del classico)

int leaves(node* tree){
    if (!tree)return 0;
    if (!tree->left)return 1+leaves(tree->right); // le foglie stanno solo qui
    else return leaves(tree->left)+ leaves(tree->right);
}

void addson(int x, node* &tree){
    if (!tree){ //aggiunge il primo figlio
        tree=new node;
        tree->right=tree->left= nullptr;
        tree->info=x;
    }
    else addson(x,tree->right); //aggiunge il fratello
}

bool insertnode(int son,int father, node* &tree){
    node* a=findnode(father,tree);
    if (!a)return false;
    addson(son,a->left);
    return true;
}
 */

//bintree di ricerca (solo funzioni differenti)
/*


node* findnode(int x,node* tree){ //logn  o n (albero degenere) ATTENZIONE: in media logn
    if (!tree)return nullptr;
    if (tree->info==x)return tree;
    if (x<tree->info)return findnode(x,tree->left);
    return findnode(x,tree->right);
}

void insertnode(int x,node* &tree){ //logn
    if (!tree){
        tree=new node;
        tree->right=tree->left= nullptr;
        tree->info=x;
    }
    if (x<tree->info)insertnode(x,tree->left);
    if (x>tree->info)insertnode(x,tree->right);
}

void deleteMin(node* &tree, int &min){
    if (tree->left)deleteMin(tree->left,min);
    else{
        min=tree->info; //salvo informazione
        node* aux=tree;
        tree=tree->right; //connetto il padre col sottoalbero destro del min
        delete aux;
    }
}

void deletenode(int x,node* &tree){ //logn
    if (tree){
        if (x<tree->info){deletenode(x,tree->left); return;}
        if (x>tree->info){deletenode(x,tree->right);return;}
        if (!tree->left){node* aux=tree; tree=tree->right; delete aux; return;} //come in deletemin
        if (!tree->right){node* aux=tree; tree=tree->left; delete aux; return;}
        deleteMin(tree->right,tree->info);
    }
}

*/

////////////////////////////////////



///////////////////heap
//heap
/*


class Heap{
    int* h;
    int last;

    void up(int i){ //logn
        if (i>0){
            if (h[i]>h[(i-1)/2]){
                exchange(h[i],h[(i-1)/2]);
                up((i-1)/2);
            }
        }
    }
    void down(int i){ //logn
        int son=2*i +1;
        if (son==last){ //se sono su last
            if (h[son]>h[i]) exchange(h[i],h[last]); //va bene anche h[son] poichè son==last
        }
        else if (son<last){ //se sono su last
            if (h[son]<h[son+1])son++;
            if (h[son]>h[i]){
                exchange(h[i],h[son]);
                down(son);
            }
        }
    }

    //exchange (in questo file l'ho già definita fuori, ma di norma è un campo privato in questa classe)

public:
    Heap(int n){
        h=new int[n];
        last=-1;
    }
    ~Heap(){
        delete [] h;
    }
    void insert(int x){
        h[++last]=x;
        up(last);
    }
    int extract(){
        int r=h[0];
        h[0]=h[last--];
        down(0);
        return r;
    }
};
*/

//heapsort
/*
void exchange(int* h, int i , int j){
    int c=h[i];
    h[i]=h[j];
    h[j]=c;
}

void down(int* h,int i, int last){ //identica all'altra ma usata su un array
    int son=2*i +1;
    if (son==last){ //esattamente su last lo scambio
        if (h[son]>h[i])
            exchange(h,i,last);
    }
    else if (son<last){ //scabio prima di last
        if (h[son]<h[son+1])son++;
        if (h[son]>h[i]){
            exchange(h,i,son);
            down(h,son,last);
        }
    }
}

void buildHeap(int* A,int n){
    for (int i = n/2; i >=0 ; i--) {
        down(A,i,n);
    }
}

void extract(int* h, int & last){
    exchange(h,0,last--);
    down(h,0,last);
}

void heapSort(int* A, int dim){  //(nlogn)
    buildHeap(A,dim-1);
    int i=dim-1;
    while (i>0){
        extract(A,i);
    }
}
*/



////////programmazione dinamica
//plsc
/*
///////////////////plsc
const int m=6; const int n=6;
int mat[m+1][n+1];
int plsc(char* a,char* b){  //complessità ?
    for (int i = 0; i <=n ; ++i) { //prima riga di zeri
        mat[0][i]=0;
    }
    for (int i = 1; i <=m ; ++i) {
        mat[i][0]=0; //prima colonna di zeri
        for (int j = 1; j <=n ; ++j) {
            if (a[i-1]==b[j-1]){
                mat[i][j]=mat[i-1][j-1] +1;

            }
            else  mat[i][j]=max(mat[i][j-1],mat[i-1][j]);
        }
    }
    return mat[m][n];
}

void print(char* a, char* b, int i=m,int j=n){
    if (!i||!j)return; //non ci interessa stampare la colonna di zeri o la riga di zeri
    if (a[i-1]==b[j-1]){ //lavoro con gli indici precedenti poichè la lunghezza della stringa è m o n ma l'accesso è in m-1 (casella 0)
        print(a,b,i-1,j-1);
        cout<<a[i-1];
    }
    else {
        if (mat[i][j] == mat[i][j-1]) {
            print( a, b, i , j-1);}

        else print( a, b, i-1, j );
    }
}
////////////////////////////////////
*/

//codice di Huffman (implementabile con minheap)
/*


 //sarebbe da implementare un minheap di cui ogni cella è un possibile albero binario (RIP)

struct node{
    char lettera;
    int frequenza;
    node* left;
    node* right;
};
 node* huffman(Heap h, int dim){
    for (int i = 0; i < dim-1; ++i) {
        node* t=new node();  //probabilmente si è scordato che non ha implementato la parte default della struct (anche perchè non si è fatto a lezione stlib)
        t->left=h.extract();
        t->right=h.extract();
        t->frequency=t->left->frequency+t->right->frequency;
        h.insert(t);//inserisce il sottoalbero aggiornato nel minheap
    }
    return h.extract(); //ritorna la radice dell'albero
}

 */




////////////grafi

//grafi(non funzionanti)
/*
////////////////////////grafi

const int N=6; (si potrebbe usare un template<int N>)

class Graph{
struct Node{
    int label;
    //int arcLabel;
    Node* next;
};

    Node* list[N]; //per liste di adiacenza, int graph [N][N]; per le matrici di adiacenza
    int nodi[N]; //salvo le etichette dei nodi distinti (la posizione in questo array è legata all'array mark[N])
    int mark[N]; //quelli effettivamente marcati

 // manca roba per renderlo funzionante, che il prof. non ha fornito: costruttori, insernode, deletenode, deletegraph...implementazione cambia con matrice di adiacenza
 //non ho voooooogliaaaa sorry

    void nodeVisit(int i){
        mark[i]=1;
        cout<<' '<<nodi[i]<<':'<<i;
        Node* g; int j;
        for (g=list[i]->next;g;g=g->next) { //fa prima il next perchè l'altro l'ha già visitato
            j=g->label;
            if (!mark[j])nodeVisit(g->label);
        }
    }

public:
    void depthVisit(){    //(n+a)
        for (int i = 0; i < N; ++i) {
            mark[i]=0;
        }
        for (int i = 0; i < N; ++i) {
            if (!mark[i]) nodeVisit(i);
        }
    }

};
//////////////////////////////////////


*/








///////////utilities

//esercizi che può chiedere nel pretest
/*
 visite albero (di qualsiasi tipo, stai ATTENZIONATO a preorder e inorder del generico)
 alberi binari ricerca
 raddixsort
 huffman
 dephtvisit
 dijkstra
 ciclo hemiltoniano o ciclo euleriano
 plsc
 krustal

 template(soprattutto la parte sugli static)
 classi derivate
 funzioni virtual
 costrutti try and catch
 */






int main(){

    cout<<"Don't pray for Harambe, pray for Nilo";
    return 0;
}