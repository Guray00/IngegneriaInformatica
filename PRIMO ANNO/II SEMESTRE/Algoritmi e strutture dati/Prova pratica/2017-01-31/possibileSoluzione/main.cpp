#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

int ZIGZAG = 0;

struct node{
	int value;
	node* left;
	node* right;
	
	node(int val): value(val), left(NULL), right(NULL){}
};

class binTree{
	private:
		node* root;
	
	public:
		binTree(){root = NULL;}
		node* getRoot(){return root;}
		
		void insert(int val){
			node* n = new node(val);
			node* pre = NULL;
			node* post = root;


			while (post!=NULL){
				pre = post;
				if (val <= pre->value) post = post->left;
				else post = post->right;
			}

			if (pre == NULL) root = n;
			else if (val <= pre->value) pre->left = n;
			else pre->right = n;
	
		}
};


void zigzag(node* n){
	if(n->left != NULL && n->right != NULL){
		zigzag(n->left);
		zigzag(n->right);

		return;
	}

	if (n->left != NULL && n->right == NULL){
		if (n->left->right != NULL && n->left->left == NULL) ZIGZAG++;
		zigzag(n->left);
	}

 	if (n->right != NULL && n->left == NULL){
                if (n->right->left != NULL && n->right->right == NULL) ZIGZAG++;
        	zigzag(n->right);
	}
}

int main(){
	int n;
	cin>>n;
	
	binTree b;
	for (int i = 0; i < n; i++){
		int tmp = 0;
		cin>>tmp;
		b.insert(tmp);
	}

	zigzag(b.getRoot());
	cout<<ZIGZAG<<endl;

	return 0;
}
