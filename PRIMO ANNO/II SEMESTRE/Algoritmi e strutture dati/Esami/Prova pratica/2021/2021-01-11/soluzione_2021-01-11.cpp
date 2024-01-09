#include <iostream>     // std::cout
#include <algorithm>    // std::sort
#include <vector>       // std::vector
#include <fstream>
#include <math.h>       /* floor */
#include <stdlib.h>
#include <cmath>        /* pow  */

using namespace std;

struct Node
{
    int value;
    Node * left;
    Node * right;

    Node( int i ): value(i) , left(NULL) , right(NULL) {}
};

class BinTree
{
    Node * root_;
public:

    BinTree() { root_ = NULL ; }

    Node * getRoot() { return root_; cout << "getRoot" << endl;}

    void insert( int i )
    {
        Node * node = new Node(i);

        Node * pre = NULL;
        Node * post = root_;
        while( post != NULL)
        {
            pre = post;
            if( i <= post->value )
            {
                post = post->left;
            }
            else
            {
                post = post->right;
            }
        }

        if( pre == NULL )
            root_ = node;
        else if( i <= pre->value )
        {
            pre->left = node;
        }
        else
        {
            pre->right = node;
        }
        return;

    }
};

// --------------------------METODO ESTERNO DA AGGIUNGERE--------------------------
/*soluzione proposta da uno studente*/
int concord (Node* tree,int padre) {
    if (!tree) return 0;
    if (padre==0 || (tree->value%2==0 && padre%2==0) || (tree->value%2!=0 && padre%2!=0))
        return tree->value + concord(tree->left,tree->value) + concord(tree->right,tree->value);
    return concord(tree->left,tree->value) + concord(tree->right,tree->value);
}
// --------------------------------------------------------------------------------


//=======================================MAIN======================================

int main()
{
    int N ;
    int x ;
    BinTree albero ;

    cin >> N ;

    // Inserimento elementi nell' albero
    for(int i=0 ; i<N ; ++i )   {
        cin >> x;
        albero.insert(x);
    }

    // --------------------------CHIAMATA AL METODO----------------------------
    cout <<"Somma dei label concordi: " <<concord(albero.getRoot(),0) <<endl;
    // ------------------------------------------------------------------------
}
