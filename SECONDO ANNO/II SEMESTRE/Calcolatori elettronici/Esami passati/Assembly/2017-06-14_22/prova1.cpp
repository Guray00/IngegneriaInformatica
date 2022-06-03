// prova1.cpp
#include "cc.h"
int main()
{
	st1 s1 = { 'e', 'b', 'f', 'd', 'a', 'r', 'x', 'i' };
	st1 s3 = { 'm', 'n', 'c', 'j', 's', 'h', 'u', 't' };
	st1 sa = { 1, 20, 3, 40 };
	st2 sb = { 10, 2, 30, 4 };
	cl cla('h', sa);
	cla.stampa();
	cla.elab1(s3, sb);
	cla.stampa();
}
    
