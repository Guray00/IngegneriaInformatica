#include <iostream>
using namespace std;

struct node {
    int label;
    node* left;
    node* right;

    node(int i): label(i), left(NULL), right(NULL){}
};

class binTree{
    node* root;

public:
    binTree(){root=NULL;}
    node* getRoot();
    void insert(int i);
};

node* binTree::getRoot() {
    return root;
}

void binTree::insert(int i) {
    node* nodo = new node(i);
    node* pre = NULL;
    node* post = root;
    
    while(post != NULL){
        pre = post;
        
        if(i <= post->label)
            post = post->left;
        else
            post = post->right;
    }

    if(pre == NULL)
        root = nodo;
    else if(i <= pre->label)
        pre->left = nodo;
    else
        pre->right = nodo; 
}

/*soluzione fornita da uno studente: potrebbe non essere
la migliore, ma almeno funziona*/
void fun(node*tree,int& npari,int& ndisp){
    if(!tree){
        npari = ndisp=0;
        return;
    }
    
    int pari_left, disp_left, pari_right, disp_right;
    
    fun(tree->left,pari_left,disp_left);
    fun(tree->right,pari_right,disp_right);
    
    npari = pari_left + pari_right;
    ndisp = disp_left + disp_right;
    
    if(npari > ndisp)
        cout<<tree->label<<endl;
    if(tree->label%2 == 0)
        npari++;
    else
        ndisp++;
}

int main() {
    int N,x;
    cin>>N;
    
    binTree albero;
    for(int i = 0; i < N; i++){
        cin>>x;
        albero.insert(x);
    }
    
    int npari, ndisp;
    npari = ndisp = 0;
    fun(albero.getRoot(), npari, ndisp);
    
    return 0;
}
