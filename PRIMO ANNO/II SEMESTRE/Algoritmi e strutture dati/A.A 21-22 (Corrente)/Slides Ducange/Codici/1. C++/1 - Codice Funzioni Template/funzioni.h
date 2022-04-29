
template<class tipo>
tipo maxT1(tipo x, tipo y) {
	return (x>y) ? x : y;
}


template<class tipo>  
void primo ( tipo *x ) {
	tipo y= x[0] ;
	cout << y << endl;
};


template<class tipo>
void primoP ( tipo x ) { 
	cout << x[0] << endl;
};

template<class tipo>
void primoP1 ( tipo x ) { 
	tipo y= x[0] ;
	cout << y << endl;
    
};



template<class tipo1, class tipo2>
tipo1 maxT2(tipo1 x, tipo2  y) {
	return (x>y) ? x : y;
}



template<class tipo1, class tipo2, class tipo3>
tipo1 nuovomax(tipo2 x, tipo3  y) {
	return (x>y) ? x : y;
}


template<class tipo>
tipo maxT(tipo x, tipo y) {
	static int a; a++; cout << a<<'\t';
	return (x>y) ? x : y;
}

