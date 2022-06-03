/*****************************************************************************
LBA version of biosdisk() for DJGPP
Chris Giese <geezer@execpc.com>	http://my.execpc.com/~geezer
Release date: Jan 2, 2004
This code is public domain (no copyright).
You can do whatever you want with it.
*****************************************************************************/
#include <stdio.h> /* printf() */
#include <bios.h> /* _DISK_... */
#include <dpmi.h> /* __dpmi_regs, __dpmi_int() */
#include <go32.h> /* _go32_info_block, __tb, dosmemget(), dosmemput() */
#include <string.h>
#include "costanti.h"
#include "swap.h"

#define	BPS	512	/* bytes per sector for disk */

typedef unsigned char		uint8_t;
typedef unsigned short		uint16_t;
typedef unsigned long		uint32_t;
typedef unsigned long long	uint64_t;

struct partizione {
	int	     type;	// tipo della partizione
	unsigned int first;	// primo settore della partizione
	unsigned int dim;	// dimensione in settori
	partizione*  next;
};

static int lba_biosdisk(unsigned int13_drive_num, int cmd, unsigned long lba, unsigned nsects, void *buf);
static int get_disk_size(unsigned int13_drive_num, unsigned& nsec);

class TipoDOSwap: public TipoSwap
{
	static const int MAX_DISCHI = 8;
	partizione *partizioni[MAX_DISCHI];
public:
	TipoDOSwap();
	~TipoDOSwap();
	Swap *apri(const char* name);

private:
	static partizione* leggi_partizioni(unsigned drv);
	void read_all_partitions();
};

class DOSwap: public Swap
{
	partizione p;
	int bios_disk;
public:
	DOSwap(const partizione *p_, int d) : p(*p_), bios_disk(d) {}
	~DOSwap() {}
	unsigned int dimensione() const;
protected:
	bool leggi(unsigned int off, void* buff, unsigned int size);
	bool scrivi(unsigned int off, const void* buff, unsigned int size);
};

TipoDOSwap::TipoDOSwap()
{
	read_all_partitions();
}

TipoDOSwap::~TipoDOSwap()
{
	for (int drv = 0; drv < MAX_DISCHI; drv++) {
		partizione* p = partizioni[drv];
		while (p) {
			partizione *tmp = p;
			p = p->next;
			delete tmp;
		}
	}
}

Swap* TipoDOSwap::apri(const char *nome)
{
	if (nome == NULL || nome[0] != ':')
		return NULL;

	int drv = atoi(nome + 1);

	if (drv < 0 || drv > MAX_DISCHI || partizioni[drv] == NULL) 
		return NULL;

	char *sep = index(nome + 1, '/');
	int part = 0;
	if (sep) 
		part = atoi(sep + 1);
	partizione *scan = partizioni[drv];
	int i = 0;
	while (i < part && scan) {
		scan = scan->next;
		i++;
	}
	if (i < part || !scan || scan->dim == 0 || scan->type != 0x3f)
		return NULL;

	return new DOSwap(scan, drv + 0x80);
}
	

static int lba_biosdisk(unsigned int13_drive_num, int cmd, unsigned long lba, unsigned nsects, void *buf)
{
/* INT 13h AH=42h/AH=43h command packet: */
	struct
	{
		uint8_t  packet_len;	
		uint8_t  reserved1;
		uint8_t  nsects;	
		uint8_t  reserved2;	
		uint16_t buf_offset;	
		uint16_t buf_segment;	
		uint64_t lba;		
	} __attribute__((packed)) lba_cmd_pkt;
	unsigned tries, err = 0;
	__dpmi_regs regs;

	if(cmd != _DISK_READ && cmd != _DISK_WRITE)
		return 0x100;
/* make sure the DJGPP transfer buffer
(in conventional memory) is big enough */
	if(BPS * nsects + sizeof(lba_cmd_pkt) >
		_go32_info_block.size_of_transfer_buffer)
			return 0x100;
/* make sure drive and BIOS support LBA. Note that Win95 DOS box
emulates INT 13h AH=4x if they are not present in the BIOS. */
	regs.x.bx = 0x55AA;
	regs.h.dl = int13_drive_num;
	regs.h.ah = 0x41;
	__dpmi_int(0x13, &regs);
	if(regs.x.flags & 0x0001) /* carry bit (CY) is set */
		return 0x100;
/* fill in the INT 13h AH=4xh command packet */
	memset(&lba_cmd_pkt, 0, sizeof(lba_cmd_pkt));
	lba_cmd_pkt.packet_len = sizeof(lba_cmd_pkt);
	lba_cmd_pkt.nsects = nsects;
/* use start of transfer buffer
for data transferred by BIOS disk I/O... */
	lba_cmd_pkt.buf_offset = 0;
	lba_cmd_pkt.buf_segment = __tb >> 4;
	lba_cmd_pkt.lba = lba;
/* ...use end of transfer buffer for the command packet itself */
	dosmemput(&lba_cmd_pkt, sizeof(lba_cmd_pkt), __tb + BPS * nsects);
/* fill in registers for INT 13h AH=4xh */
	regs.x.ds = (__tb + BPS * nsects) >> 4;
	regs.x.si = (__tb + BPS * nsects) & 0x0F;
	regs.h.dl = int13_drive_num;
/* if writing, copy the data to conventional memory now */
	if(cmd == _DISK_WRITE)
		dosmemput(buf, BPS * nsects, __tb);
/* make 3 attempts */
	for(tries = 3; tries != 0; tries--)
	{
		regs.h.ah = (cmd == _DISK_READ) ? 0x42 : 0x43;
		__dpmi_int(0x13, &regs);
		err = regs.h.ah;
		if((regs.x.flags & 0x0001) == 0)
		{
/* if reading, copy the data from conventional memory now */
			if(cmd == _DISK_READ)
				dosmemget(__tb, BPS * nsects, buf);
			return 0;
		}
/* reset disk */
		regs.h.ah = 0;
		__dpmi_int(0x13, &regs);
	}
	return err;
}

static int get_disk_size(unsigned int13_drive_num, unsigned& nsec)
{
	struct {
		uint16_t 	buff_size;
		uint16_t	flags;
		uint32_t	cyl;
		uint32_t	head;
		uint32_t	spt;
		uint64_t	nsec;
		uint16_t	bps;
		// v2.0+
		uint32_t	edd_parm;
		// v3.0
		uint16_t	signature;
		uint8_t		dev_path_len;
		uint8_t		reserved1[3];
		uint8_t		bus_name[4];
		uint8_t		iface_name[8];
		uint8_t		iface_path[8];
		uint8_t		dev_path[8];
		uint8_t		reserverd2;
		uint8_t		checksum;
	} __attribute__((packed)) int13ext_dparm;
	__dpmi_regs regs;

	memset(&int13ext_dparm, 0, sizeof(int13ext_dparm));
	int13ext_dparm.buff_size = sizeof(int13ext_dparm);
	dosmemput(&int13ext_dparm, sizeof(int13ext_dparm), __tb);
	regs.h.ah = 0x48;
	regs.h.dl = int13_drive_num;
	regs.x.ds = __tb >> 4;
	regs.x.si = __tb & 0x0F;
	__dpmi_int(0x13, &regs);
	if(regs.x.flags & 0x0001) /* carry bit (CY) is set */
		return 0x100;
	dosmemget(__tb, sizeof(int13ext_dparm), &int13ext_dparm);
	nsec = (unsigned)int13ext_dparm.nsec;
	return 0;
}
	
	

// descrittore di una partizione dell'hard disk
//
// descrittore di partizione. Le uniche informazioni che ci interessano sono 
// "offset" e "sectors"

partizione* TipoDOSwap::leggi_partizioni(unsigned drv)
{
	struct des_part {
		unsigned int active	: 8;
		unsigned int head_start	: 8;
		unsigned int sec_start	: 6;
		unsigned int cyl_start_H: 2;
		unsigned int cyl_start_L: 8;
		unsigned int type	: 8;
		unsigned int head_end	: 8;
		unsigned int sec_end	: 6;
		unsigned int cyl_end_H	: 2;
		unsigned int cyl_end_L	: 8;
		unsigned int offset;
		unsigned int sectors;
	} __attribute__((packed));
	char errore;
	des_part* p;
	partizione *estesa, **ptail, *head = NULL;
	char buf[BPS];
	partizione *pp;

	// lettura del Master Boot Record (LBA = 0)
	errore = lba_biosdisk(drv, _DISK_READ, 0, 1, buf);
	if (errore != 0)
		goto errore;
		
	p = reinterpret_cast<des_part*>(buf + 446);
	// interpretiamo i descrittori delle partizioni primarie
	estesa = 0;
	head = pp = new partizione;
	// la partizione 0 corrisponde all'intero hard disk
	pp->type = 0;
	pp->first = 0;
	pp->next = NULL;
	if (get_disk_size(drv, pp->dim) != 0)
		goto errore;
	ptail = &pp->next;
	for (int i = 0; i < 4; i++) {
		pp = *ptail = new partizione;

		pp->type  = p->type;
		pp->first = p->offset;
		pp->dim   = p->sectors;
		
		if (pp->type == 5)
			estesa = *ptail;

		ptail = &pp->next;
		p++;
	}
	if (estesa != 0) {
		// dobbiamo leggere le partizioni logiche
		unsigned int offset_estesa = estesa->first;
		unsigned int offset_logica = offset_estesa;
		while (1) {
			errore = lba_biosdisk(drv, _DISK_READ, offset_logica, 1, buf);
			if (errore != 0)
				goto errore;
			p = reinterpret_cast<des_part*>(buf + 446);
			
			*ptail = new partizione;
			
			(*ptail)->type  = p->type;
			(*ptail)->first = p->offset + offset_logica;
			(*ptail)->dim   = p->sectors;

			ptail = &(*ptail)->next;
			p++;

			if (p->type != 5) break;

			offset_logica = p->offset + offset_estesa;
		}
	}
	*ptail = 0;
	
	return head;

errore:
	while (head) {
		pp = head->next;
		delete head;
		head = pp;
	}
	return NULL;
}

void TipoDOSwap::read_all_partitions()
{
	for (unsigned drv = 0x80; drv < 0x80 + MAX_DISCHI; drv++)
		partizioni[drv - 0x80] = leggi_partizioni(drv);
}
		
unsigned int DOSwap::dimensione() const
{
	return p.dim * BPS;
}

bool DOSwap::leggi(unsigned int off, void* buf, unsigned int size)
{
	const int STEP = 3;
	char work[BPS];

	if (off + size > p.dim * BPS)
		return false;

	unsigned int fsec = off / BPS;
	unsigned int skip = off - fsec * BPS;
	fsec += p.first;
	if (skip) {
		if (lba_biosdisk(bios_disk, _DISK_READ, fsec, 1, work))
			return false;
		unsigned int toread = (size > BPS - skip) ? BPS - skip: size;
		memcpy(buf, work + skip, toread);
		buf = (char*)buf + toread;
		size -= toread;
		fsec++;
	}
	while (size >= BPS) {
		unsigned int nsec = size / BPS;
		unsigned int toread = (nsec > STEP) ? STEP : nsec;
		if (lba_biosdisk(bios_disk, _DISK_READ, fsec, toread, buf))
			return false;
		fsec += toread;
		size -= toread * BPS;
		buf = (char*)buf + (toread * BPS);
	}
	if (size > 0) {
		if (lba_biosdisk(bios_disk, _DISK_READ, fsec, 1, work))
			return false;
		memcpy(buf, work, size);
	}
	return true;
}

bool DOSwap::scrivi(unsigned int off, const void* buf, unsigned int size)
{
	const int STEP = 3;
	char work[BPS];


	if (off + size > p.dim * BPS)
		return false;

	unsigned int fsec = off / BPS;
	unsigned int skip = off - fsec * BPS;
	fsec += p.first;
	if (skip) {
		if (lba_biosdisk(bios_disk, _DISK_READ, fsec, 1, work))
			return false;
		unsigned int towrite = (size > BPS - skip) ? BPS - skip : size;
		memcpy(work + skip, buf, towrite);
		if (lba_biosdisk(bios_disk, _DISK_WRITE, fsec, 1, work))
			return false;
		buf = (char*)buf + towrite;
		size -= towrite;
		fsec++;
	}
	while (size >= BPS) {
		unsigned int nsec = size / BPS;
		unsigned int towrite = (nsec > STEP) ? STEP : nsec;
		if (lba_biosdisk(bios_disk, _DISK_WRITE, fsec, towrite, (void*)buf))
			return false;
		fsec += towrite;
		size -= towrite * BPS;
		buf = (char*)buf + (towrite * BPS);
	}
	if (size > 0) {
		if (lba_biosdisk(bios_disk, _DISK_READ, fsec, 1, work))
			return false;
		memcpy(work, buf, size);
		if (lba_biosdisk(bios_disk, _DISK_WRITE, fsec, 1, (void*)work))
			return false;
	}
	return true;
}

TipoDOSwap tipoDOSwap;
