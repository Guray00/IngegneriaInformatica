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


void minMaxLeaf( Node * tree, int * tmpMin, int * tmpMax)
{
        // Nodo non trovato
        if( tree == NULL)  {
            return;
        }

        // Foglia?
        if(tree->left == NULL & tree->right == NULL)   {
            if (tree->value < *tmpMin){
                *tmpMin = tree->value;
            }

            if (tree->value > *tmpMax){
                *tmpMax = tree->value;
            }
        }

        minMaxLeaf(tree->left , tmpMin, tmpMax);
        minMaxLeaf(tree->right , tmpMin, tmpMax);

}


int main()
{
    int N ;
    int x ;
    BinTree albero ;

    cin >> N ;

    // riempio l' albero
    for(int i=0 ; i<N ; ++i )   {
        cin >> x;
        albero.insert(x);
    }

    int MINIMO = 1000;
    int MASSIMO = 0;

    minMaxLeaf(albero.getRoot(), &MINIMO, &MASSIMO);
    cout<< MINIMO << ", " << MASSIMO <<endl;
}
