#!/usr/bin/perl -w
use strict;
use Time::HiRes qw(sleep);
use IO::Select;
sub catch_zap {
    my $signame = shift;
    print "I saw the INT first\n";
}
$SIG{INT} = \&catch_zap;

my $sel = IO::Select->new();
$sel->add(\*STDIN);
while (1) {
    $|=1;
    print "waiting\n";
    for my $handle  ($sel->can_read(0)) {
	    chomp(my $line = <$handle> );
	    defined($line) and $line =~ m/^(exit|quit)$/ 
		and print "Ending the monitor proxy! " and exit;

    }
    sleep(1);
}
