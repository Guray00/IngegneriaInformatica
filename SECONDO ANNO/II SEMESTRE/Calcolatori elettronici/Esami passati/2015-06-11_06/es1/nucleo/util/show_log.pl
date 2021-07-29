#!/usr/bin/perl -n

BEGIN {
	do './util/start.pl';

	my $hex = qr/[a-fA-F0-9]/;

	sub toLine($) {
		my $h = shift;

		if    ($h ge $START_UTENTE)      { $exe = 'build/utente';  }
		elsif ($h ge $START_IO)          { $exe = 'build/io';      }
		else 				 { $exe = "build/sistema"; }

		my $out = `addr2line -Cfe $exe $h`;
		if ($?) {
			return $h;
		}
		chomp $out;
		my @lines = split(/\n/, $out);
		if ($lines[1] =~ /^\?\?/) {
			return $h;
		}
		my $s = '';
		$lines[1] =~ s#^.*/##;
		if ($lines[0] ne '??') {
			$s .= $lines[0];
		}
		$s .= ' [' . $lines[1] . ']';
		return $s;
	}

	sub decodeAddr($) {
		my $s = shift;
		$s =~ s#(?<!$hex)($hex{8}|$hex{16})(?!$hex)#&toLine($1)#meg;
		return $s;
	}
}

chomp;
my ($level, $id, $msg) = split /\t/;
if ($level ne "USR") { 
	$msg = &decodeAddr($msg);
}
print "$level\t$id\t$msg\n";
