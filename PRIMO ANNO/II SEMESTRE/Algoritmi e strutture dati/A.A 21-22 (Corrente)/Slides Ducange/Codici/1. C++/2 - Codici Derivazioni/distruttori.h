class uno {
public:
	uno();
	~uno();
};

uno::uno(){cout << "nuovo uno" << endl;}
uno::~uno(){cout << "via uno" << endl;}

class due: public uno {
public:
	due();
	~due();
};

due::due(){cout << "nuovo due" << endl;}
due::~due(){cout << "via due" << endl;}
