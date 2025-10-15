#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
using namespace std;

const int p = 999149;
const int a = 1000;
const int b = 2000;

struct Worker
{
    int id;
    string surname;
    Worker() {}
    Worker(int _id, const string &_s) : id(_id), surname(_s) {}
};

struct HashTable
{
    vector<vector<Worker>> table;

    HashTable(int size)
    {
        table = vector<vector<Worker>>(size);
    }

    int hash(int m)
    {
        return ((a * m + b) % p) % table.size();
    }

    void insert(const Worker &w)
    {
        int idx = hash(w.id);
        table[idx].push_back(w);
    }
};

int main()
{
    int N, K;
    cin >> N >> K;
    int size = 2 * N;
    if (size == 0)
        return 0;

    HashTable ht(size);

    for (int i = 0; i < N; i++)
    {
        int id;
        string s;
        cin >> id >> s;
        ht.insert(Worker(id, s));
    }

    vector<pair<int, int>> counts;
    counts.reserve(size);
    for (int i = 0; i < size; i++)
    {
        counts.push_back(make_pair(-(int)ht.table[i].size(), i));
    }

    sort(counts.begin(), counts.end());

    int limit = K;
    if (limit > (int)counts.size())
        limit = counts.size();

    for (int i = 0; i < limit; i++)
    {
        int idx = counts[i].second;
        vector<Worker> &v = ht.table[idx];
        if (v.empty())
        {
            cout << -1 << endl;
            continue;
        }
        int min_idx = 0;
        for (int j = 1; j < (int)v.size(); j++)
        {
            if (v[j].surname < v[min_idx].surname ||
                (v[j].surname == v[min_idx].surname && v[j].id < v[min_idx].id))
            {
                min_idx = j;
            }
        }
        cout << v[min_idx].id << endl;
    }

    return 0;
}
