#include <iostream>
#include <vector>
#include <algorithm>
#include <cstdlib>
#include <ctime>
#include <cmath>

struct intervento{
	int fasciaOraria;
	int latitudine,
		longitudine;
		
	public:
		bool operator<(intervento& b){
			return this->fasciaOraria < b.fasciaOraria;
		}
		
		int operator-(intervento& b){
			return sqrt(pow(latitudine - b.latitudine, 2) + (longitudine - b.longitudine, 2));
		}
		
		friend std::ostream& operator<<(std::ostream& stream, intervento i){
			stream << i.fasciaOraria << " | " << i.latitudine << " | " << i.longitudine << std::endl;
			return stream;
		}
};

struct tecnico{
	int totale = 0;
	int ultimaFasciaOraria = -1;
	std::vector<intervento> assegnati;
};

int main(int argc, char** argv, char** envv){

	int N = 10;

	intervento home = {0, 0, 0};
	std::vector<intervento> is;
	std::vector<tecnico> 	ts(N);

	for(int i = 0; i < 4; i++)
		for(int j = 0; j < ts.size(); j++)
			is.push_back({i, rand()%2000 - 1000, rand()%2000 - 1000});

	for(auto& x : is){
		
		std::pair<int, int> best = {-1, 0}; //id | distance
		
		for(int i = 0; i < ts.size(); i++){
			tecnico& current = ts[i];
			
			if(current.ultimaFasciaOraria >= x.fasciaOraria)
				continue;

			if(current.assegnati.size() == 0){
				best = {i, home - x};
				continue;
			}
			
			int distance = current.assegnati.back() - x;
			
			if(best.first == -1 or current.totale + distance < best.second)
				best = {i, current.totale + distance};
		}
		
		ts[best.first].assegnati.push_back(x);
		ts[best.first].totale = best.second;
		ts[best.first].ultimaFasciaOraria = x.fasciaOraria;
	}
	
	for(auto& x : ts){
		for(auto xx : x.assegnati)
			std::cout << xx;
		std::cout << x.totale << std::endl;
	}
	
	return 0;
}
