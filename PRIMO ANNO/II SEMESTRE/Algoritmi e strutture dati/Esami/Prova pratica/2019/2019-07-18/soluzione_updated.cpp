#include<iostream>
using namespace std;
#include<algorithm>
#include<vector>
#include<unordered_map>
constexpr int p = 999149, a = 1000, b = 2000;

struct Veicolo {
	int targa;
	int categoria;
};


struct HashTable {
	int size;
	vector<vector<Veicolo>> table;
	HashTable(int _size): table{(size_t) _size}, size{_size} {}

	int hash(Veicolo v) {
		return ((a * v.targa + b) % p) % size;
	}

	void insert(Veicolo v) {
		table[hash(v)].push_back(v);
	}
};


int main() {
	int n, k, c; 
	cin >> n >> k >> c;
	HashTable ht(c);
	
	for(int i = 0; i < n; i++) {
		int t, cat; 
		cin >> t >> cat;
		ht.insert({t, cat});
	}

	// calcola v per ogni indice di ht 
	unordered_map<int,int> v_map{};
	vector<pair<int,int>> result;
	for(int i = 0; i < c; i++) {
		v_map.clear();

		// trova v
		for(Veicolo v : ht.table[i])	v_map[v.categoria]++;
		
		// trova m(i)
		int m = 0;
		for(pair<int,int> p : v_map) {
			if(p.second > m)	m =	p.second; 
		}
		result.push_back({i, m});
	}

	// sorting result
	sort(result.begin(), result.end(), [] (pair<int,int> a, pair<int,int> b) {
		return a.second > b.second || ((a.second == b.second) && a.first < b.first);
	});

	for(int i = 0; i < result.size() && k--; i++)	cout << result[i].first << endl; 
	


}

