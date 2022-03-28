class uno {
protected:
     int a;
public:
	uno() {a=5; cout << "nuovo uno " <<  a << endl;}	
     uno(int x) {a=x; cout << "nuovo uno " <<  a << endl;}
};

class due: public uno {
     int b;
public:
	due(int x) {b=x; cout << "nuovo due " <<  x << endl;}
//    due(int x): uno(x+1) {b=x; cout << "nuovo due" << x << endl;}

};
