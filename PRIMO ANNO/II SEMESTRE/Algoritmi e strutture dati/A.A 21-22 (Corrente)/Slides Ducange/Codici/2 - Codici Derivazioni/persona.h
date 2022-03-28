class persona {
public:
	char  nome [20];
	int eta;
	void chisei(){
		cout << nome << '\t'<< eta << endl;
	}
};

class studente : public persona{
public:
	int esami;
	int matricola;
	void chisei(){
		cout << nome << '\t'<< eta << '\t'
			<< matricola << 
			'\t'<< esami << endl;
	}
};


class borsista : public studente{
public:
	int borsa;
	int durata;
};
