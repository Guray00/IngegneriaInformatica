#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

struct node{
	int value;
	node* left;
	node* right;
	int h;

	node(int val): value(val), left(NULL), right(NULL), h(0){}
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

			while (post != NULL){
				pre = post;

				if (val <= pre->value) post = post->left;
				else post = post->right;
			}

			if (pre == NULL) root = n;
			else if (val <= pre->value) pre->left = n;
			else pre->right = n;
		}
};

int max (int n1, int n2){ return n1>n2 ? n1 : n2;}

int calculate(node* n){
	if (n->left == NULL && n->right == NULL) {
		n->h = 1;
		return 1;
	}

	int sx = 0;
	int dx = 0;
	
	if (n->left != NULL)  sx = calculate(n->left);
	if (n->right != NULL) dx = calculate(n->right);
	
	int h = max(sx, dx) + 1;
	n->h = h;
	return h;
}

bool check(node* n1, node* n2){return n1->h > n2->h ? true : false;}

/*
void debug(vector<node*> v){
	cout<<"\n\n**********************************\n";

	for (int i = 0; i < v.size(); i++){
		cout<<"v:\t"<< v[i]->value << "\th:\t"<< v[i]->h << endl;
	}

        cout<<"**********************************\n";
}*/

void print(node* n, int &k, int m){
	if (n->left != NULL) print(n->left, k, m);
	if (n->right != NULL) print(n->right, k, m);

	if (k > 0 && n->h == m) {
		cout<< n->value <<endl;
		k--;
	}
}

int main (){
	int n,k;
	cin>>n>>k;
	
	binTree b;
	for (int i = 0; i < n; i++) { 
		int tmp = 0;
		cin>>tmp;
		b.insert(tmp);
	}
	
	calculate(b.getRoot());
	print(b.getRoot(), k, b.getRoot()->h/2);
	return 0;
}
