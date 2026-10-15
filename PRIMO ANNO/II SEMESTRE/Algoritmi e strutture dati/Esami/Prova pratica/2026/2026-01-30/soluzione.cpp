#include <iostream>
#include <vector>
#include <algorithm>
#include <map>
using namespace std;

struct Event {
    string id;
    string zone;
    int priority;

    Event(const string& id, const string& zone, int priority): id(id), zone(zone), priority(priority) {}
};

string solve(const vector<Event> &top_events) {
    /* zone, frequency, priority_sum
       Nord, 45, 123                */
    map<string, pair<int, int> > stats;

    for (size_t i = 0; i < top_events.size(); i++) {
        stats[top_events[i].zone].first++;
        stats[top_events[i].zone].second += top_events[i].priority;
    }

    string best_zone;
    int best_freq = -1;
    int best_prio = -1;

    for (map<string, pair<int, int> >::iterator i = stats.begin(); i != stats.end(); ++i) {
        const string& zone = i->first;
        int freq = i->second.first;
        int prio = i->second.second;

        //cout << zone << " " << freq << " " << prio_sum << endl;

        if (freq > best_freq ||
           (freq == best_freq && prio > best_prio) ||
           (freq == best_freq && prio == best_prio && zone < best_zone)) {

            best_zone = zone;
            best_freq = freq;
            best_prio = prio;
        }
    }
    return best_zone;
}

bool cmp(const Event& a, const Event& b) {
    return a.priority < b.priority || (a.priority == b.priority && a.id > b.id);
}

int main() {
    int n, p, k;
    cin >> n >> p >> k;
    vector<Event> events;

    for (int i = 0; i < n; i++) {
        string id;
        string zone;
        int priority;
        cin >> id >> zone >> priority;
        events.push_back(Event(id, zone, priority));
    }
    make_heap(events.begin(), events.end(), cmp);

    vector<Event> top_events;
    for (int i = 0; i < k && i<events.size(); ++i) {
        pop_heap(events.begin(), events.end(), cmp);
        top_events.push_back(events.back());
        events.pop_back();
    }

    cout << solve(top_events) << endl;
}