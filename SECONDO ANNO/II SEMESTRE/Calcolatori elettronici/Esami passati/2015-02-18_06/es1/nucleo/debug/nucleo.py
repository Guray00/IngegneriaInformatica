import sys
import gdb
import gdb.printing
import struct
import fcntl
import termios
from gdb.FrameDecorator import FrameDecorator

def esc(c = ''):
    return '\x1b[' + str(c) + 'm';

# colors
class Color:
    black   = esc(30)
    red     = esc(31)
    green   = esc(32)
    yellow  = esc(33)
    blue    = esc(34)
    magenta = esc(35)
    cyan    = esc(36)
    white   = esc(37)
    reverse = esc(7)
    normal  = esc()

    conf = {
            'col_file'     : green,
            'col_function' : yellow,
            'col_proc_elem': green,
            'col_curline'  : reverse,
            'col_proc_hdr' : yellow,
            'col_var'      : cyan,
            'col_index'    : yellow,
            'col_pag_frame': green,
            'col_tab_frame': yellow,
            'col_res_frame': reverse
            }

def colorize(name, value):
    if name in Color.conf.keys():
        return Color.conf[name] + str(value) + Color.normal
    return value

# cache the inferior
qemu = gdb.selected_inferior()

# cache the terminal size
rows, columns, _, _ = struct.unpack('HHHH', fcntl.ioctl(0, termios.TIOCGWINSZ, struct.pack('HHHH', 0, 0, 0, 0)))

# cache some types
ulong_type = gdb.lookup_type('unsigned long')
des_proc_type = gdb.lookup_type('des_proc')
des_proc_ptr_type = gdb.Type.pointer(des_proc_type)
richiesta_type = gdb.lookup_type('richiesta')
richiesta_ptr_type = gdb.Type.pointer(richiesta_type)
des_sem_type = gdb.lookup_type('des_sem')
des_sem_p = gdb.Type.pointer(des_sem_type)
void_ptr_type = gdb.Type.pointer(gdb.lookup_type('void'))

# which des_proc fields we should show
des_proc_std_fields = [ None, 'id', 'cr3', 'contesto', 'livello', 'precedenza', 'puntatore' ]
toshow = [ f for f in des_proc_type.fields() if f.name not in des_proc_std_fields ]

def toi(v):
    """convert from gdb.Type to unsigned long"""
    try:
        vi = int(v.cast(ulong_type))
    except:
        vi = v
    if vi < 0:
        vi += 1 << 64
    return vi

# get the address of the gdt
gdt = toi(gdb.parse_and_eval("&gdt"))

# cache the vdf
vdf = gdb.parse_and_eval("vdf");

# cache some constants
N_M1 = int(gdb.parse_and_eval('N_M1'))
N_FRAME = int(gdb.parse_and_eval('N_FRAME'))
max_liv  = int(gdb.parse_and_eval('MAX_LIV'))
max_sem = int(gdb.parse_and_eval('MAX_SEM'))
dummy_prio = int(gdb.parse_and_eval('DUMMY_PRIORITY'))
sc_desc  = int(gdb.parse_and_eval('SEL_CODICE_SISTEMA'))
uc_desc  = int(gdb.parse_and_eval('SEL_CODICE_UTENTE'))
ud_desc  = int(gdb.parse_and_eval('SEL_DATI_UTENTE'))
max_proc  = int(gdb.parse_and_eval('MAX_PROC'))
max_prio = int(gdb.parse_and_eval('MAX_PRIORITY'))
min_prio = int(gdb.parse_and_eval('MIN_PRIORITY'))
m_parts = [ 'sis_c', 'sis_p', 'mio_c', 'utn_c', 'utn_p' ]
m_ini = []
m_names = []
for i, p in enumerate(m_parts):
    tr = { 'sis': 'sistema', 'mio': 'IO', 'utn': 'utente' }
    m_ini.append((int(gdb.parse_and_eval('ini_' + p) >> 9*3+12)) & 0o777)
    r, c = m_parts[i].split('_')
    m_names.append(tr[r] + "/" + ('condiviso' if c == 'c' else 'privato'))

def readfis(addr):
    """read an unsigned long from qemu memory"""
    return struct.unpack('Q', bytes(qemu.read_memory(addr, 8)))[0]

def get_process(pid):
    """convert from pid to des_proc *"""
    p = gdb.parse_and_eval('proc_table[{}]'.format(pid))
    if p == gdb.Value(0):
        return None
    return p

def v2p(proc, addr):
    """translate addr in the vm of proc"""
    #gdb.write(f"addr {addr:x}\n")
    tab = toi(proc['cr3'])
    for i in range(max_liv, 0, -1):
        #gdb.write("--> tab{} @ {:16x}\n".format(i, tab))
        shift = 12 + (i - 1) * 9
        addr2 = tab + ((addr >> shift) & 0x1ff) * 8
        #gdb.write("--> ent{} @ {:16x}\n".format(i, addr2))
        entry = readfis(addr2)
        if not (entry & 0x1):
            return None
        tab = entry & ~0xfff
    return tab | (addr & 0xfff)

def show_lines(sal, indent=0):
    curline = sal.line
    fname = sal.symtab.filename
    function = gdb.block_for_pc(sal.pc).function
    gdb.write("file: {} function: {}\n".format(
        colorize('col_file', fname),
        colorize('col_function', function)))
    lines = gdb.execute("list {}:{}".format(fname, curline), False, True)
    found = False
    for l in lines.splitlines():
        if not found:
            w = l.split()
            if len(w) > 0 and int(w[0]) == curline:
                gdb.write(" " * indent + colorize('col_curline', l.expandtabs()) + "\n")
                found = True
                continue
        gdb.write(" " * indent + l + "\n")

def write_key(k, v, indent=0):
    gdb.write("{}{:20s}: {}\n".format(" " * indent, k, v))

def dump_flags(rflags):
    flags = { 14: "NT", 11: "OF", 10: "DF", 9: "IF", 8: "TF", 7: "SF", 6: "ZF", 4: "AF", 2: "PF", 0: "CF" }
    active = []
    for f in flags:
        if rflags & (1 << f):
            active.append(flags[f])
    return "{:x} [{}] iopl={}".format(rflags, " ".join(active), "utente" if rflags & 0x3000 == 0x3000 else "sistema")

def dump_selector(sel):
    if sel == sc_desc:
        name = "SEL_CODICE_SISTEMA"
    elif sel == uc_desc:
        name = "SEL_CODICE_UTENTE"
    elif sel == ud_desc:
        name = "SEL_DATI_UTENTE"
    else:
        name = "sconosciuto"
    return "{:x} [{}]".format(sel, name)

registers = [ 'RAX', 'RCX', 'RDX', 'RBX', 'RSP', 'RBP', 'RSI', 'RDI', 'R8', 'R9', 'R10', 'R11', 'R12', 'R13', 'R14', 'R15' ]
def process_dump(proc, indent=0, verbosity=3):
    write_key("livello", "utente" if proc['livello'] == gdb.Value(3) else "sistema", indent)
    vstack = toi(proc['contesto'][4])
    stack = v2p(proc, vstack)
    if (verbosity > 2):
        gdb.write(colorize('col_proc_hdr', "-- pila sistema ({:016x} \u279e {:x}):\n".format(vstack, stack)), indent)
    rip = readfis(stack)
    write_key("rip", gdb.Value(rip).cast(void_ptr_type), indent)
    if (verbosity > 2):
        write_key("cs",  dump_selector(readfis(stack + 8)), indent)
        write_key("rflags", dump_flags(readfis(stack + 16)), indent)
        write_key("rsp", hex(readfis(stack + 24)), indent)
        write_key("ss",  dump_selector(readfis(stack + 32)), indent)
        gdb.write(colorize('col_proc_hdr', "-- contesto:\n"), indent)
        for i, r in enumerate(registers):
            write_key(r, hex(toi(proc['contesto'][i])), indent)
        cr3 = toi(proc['cr3'])
        write_key("cr3", vm_paddr_to_str(cr3), indent)
        gdb.write(colorize('col_proc_hdr', "-- prossima istruzione:\n"), indent)
        show_lines(gdb.find_pc_line(rip), indent)
    if len(toshow) > 0:
        if verbosity > 2:
            gdb.write("\x1b[33m-- campi aggiuntivi:\x1b[m\n", indent)
        for f in toshow:
            write_key(f.name, proc[f], indent)

def process_list(t='all'):
    for pid in range(max_proc):
        p = get_process(pid)
        if p is None:
            continue
        proc = p.dereference()
        if t == "user" and proc['livello'] != gdb.Value(3):
            continue
        if t == "system" and proc['livello'] == gdb.Value(3):
            continue
        yield (pid, proc)

def parse_process(a):
        if not a:
            a = 'esecuzione->id'
        _pid = gdb.parse_and_eval(a)
        pid = 0
        try:
            pid = int(_pid)
        except:
            pass
        if pid != 0xFFFFFFFF:
            p = get_process(pid)
            if p is None:
                gdb.write("no process with ID {}\n".format(pid))
                return
            p = p.dereference()
        elif _pid.type == des_proc_ptr_type:
            p = pid.dereference()
        elif _pid.type == des_proc_type:
            p = pid
        else:
            raise TypeError("expression must be a (pointer to) des_proc or a process id")
        return p

class Process(gdb.Command):
    """info about processes"""

    def __init__(self):
        super(Process, self).__init__("process", gdb.COMMAND_DATA, prefix=True)

class ProcessDump(gdb.Command):
    """show information from the des_proc of a process.
The argument can be any expression returning a process id or a des_proc*.
If no arguments are given, 'esecuzione->id' is assumed."""
    def __init__(self):
        super(ProcessDump, self).__init__("process dump", gdb.COMMAND_DATA, gdb.COMPLETE_EXPRESSION)

    def invoke(self, arg, from_tty):
        p = parse_process(arg)
        process_dump(p)

class ProcessList(gdb.Command):
    """list existing processes
The command accepts an optional argument which may be 'system'
(show only system processes), 'user' (show only user processes)
or 'all' (default, show all processes)."""

    def __init__(self):
        super(ProcessList, self).__init__("process list", gdb.COMMAND_DATA)

    def invoke(self, arg, from_tty):
        for pid, proc in process_list(arg):
            gdb.write("==> Processo {}\n".format(pid))
            process_dump(proc, indent=4, verbosity=0)

    def complete(self, text, word):
        return [ w for w in [ 'all', 'user', 'system'] if w.startswith(word) ]

Process()
ProcessDump()
ProcessList()

class DesProc(gdb.Function):
    """return a pointer to the des_proc, given the process id"""

    def __init__(self):
        super(DesProc, self).__init__("des_p")

    def invoke(self, pid):
        p = get_process(pid)
        if p is None:
            return gdb.Value(0)
        return p

DesProc()

def sem_list(cond='all'):
    sem = gdb.parse_and_eval("sem_allocati_utente")
    for i in range(sem):
        s = gdb.parse_and_eval("array_dess[{}]".format(i))
        if cond == 'waiting' and s['pointer'] == gdb.Value(0):
            continue
        yield (i, s)
    sem = gdb.parse_and_eval("sem_allocati_sistema")
    for i in range(sem):
        s = gdb.parse_and_eval("array_dess[{}]".format(i + max_sem))
        if cond == 'waiting' and s['pointer'] == gdb.Value(0):
            continue
        yield (i + max_sem, s)

class Semaphore(gdb.Command):
    """show the status of semaphores.
By default, show the status of all allocated semaphores.
With 'waiting' as argument, show only the semaphores with a non-empty waiting queue."""

    def __init__(self):
        super(Semaphore, self).__init__("semaphore", gdb.COMMAND_DATA, prefix=True)

    def invoke(self, arg, from_tty):
        for i, s in sem_list(arg):
            gdb.write(colorize('col_var', "sem[") +
                      colorize('col_index', format(i, '5d')) +
                      colorize('col_var', "]: ") +
                      str(s) + "\n")

    def complete(self, text, word):
        return 'waiting' if 'waiting'.startswith(word) else None

Semaphore()

flags  = { 1: 'W', 2: 'U', 5: 'A', 6: 'D', 7: 'P' }
nflags = { 1: 'R', 2: 'S', 5: '-', 6: '-', 7: '-' }

def vm_decode(indent, f, liv, stop=max_liv, nonpresent=False, rngs=[range(512)]*max_liv):
    if liv > 0 and stop > 0:
        for i in rngs[liv - 1]:
            e = readfis(f + i * 8)
            if e & 1 or (nonpresent and e):
                f1 = e & ~0xFFF
                fl = []
                for j in flags:
                    fl.append(flags[j] if e & (1 << j) else nflags[j])
                gdb.write(" " * indent + "{:03o}: {} ".format(i, "".join(fl)))
                if e & 1:
                     gdb.write(" \u279e {}\n".format(vm_paddr_to_str(f1)))
                     if not e & (1<<7):
                         vm_decode(indent + 10, f1, liv - 1, stop - 1, nonpresent, rngs)
                elif nonpresent:
                    gdb.write("b: {}\n".format(f1 >> 12))

def vm_show_tree(f, liv=max_liv):
    gdb.write(vm_paddr_to_str(f) + "\n")
    vm_decode(0, f, liv, max_liv, False)

def vm_show_table(f, liv=max_liv):
    gdb.write(vm_paddr_to_str(f) + "\n")
    vm_decode(0, f, liv, 1, True)

def vm_vaddr_split(v):
    off = v & 0xfff
    v >>= 12
    idx = [ (v >> (i * 9)) & 0o777 for i in range(max_liv) ]
    h = v >> (9 * max_liv)
    return [ off ] + idx + [h]

def vm_show_path(v, cr3):
    vi = vm_vaddr_split(v)[1:max_liv+1]
    rngs = [ range(i, i + 1) for i in vi ]
    gdb.write("cr3: {}\n".format(vm_paddr_to_str(cr3)))
    vm_decode(0, cr3, max_liv, max_liv, True, rngs)

page_size = { 5: '128PiB', 4: '512GiB', 3: '1GiB', 2: '2MiB', 1: '4KiB' }

def vm_access_byte_to_str(a):
    if not a & 1:
        return "unmapped"
    fl = []
    if a & (1 << 2):
        fl.append("U")
    else:
        fl.append("S")
    if a & (1 << 8):
        fl.append("G")
    if a & (1 << 1):
        fl.append("W")
    else:
        fl.append("R")
    if a & (1 << 3):
        fl.append("PWT")
    if a & (1 << 4):
        fl.append("PCD")
    if a & (1 << 7):
        fl.append("PS")
    if a & (1 << 5):
        fl.append("A")
    if a & (1 << 6):
        fl.append("D")
    return " ".join(fl)

def vm_tab_entry_to_str(d):
    s = vm_access_byte_to_str(d & 0xfff)
    f = d & ~0xfff
    ds = "{:x}: {}".format(toi(d), s)
    if d:
        if d & 1:
            ds += " \u2192 {}".format(vm_paddr_to_str(f))
    return ds

class VaddrParam(gdb.Parameter):
    def __init__(self):
        super (VaddrParam, self).__init__(
                'vaddr-decode',
                gdb.COMMAND_DATA,
                gdb.PARAM_ENUM,
                [ 'hex', 'oct', 'path', 'both' ])
        self.value = 'both'

vaddr_verbose = VaddrParam()

def vm_vaddr_to_str(v, liv=0, verbose='default'):
    r = []
    if verbose == 'default':
        verbose = vaddr_verbose.value
    if verbose in ('hex', 'both'):
        r.append(format(v, '016x'))
    if verbose in ('oct', 'path', 'both'):
        ov = vm_vaddr_split(v)[::-1]
        sov = [ format(v, '03o') for v in ov ][1:-1]
        if verbose == 'oct':
            sov += [ format(ov[-1], '04o') ]
        else:
            liv -= 1
        if ov[0] == 0:
            t = 'S'
        elif ov[0] == (1 << (64 - (max_liv*9+12))) - 1:
            t = 'U'
        else:
            t = "{:o}?".format(ov[0])
        if liv > 0:
            p = "-".join(sov[:-liv]) + "|" + "-".join(sov[-liv:])
        else:
            p = "-".join(sov)
        r.append(t + '-' + p)
    return " ".join(r)

class FrameParam(gdb.Parameter):
    def __init__(self):
        super (FrameParam, self).__init__(
                'show-frame-descriptors',
                gdb.COMMAND_DATA,
                gdb.PARAM_BOOLEAN)
        self.value = True

frame_verbose = FrameParam()

def vm_paddr_to_str(f):
    s = "0x{:08x}".format(toi(f))
    i = f / 4096;
    if frame_verbose.value:
        if i < N_M1:
            s += " [M1]"
        else:
            s += " [M2]"
        if i >= N_FRAME:
            s += " (invalid)"
        else:
            s += " (" + str(toi(vdf[i])) + ")"
    return s

def vm_dump_map(v, a):
    vv = v[:]
    while len(vv) < max_liv:
        vv.append(0)
    vs = []
    if vv[0] >= 256:
        addr = 0xffff
        vs.append("U")
    else:
        addr = 0
        vs.append("S")
    for i in range(max_liv):
        addr = (addr << 9) | vv[i]
        vs.append("{:03o}".format(vv[i]))
    addr <<= 12
    gdb.write("{:016x}  {}: {}\n".format(addr, "-".join(vs), vm_access_byte_to_str(a)))

vm_last = 0xffff
def vm_show_maps_rec(tab, liv, virt, cur):
    global vm_last, m_ini
    if liv == max_liv:
        cur_reg = 0
    for i in range(512):
        if liv == max_liv and cur_reg < len(m_ini) and i == m_ini[cur_reg]:
            gdb.write(colorize('col_proc_hdr', "---" + m_names[cur_reg] + "---\n"))
            cur_reg += 1
        e = readfis(tab + i * 8)
        a = e & 0xfff
        if liv > 1 and not a & (1 << 7):
            a &= ~(1 << 5)  # A
            a &= ~(1 << 6)  # D
        if not cur & (1 << 1): # R/W
            a &= ~(1 << 1)
        if not cur & (1 << 2): # U/S
            a &= ~(1 << 2)
        if not a & 1 and e & ~0xfff:
            a |= (1 << 10) # swapped
        virt.append(i)
        if a & 1 and liv > 1 and not a & (1 << 7):
            f = e & ~0xfff
            vm_show_maps_rec(f, liv - 1, virt, a)
        elif a != vm_last:
            vm_dump_map(virt, a)
            vm_last = a
        virt.pop()

def vm_show_maps(proc):
    global vm_last, cur_reg
    cr3 = toi(proc['cr3'])
    vm_last = 0xffff
    cur_reg = 0
    vm_show_maps_rec(cr3, max_liv, [], 0x7)

class Vm(gdb.Command):
    """info about virtual memory"""

    def __init__(self):
        super(Vm, self).__init__("vm", gdb.COMMAND_DATA, prefix=True)

class VmTree(gdb.Command):
    """show a translation tree.
The command has an optional argument, which is the address of a frame
containing a table. It shows the translation whose root is the given table.
Note that only entries with P=1 are followed.

If called without arguments, it shows the tree that start at the table4 of
'esecuzione->id'."""

    def __init__(self):
        super(VmTree, self).__init__("vm tree", gdb.COMMAND_DATA, gdb.COMPLETE_EXPRESSION)

    def invoke(self, arg, from_tty):
        if not arg:
            arg = '$des_p(esecuzione->id)->cr3'
        f = toi(gdb.parse_and_eval(arg))
        vm_show_tree(f)

class VmTable(gdb.Command):
    """show the entries of a translation table.
The command has a non-optional argument, which is the address of a frame
containing a table. It shows all the entries of the table that are not
completely null."""

    def __init__(self):
        super(VmTable, self).__init__("vm table", gdb.COMMAND_DATA, gdb.COMPLETE_EXPRESSION)

    def invoke(self, arg, from_tty):
        f = toi(gdb.parse_and_eval(arg))
        vm_show_table(f)

class VmPath(gdb.Command):
    """show the translation path of a virtual address.
The command has a non-optional argument, which is a virtual address,
and an optional argument which is a process id ('esecuzione->id' is
assumed by default).
If the optional argument is present it must be separated by a comma.

The command shows the table entries that the MMU must follow to
translate the given virtual address, starting from the table4 of the
given process."""

    def __init__(self):
        super(VmPath, self).__init__("vm path", gdb.COMMAND_DATA, gdb.COMPLETE_EXPRESSION)

    def invoke(self, arg, from_tty):
        a = list(arg.split(","))
        addr = a[0]
        if len(a) > 1:
            pid = a[1]
        else:
            pid = 'esecuzione->id'
        pid = gdb.parse_and_eval(pid)
        proc = get_process(pid)
        if proc is None:
            raise ValueError("no such process " + pid)
        v = toi(gdb.parse_and_eval(addr))
        cr3 = toi(proc['cr3'])
        vm_show_path(v, cr3)

class VmMaps(gdb.Command):
    """show the mappings of an address space.
The command acceptes an optional argument which is a process id
('esecuzione->id' is assumed by default).
The command shows a condensed view of the address space of the process,
grouped by sequential addresses which have the same access byte."""

    def __init__(self):
        super(VmMaps, self).__init__("vm maps", gdb.COMMAND_DATA, gdb.COMPLETE_EXPRESSION)

    def invoke(self, arg, from_tty):
        proc = parse_process(arg)
        vm_show_maps(proc)

Vm()
VmTree()
VmTable()
VmPath()
VmMaps()

class NucleoFrameIterator():

    def __init__(self, frame_iter):
        self.frame_iter = frame_iter

    def __iter__(self):
        return self

    def __next__(self):
        f = self.frame_iter.__next__()
        if f.address() == 0:
            raise StopIteration
        return f

class NucleoFrameFilter:

    def __init__(self):
        self.name = "nucleo"
        self.enabled = True
        self.priority = 100
        gdb.frame_filters[self.name] = self

    def filter(self, frame_iter):
        return NucleoFrameIterator(frame_iter)

NucleoFrameFilter()

def print_hdr(hdr):
    l = (columns - len(hdr) - 2)
    s = l // 2
    gdb.write("\u2500" * s + "[" + hdr + "]" + "\u2500" * (s + (l & 1)))

def print_footer():
    gdb.write("\u2550" * columns)

code_proc = []
class Coda_esecuzione:
    def __init__(self):
        code_proc.append(self)

    def show_waiting(self):
        gdb.write(colorize('col_var', "esecuzione: ") + show_list(gdb.parse_and_eval("esecuzione"), 'puntatore', nmax=1, vis=proc_elem) + "\n")
Coda_esecuzione()

class Coda_pronti:
    def __init__(self):
        code_proc.append(self)

    def show_waiting(self):
        gdb.write(colorize('col_var', "pronti:     ") + show_list(gdb.parse_and_eval("pronti"), 'puntatore', vis=proc_elem) + "\n")
Coda_pronti()

class Code_semafori:
    def __init__(self):
        code_proc.append(self)

    def show_waiting(self):
        gdb.execute("semaphore waiting")
Code_semafori()

class Coda_sospesi:
    def __init__(self):
        code_proc.append(self)

    def show_waiting(self):
        gdb.write(colorize('col_var', "p_sospesi:  ") + show_list(gdb.parse_and_eval("p_sospesi"), 'p_rich') + "\n")
Coda_sospesi()

source = 'Source language is '
def print_context():
    print_hdr("backtrace")
    gdb.execute("backtrace")
    print_hdr("sorgente")
    show_lines(gdb.newest_frame().find_sal())
    print_hdr("variabili")
    s = gdb.execute("info source", False, True)
    if (s[s.index(source) + len(source):].startswith('asm')):
        #gdb.execute("info registers")
        try:
            gdb.execute("x/10gx $rsp")
        except:
            gdb.write("\n")
    else:
        gdb.execute("info args")
        gdb.execute("info locals")
    print_hdr("code processi")
    for c in code_proc:
        c.show_waiting()
    print_footer()

class Context(gdb.Command):
    """print kernel context info"""

    def __init__(self):
        super(Context, self).__init__("context", gdb.COMMAND_DATA)

    def invoke(self, arg, from_tty):
        print_context()

Context()

def show_list(head, link, nmax=20, trunk='...', vis=None):
    elems, p = [], head
    count = 0
    seen = set()
    if vis == None:
        vis = str
    while p != gdb.Value(0):
        if count >= nmax:
            elems.append(trunk)
            break
        elem = p.dereference()
        p = elem[link]
        elems.append(vis(elem))
        pp = toi(p)
        if pp in seen:
            elems.append('LOOP!')
            break
        seen.add(pp)
        count += 1
    return ' \u279e '.join(elems)

def proc_elem(proc):
    """Convert a proc to a string suitable for show_list"""
    prio = int(proc['precedenza'])
    if prio == max_prio:
        prio_str = 'MAX_PRIO'
    elif prio == min_prio:
        prio_str = 'MIN_PRIO'
    elif prio == dummy_prio:
        prio_str = 'DUMMY'
    else:
        prio_str = str(prio)
    i = toi(proc['id'])
    if i == 0xFFFF:
        id_str = '0xFFFF'
    else:
        id_str = str(i)
    return colorize('col_proc_elem', "[{}, {}]".format(id_str, prio_str))

class ptrPrinter:
    """print a pointer"""

    def __init__(self, val, omit=False):
        self.val = val
        self.omit = omit

    def to_string(self):
        p = toi(self.val)
        if p == 0:
            return 'null'
        try:
            e = self.val.dereference()
        except:
            pe = "???"
        else:
            pe = e
        if self.omit:
            return pe
        return "0x{:x} \u279e {}".format(p, pe)

class richiestaPrinter:
    """Print a richiesta list"""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        return "{{{}, {}}}".format(toi(self.val['d_attesa']), show_list(self.val['pp'], 'puntatore', nmax=1, vis=proc_elem))

def richiestaLookup(val):
    if val.type == richiesta_type:
        return richiestaPrinter(val)
    elif val.type == richiesta_ptr_type:
        return ptrPrinter(val)
    return None

gdb.pretty_printers.append(richiestaLookup)

class des_semPrinter:
    """Print a des_sem"""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        return "{{ {}, {} }}".format(self.val['counter'], show_list(self.val['pointer'], 'puntatore', vis=proc_elem))

def des_semLookup(val):
    if val.type == des_sem_type:
        return des_semPrinter(val)
    elif val.type == des_sem_p:
        return ptrPrinter(val)
    return None

gdb.pretty_printers.append(des_semLookup)


class tab_entryPrinter:
    """print a tab_entry"""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        return vm_tab_entry_to_str(self.val)

def tab_entryLookup(val):
    if str(val.type.unqualified()) == 'tab_entry':
        return tab_entryPrinter(val)
    return None

gdb.pretty_printers.append(tab_entryLookup)

class vaddrPrinter:
    """print a vaddr"""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        return vm_vaddr_to_str(self.val)

def vaddrLookup(val):
    if str(val.type.unqualified()) == 'vaddr':
        return vaddrPrinter(toi(val))
    return None

gdb.pretty_printers.append(vaddrLookup)

class paddrPrinter:
    """print a paddr"""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        return vm_paddr_to_str(self.val)

def paddrLookup(val):
    if str(val.type.unqualified()) == 'paddr':
        return paddrPrinter(toi(val))
    return None

gdb.pretty_printers.append(paddrLookup)

class natPrinter:
    """print an natl/q"""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        return str(self.val) + " " + hex(self.val)

def natlLookup(val):
    t = str(val.type.unqualified())
    if t == 'natl' or t == 'natq':
        return natPrinter(toi(val))
    return None

gdb.pretty_printers.append(natlLookup)

class ioaddrPrinter:
    """print an ioaddr"""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        return "0x{:04x}".format(toi(self.val))

def ioaddrLookup(val):
    t = str(val.type.unqualified())
    if t == 'ioaddr':
        return ioaddrPrinter(toi(val))
    return None

gdb.pretty_printers.append(ioaddrLookup)

class des_procPrinter:
    """print a des_proc *"""

    def __init__(self, val):
        self.val = val

    def to_string(self):
        if self.val == gdb.Value(0):
            return 'null'
        try:
            proc = self.val.dereference()
        except:
            return '{:x} invalid'.format(toi(self.val))
        s = 'rax: {}'.format(proc['contesto'][0])
        for f in toshow:
            s += ', {}: {}'.format(f.name, proc[f])
        return '{:x} \u279e {{ {} }}'.format(toi(self.val), s)

def des_procLookup(val):
    if val.type == des_proc_ptr_type:
        return des_procPrinter(val)
    return None

gdb.pretty_printers.append(des_procLookup)

def context_event(event):
    print_context()

gdb.events.stop.connect(context_event)
