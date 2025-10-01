#include <iostream>
#include <vector>
#include <algorithm>
#include <map>
using namespace std;

const int p = 999149;
const int a = 1000;
const int b = 2000;

struct Veicolo
{
	int targa;
	int categoria;
};

struct HashTable
{
	int size;
	vector<vector<Veicolo>> table;
	HashTable(int _size) : size(_size)
	{
		table.resize(size);
	}

	int hash(Veicolo v)
	{
		return ((a * v.targa + b) % p) % size;
	}

	void insert(Veicolo v)
	{
		table[hash(v)].push_back(v);
	}
};

bool cmp(pair<int, int> x, pair<int, int> y)
{
	return x.second > y.second || ((x.second == y.second) && x.first < y.first);
}

int main()
{
	int n, k, c;
	cin >> n >> k >> c;
	HashTable ht(c);

	for (int i = 0; i < n; i++)
	{
		int t, cat;
		cin >> t >> cat;
		Veicolo v;
		v.targa = t;
		v.categoria = cat;
		ht.insert(v);
	}

	// calcola v per ogni indice di ht
	map<int, int> v_map;
	vector<pair<int, int>> result;
	for (int i = 0; i < c; i++)
	{
		v_map.clear();

		// trova v
		for (size_t j = 0; j < ht.table[i].size(); j++)
		{
			Veicolo v = ht.table[i][j];
			v_map[v.categoria]++;
		}

		// trova m(i)
		int m = 0;
		for (map<int, int>::iterator it = v_map.begin(); it != v_map.end(); ++it)
		{
			if (it->second > m)
				m = it->second;
		}
		result.push_back(make_pair(i, m));
	}

	// sorting result
	sort(result.begin(), result.end(), cmp);

	for (size_t i = 0; i < result.size() && k > 0; i++, k--)
		cout << result[i].first << endl;

	return 0;
}
