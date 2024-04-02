#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;


struct node{
	int value;
	node* left;
	node* right;
	int D;

	node(int val): value(val), left(NULL), right(NULL), D(-1){}
	char getType(){return (value%2)==0 ? 'P' : 'D';}
};

class binTree{
	private:
		node* root;
		vector<node*> v;

	public:
		binTree(){
			root = NULL;
		}

		node* getRoot(){return root;}

		void insert(int value){
			node* tmp  = new node(value);
			v.push_back(tmp);
			node* pre  = NULL;
			node* post = root;
		
			while (post != NULL){
				pre = post;
				if (value <= pre->value) post = post->left;
				else post = post->right;
			}

			if (pre == NULL) root = tmp;
			else if (value <= pre->value) pre->left = tmp;
			else pre->right = tmp;
		}



		vector<node*> getV(){ return v;}
};


bool check(node* n1, node* n2){ return n1->D > n2->D ? true : false;}

void print(binTree b){
	vector<node*> v = b.getV();
	sort(v.begin(), v.end(), check);
	
	vector<int> output;
	for (int i = 0; i < v.size(); i++){
		if (v[i]->D == -2) break;

		if(i > 0 && v[i-1]->D != v[i]->D) output.push_back(v[i]->D);
		if (i == 0) output.push_back(v[i]->D);
	}	

	for (int i = 0; i < output.size(); i++){
		cout<<output[i]<<endl;
	}
}


int max(int n1, int n2){return n1>n2 ? n1: n2;}

int* D(node* n){
	
	if (n->left == NULL && n->right == NULL){
		n->D = -2;
		
		int* tmp = new int[2];
		if(n->getType() == 'D'){ //dispari -> tmp[0] pari -> tmp[1]
			tmp[0] = 0;
			tmp[1] = -1;
		}

		else{
			tmp[0] = -1;
			tmp[1] = 0;
		}
	
		return tmp;
	}
	
	char type = n->getType();
	int distlp = -1;
	int distld = -1;
	int distrp = -1;
	int distrd = -1;

	
	if (n->left != NULL){
		int* v = D(n->left);
		distld = v[0];
                distlp = v[1];
		delete[] v;

		if (distld != -1) distld++;
                if (distlp != -1) distlp++;
	}

	if (n->right != NULL){
		int* v = D(n->right);
		distrd = v[0];
                distrp = v[1];
		delete[] v;

		if (distrd != -1) distrd++;
                if (distrp != -1) distrp++;
	}
	


	int d = max(distld, distrd);
	int p = max(distlp, distrp);

	n->D = type=='D' ? d : p;
	int* tmp = new int[2];
	tmp[0] = d;
	tmp[1] = p;

	return tmp;
}


int main (){

	int n = 0;
	
	do{
		cin>>n;
	}while(n<=0);
	

	binTree b;
	for (int i = 0; i < n; i++){
		int tmp = 0;
		cin>>tmp;
		b.insert(tmp);
	}

	int* v = D(b.getRoot());
	delete[] v;

	print(b);

	return 0;
}
