#ifndef DOS_H_
#define DOS_H_

struct DOS_EXE {
  unsigned short signature; /* == 0x5a4D */
  unsigned short bytes_in_last_block;
  unsigned short blocks_in_file;
  unsigned short num_relocs;
  unsigned short header_paragraphs;
  unsigned short min_extra_paragraphs;
  unsigned short max_extra_paragraphs;
  unsigned short ss;
  unsigned short sp;
  unsigned short checksum;
  unsigned short ip;
  unsigned short cs;
  unsigned short reloc_table_offset;
  unsigned short overlay_number;
};

const unsigned short DOS_MAGIC = 0x5a4D;

#endif
