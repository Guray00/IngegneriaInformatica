#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;


struct Node{
	int id;
	Node* left;
	Node* right;
	char type;
	int g;

	Node(int val, char t):id(val), left(NULL), right(NULL), type(t), g(0){}
};


class binTree{
	private:
		Node* root;

	public:
		binTree(){root = NULL;}
		Node* getRoot(){return root;}


		void insert(int val, char t){
			Node* n = new Node(val, t);
			Node* pre = NULL;
			Node* post = root;

			while(post != NULL){
				pre = post;
				if (val <= pre->id) post = post->left;
				else post = post->right;
			}

			if (pre == NULL) root = n;
			else if (val <= pre->id) pre->left = n;
			else pre->right = n;
		}
};

/*STATES:
	 0 -> partito dal server
	 1 -> arrivato al filtro
	 2 -> client raggiunto
*/
int calculate(Node* n, int state){
	int add = 0;
	if (n->type == 'C'){
		if (state != 0)	{state = 2; add += 1;}
	}

	else if (n->type == 'S'){
		state = 0;
	}

	else if (n->type == 'F'){
		if (state == 0) {state = 1;}
	}

	int sx = 0;
	int dx = 0;
	if (n->left  != NULL) sx = calculate(n->left , state);
        if (n->right != NULL) dx = calculate(n->right, state);

	if (state == 0 && n->type=='S') {n->g = sx+dx; return 0;} //anche i router sennò causerebbero un annullamento

	return sx+ dx + add;
}

void print(Node* n){
	if (n->left != NULL) print(n->left);
        if(n->type == 'S') cout<< n->id <<" "<< n->g <<endl;
	if (n->right != NULL) print(n->right);
}

int main(){
	int n;
	cin>>n;

	binTree b;
	for (int i = 0; i < n; i++){
		int tmp;
		char t;
		cin>>tmp>>t;
		b.insert(tmp, t);
	}

	int state = 0;
	calculate(b.getRoot(), state);
	print(b.getRoot());

	return 0;
}
