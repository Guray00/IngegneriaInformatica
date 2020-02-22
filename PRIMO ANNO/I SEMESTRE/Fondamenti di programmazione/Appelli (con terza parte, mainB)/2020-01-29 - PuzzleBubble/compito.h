#include <iostream>
using namespace std;

#define WIDTH 6
#define HEIGHT 10

class PuzzleBobble{
   char tiles[HEIGHT][WIDTH];
   int count_bubbles(int row, int column, bool pop_them); // (per funzionalita' seconda parte)

public:
   // PRIMA PARTE
   PuzzleBobble();
   PuzzleBobble& fire(int, char);
   operator int()const;
   friend ostream& operator<<(ostream&, const PuzzleBobble&);

   // SECONDA PARTE
   PuzzleBobble& scroll();
   void compact();
};
