#include <iostream>
#include <vector>

using namespace std;

struct Node {
	int value;
	Node* left;
	Node* right;
	int c;
	int d;
	
	
	Node(int val): value(val), left(NULL), right(NULL), c(0), d(0){}
        int check(){return value%2 == 0 ? 1 : 0;} //ritorna 0 se è dispari e uno se è pari

	bool foglia(){
		return (left == NULL && right == NULL) ? true : false;
	}
};


class binTree{
	private:
		Node* root;

	public:
		binTree(){root = NULL;}
		Node* getRoot(){return root;}


		void insert(int val){
			Node* n = new Node(val);
			Node* pre = NULL;
			Node* post = root;

			while (post != NULL){
				pre = post;
				if (val<=pre->value) post = post->left;
				else post = post->right;
			}

			if (pre == NULL) root = n;
			else if (val <= pre->value) pre->left = n;
			else pre->right = n;
		}

};



vector<int> calculate(Node* n){
	if (n->foglia()){
		vector<int> v;
		v.push_back(0);v.push_back(0);
		return v;
	}

	vector<int> sx; sx.push_back(0); sx.push_back(0);
	vector<int> dx; dx.push_back(0); dx.push_back(0);

	if (n->left != NULL)  {
		sx = calculate(n->left);  
		if (n->left->foglia())
			if (n->left->check()  == n->check()) sx[1]+=1; else sx[0]+=1;
	}

	if (n->right != NULL)  {
                dx = calculate(n->right);
                if (n->right->foglia())
                        if (n->right->check()  == n->check()) dx[1]+=1; else dx[0]+=1;
        }

	n->c = sx[1]+dx[1]; //in posizione 0 ci sono i discordi
	n->d = sx[0]+dx[0]; //in posizione 1 ci sono i concordi

	vector<int> output;
	output.push_back(n->d);
	output.push_back(n->c);
	return output;
}


void print(Node* n){
	if (n->left != NULL) print(n->left);
	if (n->c - n->d >= 0) cout<<n->value<<endl;
	if (n->right != NULL) print(n->right);
}


int main(){
	int n;
	cin>>n;
	
	binTree b;
	for (int i = 0; i < n; i++){
		int tmp;
		cin>>tmp;
		b.insert(tmp);
	}

	calculate(b.getRoot());
	print(b.getRoot());

	return 0;
}


