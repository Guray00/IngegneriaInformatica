#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

struct node{
	int value;
	node* left;
	node* right;
	int f;
	bool active;
	node(int val): value(val), right(NULL), left(NULL), f(0), active(true){}
	
	int check(){
		if(left != NULL && right!= NULL && left->left == NULL && left->right == NULL &&
		right->left == NULL && right->right == NULL){ return 1;}
		
		else return 0;
	}
};

class binTree{
	private:
		node* root;
		vector<node*> v;

	public:
		binTree(){root = NULL;}

		node* getRoot(){return root;}

		void insert(int val){
			node* tmp = new node(val);
			node* post = root;
			node* pre = NULL;

			v.push_back(tmp);
			while (post!=NULL){
				pre = post;
				if (val <= pre->value) post = post->left;
				else post = post->right;
			}

			if (pre == NULL) root = tmp;
			else if (val <= pre->value) pre->left = tmp;
			else pre->right = tmp;
		}

		vector<node*> getV(){return v;}

};


int f(node* n){
	bool neq = 1;

	if (n->left == NULL && n->right == NULL){ 	//sono in una foglia
		n->active = false;						//disattivo dal conteggio
		n->f = 0;
		return 0;
	}

	if(n->check() == 1) { //caso base eq
		n->f = -1;
		f(n->left);
		f(n->right);
		return -1;
	}


	if((n->left != NULL && n->right == NULL) || (n->left == NULL && n->right != NULL)){  
		if (n->left != NULL){
            if (n->left->left != NULL || n->left->right != NULL  ) neq = 0;			
        }

        if (n->right != NULL){
            if (n->right->left != NULL || n->right->right != NULL) neq = 0;
        }

        //Se arrivo qua senza passare per gli if ho trovato un neq
    }

	else neq = 0;


	int sx = 0; 
	int dx = 0;

	if (n->left != NULL)  sx = f(n->left);
	if (n->right != NULL) dx = f(n->right);
	
	
	int tot = sx + dx;
	if (neq) tot++;

	n->f = tot;
	return tot;
}

bool check(node* n1, node* n2){
	return n1->f > n2->f ? true : false;
}

void debug(vector<node*> v){
	cout<<"\n\n************************\n";
	for (int i = 0; i < v.size(); i++){
		cout<<v[i]->f<<"\t"<<v[i]->value<<"\t"<<v[i]->active<<endl;
	}
	cout<<"************************\n";
}

void print(binTree b){
	vector<node*> v = b.getV();
	sort(v.begin(), v.end(), check);

	//Rimuovo i nodi disattivati
	for (int i = 0; i < v.size(); i++){
		if (v[i]->active == false) v[i] == NULL;
	}
	
	int i = 0;
	while (v[i]->active == false && i < v.size()) i++;

	node* winner = v[i];
	int value = v[i]->f;

	//scelgo l'etichetta più piccola a parità di f
	while (v[i]->f == value){
		if (v[i]->active && v[i]->value < winner->value) winner = v[i];
		i++;
	}

	cout<<winner->value<<endl<<winner->f<<endl;
}


int main (){

	int n;
	do{cin>>n;}while(n<=0);
	
	binTree b;
	for (int i = 0; i < n; i++){
		int tmp;
		cin>>tmp;
		b.insert(tmp);
	}

	f(b.getRoot());
	print(b);

	return 0;
}
