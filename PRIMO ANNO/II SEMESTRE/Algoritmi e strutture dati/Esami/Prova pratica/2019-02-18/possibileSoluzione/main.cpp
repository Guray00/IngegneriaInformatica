#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

struct node{
	int value;
	node* left;
	node* right;
	int m;
	int p;
	int c;
	int d;

	node(int val, int massa): value(val), left(NULL), right(NULL), m(massa), p(0), d(0), c(0){}
};

class binTree{
	private:
		node* root;
		vector<node*> v;

	public:
		binTree(){root = NULL;}
		node* getRoot(){return root;}

		void insert(int val, int m){
			node* tmp = new node(val, m);
			node* pre = NULL;
			node* post = root;
			
			int d = 0;
			while (post!=NULL){
				pre = post;
				if (val <= pre->value) post = post->left;
				else post = post->right;
				d++;
			}

			tmp->d = d;
			v.push_back(tmp);
			if (pre == NULL) root = tmp;
			else if (val <= pre->value) pre->left = tmp;
			else pre->right = tmp;
		}

		vector<node*> getV(){return v;}
};


int calculate(node* n){
	if (n->left == NULL && n->right == NULL){
		int p = (n->m*2) - n->d;
		n->p = p;
		n->c = 0;

		return n->p;
	}

	int p = n->m - n->d;
	n->p = p;

	int sx = 0;
	int dx = 0;

	if (n->left != NULL)  sx = calculate (n->left);
	if (n->right != NULL) dx = calculate (n->right);
	
	int c = sx + dx;
	n->c = c;
	c += p;
	
	return c;
}


bool check(node* n1, node* n2){
	return n1->c > n2->c ? true : false;
}

int min(int n1, int n2){
	return n1<n2 ? n1 : n2;
}


void debug(vector<node*> v){
	cout<<"*********************************************\n";

	for (int i = 0; i < v.size(); i++){
		cout<< "v: "<< v[i]->value << "\tm: "<<v[i]->m << "\tp:" << v[i]->p <<"\td:" << 
		v[i]->d << "\tc: "<< v[i]-> c<<endl;
	}

        cout<<"*********************************************\n";
}

void print(binTree b, int k){
	vector<node*> v = b.getV();
	sort(v.begin(), v.end(), check);
	//debug(v);
	/*vector<int> output;
	for (int i = 0; i < v.size(); i++){
		if (i == 0) output.push_back(v[0]->c);
		else if (i > 0 && v[i]->c != v[i-1]->c) output.push_back(v[i]->c);
	}*/

	int m = min(k, v.size());
	for (int i = 0; i < m; i++) cout<<v[i]->c<<endl;
}

int main (){
	int n, k;
	cin>>n>>k;


	binTree b;
	for (int i = 0; i < n; i++){
		int val = 0;
		int m = 0;

		cin>>val>>m;
		b.insert(val, m);
	}

	calculate(b.getRoot());
	print(b, k);
	return 0;
}
