
class A {
public:
	static int quantiA;
	A(){
	 cout << "A =  " 
	<< ++quantiA << endl;}
};

int A::quantiA=0;

class B : public A{
public:
	static int quantiB;
	B(){
	cout << "B =  " 
	<< ++quantiB << endl;}
};

int B::quantiB=0;
