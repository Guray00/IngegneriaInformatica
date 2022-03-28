class uno {
public:
	uno(){cout << "nuovo uno" << endl;}	
};

class due: public uno {
public:
	due()  {cout << "nuovo due"<< endl;}
};

class tre: public due {
public:
	tre() {cout << "nuovo tre"<< endl;}	
};
