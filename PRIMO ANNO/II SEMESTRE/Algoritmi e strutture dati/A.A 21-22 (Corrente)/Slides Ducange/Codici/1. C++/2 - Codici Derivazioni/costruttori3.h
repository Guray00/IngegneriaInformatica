class uno {
public:
uno() { 
cout << "nuovo uno " 
	<< endl; 
}
};
class due {
 uno a;
public:
due() { 
cout << "nuovo due " 
	<< endl; 
}
};
class tre: public due {
uno b;
public:
tre() { cout << "nuovo tre" << endl; }
};
