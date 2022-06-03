START_SISTEMA=   0x00100000
START_IO=        0x40400000
START_UTENTE=	 0x80000000
SWAP_SIZE=	 20M
SWAP=		 swap.img

NCC ?= g++
NLD ?= ld

NCFLAGS=\
	-Wall 			\
	-nostdlib		\
	-fno-exceptions 	\
	-fno-rtti 		\
	-fno-stack-protector 	\
	-fno-pic 		\
	-fcall-saved-esi 	\
	-fcall-saved-edi 	\
	-fcall-saved-ebx 	\
	-Iinclude		\
	-m32			\
	-g

CFLAGS=-O2
CXXFLAGS=$(CFLAGS)

ifdef AUTOCORR
	NCFLAGS+=-DAUTOCORR
endif

all: build/sistema \
     build/parse   \
     build/creatimg \
     utente/prog
     
build/sistema: sistema/sist_s.o sistema/sist_cpp.o util/crtbegin.o util/crtend.o
	$(NLD) -melf_i386 -nostdlib -o build/sistema -Ttext $(START_SISTEMA) util/crtbegin.o sistema/sist_s.o sistema/sist_cpp.o util/crtend.o

build/io: io/io_s.o io/io_cpp.o
	$(NLD) -melf_i386 -nostdlib -o build/io -Ttext $(START_IO) io/io_s.o io/io_cpp.o

build/utente: utente/uten_s.o utente/lib.o utente/uten_cpp.o
	$(NLD) -melf_i386 -nostdlib -o build/utente -Ttext $(START_UTENTE) utente/uten_cpp.o utente/uten_s.o utente/lib.o

# compilazione di sistema.s e sistema.cpp
sistema/sist_s.o: sistema/sistema.S include/costanti.h
	$(NCC) $(NCFLAGS) -c sistema/sistema.S -o sistema/sist_s.o

sistema/sist_cpp.o: sistema/sistema.cpp include/mboot.h include/costanti.h
	$(NCC) $(NCFLAGS) -c sistema/sistema.cpp -o sistema/sist_cpp.o

# compilazione di io.s e io.cpp
io/io_s.o: io/io.S include/costanti.h
	$(NCC) $(NCFLAGS) -c io/io.S -o io/io_s.o

io/io_cpp.o: io/io.cpp include/costanti.h
	$(NCC) $(NCFLAGS) -c io/io.cpp -o io/io_cpp.o

# compilazione di utente.s e utente.cpp
utente/uten_s.o: utente/utente.S include/costanti.h
	$(NCC) $(NCFLAGS) -c utente/utente.S -o utente/uten_s.o

utente/utente.cpp: build/parse utente/prog/*.in utente/include/* utente/prog
	build/parse -o utente/utente.cpp utente/prog/*.in

utente/uten_cpp.o: utente/utente.cpp
	$(NCC) $(NCFLAGS) -Iutente/include -c utente/utente.cpp -o utente/uten_cpp.o

utente/lib.o: utente/lib.cpp utente/include/lib.h
	$(NCC) $(NCFLAGS) -Iutente/include -c utente/lib.cpp -o utente/lib.o

# creazione di parse e createimg
build/parse: util/parse.c util/src.h
	gcc $(CFLAGS) -o build/parse util/parse.c

util/coff.o: include/costanti.h util/interp.h util/coff.h util/dos.h util/coff.cpp
	g++ $(CXXFLAGS) -c -g -Iinclude -o util/coff.o util/coff.cpp

util/elf.o:  include/costanti.h util/interp.h util/elf.h util/elf.cpp
	g++ $(CXXFLAGS) -c -g -Iinclude -o util/elf.o util/elf.cpp

util/interp.o: include/costanti.h util/interp.h util/interp.cpp
	g++ $(CXXFLAGS) -c -g -Iinclude -o util/interp.o util/interp.cpp

util/swap.o: include/costanti.h util/swap.h util/swap.cpp
	g++ $(CXXFLAGS) -c -g -Iinclude -o util/swap.o util/swap.cpp

util/fswap.o: include/costanti.h util/swap.h util/fswap.cpp
	g++ $(CXXFLAGS) -c -g -Iinclude -o util/fswap.o util/fswap.cpp

util/creatimg.o: util/interp.h util/swap.h util/creatimg.cpp
	g++ $(CXXFLAGS) -c -g -Iinclude -o util/creatimg.o util/creatimg.cpp

util/crtbegin.o: util/crtbegin.S
	$(NCC) $(NCFLAGS) -c util/crtbegin.S -o util/crtbegin.o

util/crtend.o: util/crtend.S
	$(NCC) $(NCFLAGS) -c util/crtend.S -o util/crtend.o

build/creatimg: util/creatimg.o util/elf.o util/coff.o util/interp.o util/swap.o util/fswap.o
	g++ $(CXXFLAGS) -g -o build/creatimg util/creatimg.o util/elf.o util/coff.o util/interp.o util/swap.o util/fswap.o

# creazione del file di swap
$(SWAP):
	truncate -s $(SWAP_SIZE) $(SWAP)

.PHONY: swap clean reset
swap: build/creatimg build/io build/utente $(SWAP)
	build/creatimg $(SWAP) build/io build/utente && ln -fs $(SWAP) .swap

clean:
	rm -f sistema/*.o io/*.o utente/*.o util/*.o

reset: clean
	rm -f build/* swap

build:
	mkdir -p $@

utente/prog:
	mkdir -p $@
