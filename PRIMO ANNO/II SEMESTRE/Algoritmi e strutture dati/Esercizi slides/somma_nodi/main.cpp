/********************************************************************************************

La seguente mostra una possibile soluzione di Somma Nodi

---> IMPORTANTE! La soluzione mostrata non è detto che sia la migliore o quella "corretta",
		 in quanto non è stata fornita dai docenti bensì da uno studente.

********************************************************************************************/


#include <iostream>
#include <vector>
using namespace std;


struct node{
	int value;
	node* left;
	node* right;
	int i;
	int f;

	node(int val): value(val), left(NULL), right(NULL), i(0), f(0){}
};

class binTree{
	private:
		node* root;

	public:
		binTree(){root = NULL;}
		node* getRoot(){return this->root;}
		
		void insert(int val){
			node* tmp = new node(val);
			node* pre = NULL;
			node* post = root;

			while (post != NULL){
				pre = post;
				if (tmp->value <= pre->value) post = post->left;
				else post = post->right;
			}

			if (pre == NULL) root = tmp;
			else if(tmp->value <= pre->value) pre->left = tmp;
			else pre->right = tmp;
		}
};


void print(node* n){
	cout<< n->value <<":\tf="<< n->f << "\ti="<< n->i << endl;

	if(n->left != NULL) print(n->left);
	if(n->right != NULL) print(n->right);
}


int f(node* tmp){
	if(tmp->left == NULL && tmp->right == NULL){
		tmp->f = tmp->value;
		return tmp->value;
	}
	
	int suml = 0;
	int sumr = 0;

	if(tmp->left != NULL)  suml+= f(tmp->left);
	if(tmp->right != NULL) sumr+=f(tmp->right);    
	
	int sum = suml+sumr;
	tmp->f = sum;
	return sum;
}

int i (node* tmp){
	if (tmp->left == NULL && tmp->right == NULL) return 0;

	int suml = 0;
	int sumr = 0;

	if (tmp->left != NULL)	suml+=i(tmp->left);
	if (tmp->right != NULL) sumr+=i(tmp->right);

	int sum = suml + sumr + tmp->value;
	tmp->i = sum;
	return sum;
}

int main(){
	int n = 0;
	cin>>n;

	while (n<=0) cin>>n;
	
	vector<int> v;
	for (int i = 0; i < n; i++){
		int tmp = 0;
		cin>>tmp;
		v.push_back(tmp);
	}

	binTree b;
	for (int i = 0; i < n; i++)
		b.insert(v[i]);

	f(b.getRoot());
	i(b.getRoot());
	print(b.getRoot());

	return 0;
}
