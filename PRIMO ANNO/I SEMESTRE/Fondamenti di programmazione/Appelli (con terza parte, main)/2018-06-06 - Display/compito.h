#include <iostream>

using namespace std;

class Display
{
    char **dis;
    int col;
    int lin;
    int cur;

    friend ostream& operator<<(ostream& os, const Display& d);

public:
    Display(int L, int C);
    Display(const Display& d);
    void writeT(const char* str);
    void writeW(const char* str);
    Display& operator=(const Display& d);
    ~Display();
};
