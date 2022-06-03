#include <stdio.h>
#include <stdlib.h>

#define BLOCK_SIZE 4096

int main(int argc, char* argv[])
{
	char buf[BLOCK_SIZE];
	FILE* f;
	int bn;

	if (argc < 3) {
		fprintf(stderr, "utilizzo: %s <numero blocco> <file>\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	bn = atoi(argv[1]);

	if ( (f = fopen(argv[2], "r")) == NULL  	||
	     fseek(f, BLOCK_SIZE * bn, SEEK_SET) < 0	||
	     fread(buf, BLOCK_SIZE, 1, f) < 1) {
		perror(argv[2]);
		exit(EXIT_FAILURE);
	}
	fclose(f);

	fwrite(buf, BLOCK_SIZE, 1, stdout);

	return EXIT_SUCCESS;
}
	
