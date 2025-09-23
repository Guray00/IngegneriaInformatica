#include<iostream>
#include<fstream>
#include<vector>
#include<algorithm>
using namespace std;
#include<functional>
#include<optional>
constexpr int p=999149 , a=1000, b=2000;

struct Worker {
	int id;
	string surname;
};

template<typename T>
struct HashTable {
	vector<vector<T>> table;
	function<int(T)> hash;

	HashTable(function<int(T)> hash, size_t s) : table{s}, hash{move(hash)}  { }
	void insert(T value) {
		table[hash(value)].push_back(value);
	}

};

// trova minimo nel vector di elementi con egual numero di collisioni
optional<int> find_min(const vector<Worker> &v) {
	if(v.empty()) return nullopt; 

	const Worker *minw = &v[0]; 
	for(const auto &w : v) {
		if(w.surname < minw->surname || (w.surname == minw->surname && w.id < minw->id))
			minw = &w;
	}

	return minw->id;
}

int main() {
	ifstream cin("TestSet/input0.txt");
	int n, k; cin >> n >> k; int i = n;
	auto hash = [=](Worker w) { return (((a * w.id) + b) % p) % (2 * n); };
	vector<vector<Worker>> res{}; 
	{
		HashTable<Worker> ht{hash, (size_t) 2 * n}; // concatenazione, dim * 2
		while(i--) {
			int id; string s; cin >> id >> s; 
			ht.insert(Worker{id, s});
		}
	} 

	// sort in ordine di numero di collisioni
	stable_sort(res.begin(), res.end(), [] (const auto a, const auto b) -> bool {
		return a.size() > b.size();
	});

	for(int i = 0; i < k; i++) {
		auto minw = find_min(res[i]); 
		if(minw.has_value()) cout << *minw << endl; 
		else cout << -1 << endl;
	}


}
