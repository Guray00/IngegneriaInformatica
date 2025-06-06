#ifndef ELF_H_
#define ELF_H_

#include <stdint.h>

typedef uint16_t   Elf32_Half;
typedef uint32_t   Elf32_Word;
typedef uint32_t   Elf32_Off;
typedef uint32_t   Elf32_Addr;


#define ET_NONE		0
#define	ET_REL		1
#define	ET_EXEC		2
#define	ET_DYN		3
#define	ET_CORE		4
#define	ET_LOPROC	0xff00
#define	ET_HIPROC	0xffff

#define EM_NONE		0
#define	EM_M32		1
#define	EM_SPARC	2
#define EM_386		3
#define EM_68K		4
#define EM_88K		5
#define EM_860		7
#define EM_MIPS		8


#define EI_MAG0		0
#define EI_MAG1		1
#define EI_MAG2		2
#define EI_MAG3		3
#define EI_CLASS	4
#define EI_DATA		5
#define EI_VERSION 	6
#define EI_PAD		7
#define EI_NIDENT 	16

#define ELFMAG0		0x7f
#define	ELFMAG1		'E'
#define	ELFMAG2		'L'
#define	ELFMAG3		'F'

#define ELFCLASSNONE 	0
#define ELFCLASS32	1
#define ELFCLASS64	2

#define ELFDATANONE	0
#define ELFDATA2LSB	1
#define ELFDATA2MSB	2

#define PF_R            0x4
#define PF_W            0x2
#define PF_X            0x1

typedef struct {
        unsigned char e_ident[EI_NIDENT];
        Elf32_Half    e_type;
        Elf32_Half    e_machine;
        Elf32_Word    e_version;
        Elf32_Addr    e_entry;
        Elf32_Off     e_phoff;
        Elf32_Off     e_shoff;
        Elf32_Word    e_flags;
        Elf32_Half    e_ehsize;
        Elf32_Half    e_phentsize;
        Elf32_Half    e_phnum;
        Elf32_Half    e_shentsize;
        Elf32_Half    e_shnum;
        Elf32_Half    e_shstrndx;
} Elf32_Ehdr;



#define	PT_NULL		0
#define PT_LOAD		1
#define PT_DYNAMIC	2
#define PT_INTERP	3
#define PT_NOTE		4
#define PT_SHLIB	5
#define PT_PHDR		6
#define PT_LOPROC	0x70000000
#define PT_HIPROC	0x7fffffff

typedef struct {
        Elf32_Word p_type;
        Elf32_Off  p_offset;
        Elf32_Addr p_vaddr;
        Elf32_Addr p_paddr;
        Elf32_Word p_filesz;
        Elf32_Word p_memsz;
        Elf32_Word p_flags;
        Elf32_Word p_align;
} Elf32_Phdr;


typedef struct {
        Elf32_Word sh_name;
        Elf32_Word sh_type;
        Elf32_Word sh_flags;
        Elf32_Addr sh_addr;
        Elf32_Off  sh_offset;
        Elf32_Word sh_size;
        Elf32_Word sh_link;
        Elf32_Word sh_info;
        Elf32_Word sh_addralign;
        Elf32_Word sh_entsize;
} Elf32_Shdr;

                
#define SHT_NULL                        0
#define SHT_PROGBITS                    1
#define SHT_SYMTAB                      2
#define SHT_STRTAB                      3
#define SHT_RELA                        4
#define SHT_HASH                        5
#define SHT_DYNAMIC                     6
#define SHT_NOTE                        7
#define SHT_NOBITS                      8
#define SHT_REL                         9
#define SHT_SHLIB                      10
#define SHT_DYNSYM                     11
#define SHT_LOPROC             0x70000000
#define SHT_HIPROC             0x7fffffff
#define SHT_LOUSER             0x80000000
#define SHT_HIUSER             0xffffffff

                  
#define SHF_WRITE                  0x1
#define SHF_ALLOC                  0x2
#define SHF_EXECINSTR              0x4
#define SHF_MASKPROC               0xf0000000
                     
#endif
