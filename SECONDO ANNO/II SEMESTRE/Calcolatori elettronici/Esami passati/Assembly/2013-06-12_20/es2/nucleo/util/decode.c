#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

union descrittore_pagina {
	// caso di pagina presente
	struct {
		// byte di accesso
		unsigned int P:		1;	// bit di presenza
		unsigned int RW:	1;	// Read/Write
		unsigned int US:	1;	// User/Supervisor
		unsigned int PWT:	1;	// Page Write Through
		unsigned int PCD:	1;	// Page Cache Disable
		unsigned int A:		1;	// Accessed
		unsigned int D:		1;	// Dirty
		unsigned int pgsz:	1;	// non visto a lezione
		// fine byte di accesso
		
		unsigned int global:	1;	// non visto a lezione
		unsigned int avail:	3;	// non usati

		unsigned int address:	20;	// indirizzo fisico
	} p;
	// caso di pagina assente
	struct {
		// informazioni sul tipo di pagina
		unsigned int P:		1;
		unsigned int RW:	1;
		unsigned int US:	1;
		unsigned int PWT:	1;
		unsigned int PCD:	1;

		unsigned int block:	27;
	} a;	
};

struct superblock_t {
	int8_t		magic[4];
	uint32_t	bm_start;
	uint32_t	blocks;
	uint32_t	directory;
	uint32_t	user_entry;
	uint32_t	user_end;
	uint32_t	io_entry;
	uint32_t	io_end;
	uint32_t	checksum;
};

int get_bit() {
	static int nbit = 0;
	static unsigned int bitmap = 0;
	int bit;
	if (nbit == 0) {
		fread(&bitmap, sizeof(bitmap), 1, stdin);
		nbit = sizeof(bitmap) * 8;
	}
	bit = bitmap & 1;
	bitmap >>= 1;
	nbit--;
	return bit;
}

int main(int argc, char* argv[])
{
	union descrittore_pagina p;
	struct superblock_t sb;
	char buf[512];
	int record = 0;
	int count[2];
	int bit, last_bit;
	int i, *w, sum;

	if (argc != 2) {
		fprintf(stderr, "Uso: %s [p|s|b]\n", argv[0]);
		exit(1);
	}
	switch (argv[1][0]) {
	case 'p':
		while (fread(&p, sizeof(p), 1, stdin)) {
			printf("%4d: P=%d RW=%d US=%d block=%d",
				record++, p.a.P, p.a.RW, p.a.US, p.a.block);
			printf(p.a.PWT? " PWT": "    ");
			printf(p.a.PCD? " PCD": "    ");
			printf("\n");
		}
		break;
	case 's':
		fread(buf, 512, 1, stdin);
		fread(&sb, sizeof(sb), 1, stdin);
		printf("magic: %c%c%c%c\n", sb.magic[0], sb.magic[1], sb.magic[2], sb.magic[3]);
		printf("bm_start: %d\n", sb.bm_start);
		printf("blocks: %d\n", sb.blocks);
		printf("directory: %d\n", sb.directory);
		printf("user_entry: %x\n", (unsigned int)sb.user_entry);
		printf("user_end: %x\n", (unsigned int)sb.user_end);
		printf("io_entry: %x\n", (unsigned int)sb.io_entry);
		printf("io_end: %x\n", (unsigned int)sb.io_end);
		printf("checksum: %u", sb.checksum);
		w = (int*)&sb;
		sum = 0;
		for (i = 0; i < sizeof(sb) / sizeof(int); i++)
			sum += w[i];
		printf(" (%s)\n", sum? "BAD" : "OK");
		break;
	case 'b':
		record = 0;
		last_bit = -1;
		while(record <= 4096*32) {
			if (record < 4096*32 && (bit = get_bit()) == last_bit)
				count[bit]++;
			else {
				if (last_bit >= 0) {
					printf("%6d+%6d: %s\n", record-count[last_bit], count[last_bit],
							last_bit ? "liberi" : "occupati");
					count[last_bit] = 0;
				}
				last_bit = bit;
				count[last_bit] = 1;
			}
			record++;
		}
		break;
	default:
		fprintf(stderr, "Tipo non riconosciuto: '%s'\n", argv[1]);
		exit(1);
	}
	return 0;
}
