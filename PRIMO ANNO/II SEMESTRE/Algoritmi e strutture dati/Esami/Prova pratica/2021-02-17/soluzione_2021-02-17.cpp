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

/*soluzione proposta dagli studenti*/
int funzione (Node* n, int altezza){
	if (!n) return 0;
	
	int altezza2 = altezza+1; 
	int sx = funzione(n->left,  altezza2);
	int dx = funzione(n->right, altezza2);

	if ( (altezza%2 == 0 && (sx+dx)%2 == 0) || (altezza%2 != 0 && (sx+dx)%2 != 0) ){
		cout<<n->value<<endl;
	}

	return sx+dx+n->value;
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
    cout<<"=========="<<endl;
    funzione(albero.getRoot(), 1);
    cout<<endl;
}
