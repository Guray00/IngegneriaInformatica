set print static off
set print pretty on
set print array on
target remote localhost:1234
file build/sistema
add-symbol-file build/io      0x40400000
add-symbol-file build/utente  0x80000000
