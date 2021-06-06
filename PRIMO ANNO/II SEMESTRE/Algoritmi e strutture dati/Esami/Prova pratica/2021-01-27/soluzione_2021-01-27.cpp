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
int somm (Node* tree,int altezza) {
    if (!tree) return 0;
    if (altezza++%2!=0) {
        if (tree->left== nullptr || tree->right== nullptr)
            return tree->value + somm(tree->left,altezza) + somm (tree->right,altezza);
    }
    return somm(tree->left,altezza) + somm (tree->right,altezza);
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
    int somma=somm(albero.getRoot(),1);
    cout <<"Somma label nodi incompleti: " <<somma <<endl;

    // ------------------------------------------------------------------------
}
