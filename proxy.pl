#!/usr/bin/perl -w
use Device::SerialPort;
use Time::HiRes qw(sleep);
use IO::Select;
use POSIX();
use Cwd qw(getcwd);
use 5.010;


$SIG{INT} = \&catch_zap;

my $sel = IO::Select->new();
$sel->add(\*STDIN);


my $port = Device::SerialPort->new("/dev/ttyACM0")
    || die "Cannot open port\n";

$port->databits(8);
$port->baudrate(9600);
$port->parity_enable(F);
$port->stopbits(1);
$port->read_const_time(1000);
$port->read_char_time(0);

my $childpid;
my $datestring = "not once";
my $wkdir = getcwd();

sub fork_and_exec {
    if ($childpid){
	kill 9,  $childpid;
	say "Killing $childpid";
	my $gone_pid = waitpid $childpid, 0;
	say "Killed: $gone_pid";

	$childpid = undef;
    }
    $childpid = fork();
    die "Could not fork\n" if not defined $childpid;
    if(not $childpid) {
	say "In child\n";
	chdir "$wkdir";
	exec("/home/dzhang/bin/nunaliit", "run");
	exit 0;
    }
    

}

sub catch_zap{

    my $signame = shift;
    print "I saw the INT \n";
    if (defined($childpid)){
	kill $signame, $childpid;
	my $gone_pid = waitpid $childpid, 0;
	say "killed $gone_pid";
    }
}


while(1) {
    ($count_in, $string_in) = $port->read(1);
    if( $count_in == 1 && $string_in eq "n" ){
	$| = 1;
	print "\nRec: $string_in ->>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
	my $status = system("/home/dzhang/bin/nunaliit", "update");
	if (($status >>= 8) != 0) {
	    $| = 1;
	    print "Update failed.\n";
	} else {
	    $datestring = localtime();
	    $| = 1;
	    print "Update Succeed.-- $datestring\n";
	}
       
	fork_and_exec();
    }
    $| = 1;
    print "Listening, last update ($datestring) - (type quit the proxy).\r";
    for my $handle  ($sel->can_read(0)) {
	chomp(my $line = <$handle> );
	if(  defined($line) and $line =~ m/^(exit|quit)$/ ){
	    if ($childpid){
		kill 9,  $childpid;
		say "Killing $childpid";
		my $gone_pid = waitpid $childpid, 0;
		say "Killed: $gone_pid";

		$childpid = undef;
    }
	    print "\nEnding the monitor proxy!\n" and exit;
	}

    }

    
   # sleep(0.3);
}
