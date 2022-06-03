#ifndef _LIB_H_
#define _LIB_H_
#include <sys.h>

char* copy(const char* src, char* dst);
char* convint(int n, char* out);
natl strlen(const char *s);
char *strncpy(char *dest, const char *src, size_t l);
void *mem_alloc(natl quanti);
void mem_free(void *ptr);

int snprintf(char *buf, natl n, const char *fmt, ...);
int printf(const char *fmt, ...);
void pause();

// copia n byte da src a dst
extern "C" void *memcpy(void *dest, const void *src, unsigned int n);
// copia c nei primi n byte della zona di memoria puntata da dest
extern "C" void *memset(void *dest, int c, unsigned int n);

void flog(log_sev sev, const char* fmt, ...);

#endif
