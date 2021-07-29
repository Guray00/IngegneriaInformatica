/*
 * parse.c
 * NOTA: snprintf non disponibile sotto windows (libc del djgpp di calcolatori)
 */
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define DEF_PRIO	20

FILE *input,*output;	        	/* uscita del parser */
char look;			/* carattere sotto esame */

int riga, colonna, pos;		/* posizione corrente */

#define LUN_NOME 256		/* lunghezza massima di un identificatore */
char nome[LUN_NOME];		/* ultimo identificatore (o intero) letto */

#define LUN_RIGA 1024
char ultima_riga[LUN_RIGA];

const char* currfile;
int line_needed = 0;
const char* outname = "utente.cpp";
int riga_out = 1;

/*
 * Stampa di un messaggio di errore in presenza di un errore nel parsing
 *  ed uscita dal programma
 */
void atteso(const char *msg, char c)
{
	char buf[256];

#if defined WIN || defined WIN_XP
	if(msg)
		sprintf(buf, "Aspettavo %s", msg);
	else
		sprintf(buf, "Aspettavo %c", c);
#else
	if(msg)
		snprintf(buf, 256, "Aspettavo %s", msg);
	else
		snprintf(buf, 256, "Aspettavo %c", c);
#endif

	fseek(input, pos, SEEK_SET);
	fgets(ultima_riga, LUN_RIGA, input);
	if(ultima_riga[strlen(ultima_riga) - 1] == '\n')
		ultima_riga[strlen(ultima_riga) - 1] = 0;
	
	printf("\n%s\n%*s\n%s\n", ultima_riga, colonna, "^", buf);
	exit(-1);
}

/*
 * Stampa di un messaggio di errore generico ed uscita dal programma
 */
void errore(const char *msg)
{
	printf("Errore: %s\n", msg);
	exit(-1);
}

/*
 * Legge il carattere successivo dall' ingresso
 */
void emetti_line();
void emetti_line2();
void emetti(const char *t);
void leggi_car()
{
	look = fgetc(input);
	if(look == '\n') {
		if (line_needed) {
			emetti("\n");
			emetti_line();
			line_needed = 0;
		}
		++riga;
		pos += colonna + 1;
		colonna = 0;
	} else if(look == '\t')
		colonna += 8 - colonna % 8;
	else
		++colonna;
}

/*
 * Salta i caratteri di spaziatura letti
 */
void salta_spazi()
{
	while(isspace(look))
		leggi_car();
}

void copia_car();

/*
 * Salta un commento (riportandolo sull' uscita)
 */
void salta_commento()
{
	copia_car();
	leggi_car();

	if(look == '/') {
		while(!feof(input) && look != '\n') {
			copia_car();
			leggi_car();
		}
		copia_car();
		leggi_car();
	} else if(look == '*') {
		do {
			copia_car();
			leggi_car();
			while(!feof(input) && look != '*') {
				copia_car();
				leggi_car();
			}
			copia_car();
			leggi_car();
		} while(look != '/');
		copia_car();
		leggi_car();
	} 
}

/*
 * Legge l' identificatore successivo (comprende il carattere look attuale),
 *  lo lascia in nome e avanza
 */
void leggi_nome(int salta)
{
	int i = 0;

	if(look != '_' && !isalpha(look))
		atteso("un identificatore", 0);

	while(look == '_' || isalnum(look)) {
		if(i >= LUN_NOME)
			errore("identificatore troppo lungo");

		nome[i++] = look;
		leggi_car();
	}

	if(salta)
		salta_spazi();

	nome[i] = 0;
}

/*
 * Legge il numero successivo e lascia la stringa che lo rappresenta in nome,
 *  si comporta come leggi_nome
 */
void leggi_numero(int salta)
{
	int i = 0;

	if(!isdigit(look))
		atteso("un numero", 0);

	while(isdigit(look)) {
		if(i >= LUN_NOME)
			errore("numero troppo lungo");

		nome[i++] = look;
		leggi_car();
	}

	if(salta)
		salta_spazi();

	nome[i] = 0;
}

void leggi_arg(int salta)
{
	if (look != '_' && !isalpha(look))
		return leggi_numero(salta);
	leggi_nome(salta);
}

/*
 * Verifica che look sia uguale a c ed avanza
 */
void trova(char c, int salta)
{
	if(look != c)
		atteso(0, c);
	leggi_car();

	if(salta)
		salta_spazi();
}

/*
 * Verifica che nome sia uguale a n ed avanza
 */
void trova_nome(const char *n, int salta)
{
	leggi_nome(0);
	if(strcmp(nome, n))
		atteso(n, 0);
	if(salta)
		salta_spazi();
}

/*
 * Copia look sull' uscita
 */
void copia_car()
{
	fprintf(output, "%c", look);
	if (look == '\n')
		riga_out++;
}

/*
 * Copia nome sull' uscita
 */
void copia_nome()
{
	emetti(nome);
}

/*
 * Scrive sull' uscita t
 */
void emetti(const char *t)
{
	const char *w;
	fprintf(output, "%s", t);
	for (w = strchr(t, '\n'); w; w = strchr(w + 1, '\n'))
		riga_out++;
}

void emetti_line()
{
	char linep[LUN_RIGA];
	sprintf(linep, "#line %d \"%s\"\n", riga, currfile);
	emetti(linep);
}

void emetti_line2()
{
	char linep[LUN_RIGA];
	sprintf(linep, "#line %d \"%s\"\n", riga_out + 1, outname);
	emetti(linep);
}

/*
 * Alloca s bytes, verificando la presenza di errori
 */
void *xmalloc(size_t s)
{
	void *rv;

	if(!(rv = malloc(s)))
		errore("memoria insufficiente");

	return rv;
}

struct file_elem {
	char *testo;
	struct file_elem *succ;
};

struct file_elem *utente[2], *fine[2];

#define GLOB 0
#define MAIN 1

void agg_riga(int sez, char *r)
{
	struct file_elem *n;

	n = xmalloc(sizeof(struct file_elem));

	n->testo = strdup(r);
	if(!n->testo)
		errore("memoria insufficiente");

	n->succ = 0;

	if(utente[sez]) {
		fine[sez]->succ = n;
		fine[sez] = n;
	} else {
		utente[sez] = n;
		fine[sez] = n;
	}
}

void rilascia_righe()
{
	struct file_elem *ep;
	int sez;

	for(sez = 0; sez < 2; ++sez) {
		ep = utente[sez];
		while(ep) {
			ep = utente[sez]->succ;
			free(utente[sez]->testo);
			free(utente[sez]);
			utente[sez] = ep;
		}
		fine[sez] = 0;
	}
}

//#define MAIN_HEAD "\nint main()\n{\n\tdummy = activate_p(dd, 0, 1, LIV_UTENTE);\n"
#define MAIN_HEAD "\nvoid main()\n{\n"

#if defined WIN || defined WIN_XP
#define MAIN_TAIL "\n\tterminate_p();\n}\n\nextern\"C\" void __main()\n{\n}\n"
#else
#define MAIN_TAIL "\n\tterminate_p();}\n"
#endif

void scrivi_utente()
{
	struct file_elem *ep;
	int i;

	for(ep = utente[0]; ep; ep = ep->succ)
		emetti(ep->testo);

	emetti_line2();
	emetti(MAIN_HEAD);
	for(ep = utente[1]; ep; ep = ep->succ)
		emetti(ep->testo);

	emetti(MAIN_TAIL);
}

#define GLOB_FMT "natl %s;\n"
#define PROC_FMT "\t%s = activate_p(%s, %s, %d, %s);\n"

#define MAX_INT_LEN 12

void agg_proc(const char *nome_proc, const char *corpo_proc, const char *par_att,
	int prio, int liv)
{
	int dim1, dim2, dim;
	char *buf;

	dim1 = strlen(GLOB_FMT) + strlen(nome_proc);
	dim2 = strlen(PROC_FMT) + strlen(nome_proc) + strlen(corpo_proc) +
		strlen(par_att)	+ strlen("LIV_SISTEMA");

	dim = dim1 < dim2 ? dim2: dim1;

	buf = malloc(dim);
	if(!buf)
		errore("memoria insufficiente");

#if defined WIN || defined WIN_XP
	sprintf(buf, PROC_FMT, nome_proc, corpo_proc, par_att, prio,
		liv == 3? "LIV_UTENTE": "LIV_SISTEMA");
	agg_riga(MAIN, buf);

	sprintf(buf, GLOB_FMT, nome_proc);
	agg_riga(GLOB, buf);
#else
	snprintf(buf, dim, PROC_FMT, nome_proc, corpo_proc, par_att, prio,
		liv == 3? "LIV_UTENTE": "LIV_SISTEMA");
	agg_riga(MAIN, buf);

	snprintf(buf, dim, GLOB_FMT, nome_proc);
	agg_riga(GLOB, buf);
#endif

	free(buf);
}

#define INT_FMT "natl %s;\n"
#define SEM_FMT "\t%s = sem_ini(%d);\n"

void agg_sem(const char *nome_sem, int valore)
{
	char *buf;
	int dim1, dim2, dim;

	dim1 = strlen(SEM_FMT) + strlen(nome_sem) + MAX_INT_LEN;
	dim2 = strlen(INT_FMT) + strlen(nome_sem);
	dim = dim1 < dim2 ? dim2: dim1;

	buf = xmalloc(dim);

#if defined WIN || defined WIN_XP
	sprintf(buf, SEM_FMT, nome_sem, valore);
	agg_riga(MAIN, buf);

	sprintf(buf, INT_FMT, nome_sem);
	agg_riga(GLOB, buf);
#else
	snprintf(buf, dim, SEM_FMT, nome_sem, valore);
	agg_riga(MAIN, buf);

	snprintf(buf, dim, INT_FMT, nome_sem);
	agg_riga(GLOB, buf);
#endif

	free(buf);
}

/*
 * Effettua il parsing di un costrutto process
 */
void process()
{
	char nome_proc[LUN_NOME], corpo_proc[LUN_NOME], arg_proc[LUN_NOME];
	int pa = 0, prio, liv;

	salta_spazi();
	leggi_nome(1);			// nome del processo (id)
	strcpy(nome_proc, nome);
	trova_nome("body", 1);
	leggi_nome(1);			// nome del corpo
	strcpy(corpo_proc, nome);
	trova('(', 1);
	if(look != ')') {
		leggi_arg(1);
		strcpy(arg_proc, nome);
	}
	trova(')', 1);

	if(look == ',') {
		trova(',', 1);
		leggi_numero(1);		// proirita'
		prio = strtol(nome, 0, 10);
		if(look == ',') {
			trova(',', 1);
			leggi_nome(1);		// livello
			if(!strcmp(nome, "LIV_UTENTE"))
				liv = 3;
			else if(!strcmp(nome, "LIV_SISTEMA"))
				liv = 0;
			else
				atteso("un valore per il livello (LIV_SISTEMA, LIV_UTENTE)", 0);
		} else
			liv = 3;
	} else {
		prio = DEF_PRIO;
		liv = 3;
	}

	trova(';', 1);
	emetti("\n");
	emetti_line();

	emetti("extern natl ");
	emetti(nome_proc);
	emetti(";\n");
	emetti_line();

	agg_proc(nome_proc, corpo_proc, arg_proc, prio, liv);
}

void avanza()
{
	int cnt = 0;

	if(look == '}')
		return;

	if(look == '/')
		salta_commento();
	else
		copia_car();

	while(!feof(input)) {
		leggi_car();
		if(look == '}' && cnt == 0)
			return;
		if(look == '{')
			++cnt;
		else if(look == '}')
			--cnt;
		else if(look == '/')
			salta_commento();

		copia_car();
	}
}

void process_body()
{
	emetti("void ");
	salta_spazi();
	leggi_nome(1);			// legge il nome della funzione
	copia_nome();

	trova('(', 1);
	if(look == ')') {		// parametro formale omesso
		trova(')', 1);
		emetti("(natq)");
	} else {
		emetti("(");
		trova_nome("natq", 1);
		emetti("natq ");
		leggi_nome(1);		// nome del parametro formale
		copia_nome();
		trova(')', 1);
		emetti(")");
	}

	line_needed = 1;
	trova('{', 0);
	emetti("{");
	avanza();
	emetti("\n\tterminate_p();\n}\n");
	trova('}', 1);
}

void semaphore()
{
	char nome_sem[LUN_NOME];
	int valore;

	salta_spazi();
	leggi_nome(1);
	strcpy(nome_sem, nome);
	trova_nome("value", 1);
	leggi_numero(1);
	valore = strtol(nome, 0, 10);
	trova(';', 1);

	emetti("extern natl ");
	emetti(nome_sem);
	emetti(";\n");
	emetti_line();

	agg_sem(nome_sem, valore);
}

void parse_file(const char* inname, FILE* output)
{
	if(!(input = fopen(inname, "r")))
		errore("impossibile aprire il file di ingresso");

	riga = colonna = pos = 1;
	currfile = inname;
	emetti_line();
	leggi_car();
	
	while(!feof(input)) {
		if(look == '/')
			salta_commento();
		else if(look == 'p' || look == 's') {
			leggi_nome(0);
			if(!strcmp(nome, "process"))
				process();
			else if(!strcmp(nome, "process_body"))
				process_body();
			else if(!strcmp(nome, "semaphore"))
				semaphore();
			else
				copia_nome();
		} else {
			copia_car();
			leggi_car();
		}
	}

	fclose(input);
}

#define LUN_OGGETTI 4096
char oggetti[LUN_OGGETTI];


int main(int argc, char* argv[])
{
	int i;

	if (argc < 2) {
		return EXIT_SUCCESS;
	}

	if (strcmp(argv[1], "-o") == 0) {
		if (argc < 3) {
			fprintf(stderr, "l'opzione '-o' richiede un nome di file");
			return EXIT_FAILURE;
		}
		outname = argv[2];
		argc -= 2;
		argv += 2;
	}

	if (argc < 2) {
		return EXIT_SUCCESS;
	}


	output = fopen(outname, "w");

	if (!output) {
		perror(outname);
		return EXIT_FAILURE;
	}

	for (i = 1; i < argc; i++)
			parse_file(argv[i], output);


	scrivi_utente();
	rilascia_righe();

	fclose(output);

	return EXIT_SUCCESS;
}

