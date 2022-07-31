#include <iostream>
using namespace std;

struct node{
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
int fun(node* tree, int& nfoglie){
    if(!tree) return 0;

    if(!tree->left && !tree->right){
        nfoglie = 1;
        return 1;
    }

    int fogliesx, fogliedx;
    fogliesx = fogliedx = 0;
    
    int h = max(fun(tree->left,fogliesx),fun(tree->right,fogliedx));
    
    nfoglie = fogliedx + fogliesx;
    
    if(h<nfoglie)
        cout<<tree->label<<endl;
        
    return h+1;
}

int main() {
    int N,x;
    cin>>N;
    
    binTree albero;
    for(int i = 0; i < N; i++){
        cin>>x;
        albero.insert(x);
    }
    
    int foglie = 0;
    fun(albero.getRoot(), foglie);
    
    return 0;
}
