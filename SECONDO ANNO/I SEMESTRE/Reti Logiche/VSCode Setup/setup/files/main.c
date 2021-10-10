#include <stdlib.h>
#include <termios.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>

// This code is used to switch terminal in 'raw' mode at startup
// 'cooked': terminal input is buffered, and sent to program only after ENTER is pressed.
// 'raw': terminal input is not buffered, each keystroke is sent directly to the program

// Due to how our primitives work, we need 'raw' mode

// Credits to https://viewsourcecode.org/snaptoken/kilo/02.enteringRawMode.html

struct termios orig_termios;

void disableRawMode() {
  tcsetattr(STDIN_FILENO, TCSAFLUSH, &orig_termios);
}

void enableRawMode() {
  tcgetattr(STDIN_FILENO, &orig_termios);
  atexit(disableRawMode);
  struct termios raw = orig_termios;
  raw.c_oflag &= ~(OPOST);
  raw.c_lflag &= ~(ECHO | ICANON);
  tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}

// This code is used to catch a segmentation fault and print a message
// The usual message is printed by bash, based on the exit status of the program (139)
// pwsh does not, so we have to do it manually
void handler(int sig) {
  printf("Segmentation fault\r\n");
  exit(128 + sig);
}

// Entry point for the assembler code
extern int _main();

// Actual entrypoint for the program
// It is different from the DOS environment (main instead of _main) 
int main() {
    enableRawMode();
    signal(SIGSEGV, handler);
    _main();
    return 0;
}