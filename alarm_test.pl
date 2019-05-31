#!/usr/bin/perl
use 5.016;
print "Answer me within one minute, or die: "; 
alarm(5); 
# kill program in one minute 
my $answer = <STDIN>; 
my $timeleft = alarm(0); # clear alarm 
say "You had $timeleft seconds remaining";
