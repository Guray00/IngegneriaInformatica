#!/usr/bin/awk -f

BEGIN {
	fg_black   = "\033[30m"
	fg_red     = "\033[31m"
	fg_green   = "\033[32m"
	fg_yellow  = "\033[33m"
	fg_blue    = "\033[34m"
	fg_magenta = "\033[35m"
	fg_cyan    = "\033[36m"
	fg_white   = "\033[37m"

	bg_black   = "\033[40m"
	bg_red     = "\033[41m"
	bg_green   = "\033[42m"
	bg_yellow  = "\033[43m"
	bg_blue    = "\033[44m"
	bg_magenta = "\033[45m"
	bg_cyan    = "\033[46m"
	bg_white   = "\033[47m"

	reset      = "\033[0m"
}

$1=="INF" { print fg_white $0 reset }
$1=="WRN" { print fg_red   $0 reset }
$1=="DBG" { print fg_blue  $0 reset }
$1=="ERR" { print bg_red fg_white $0 reset }
$1=="USR" { print fg_green $0 reset }
