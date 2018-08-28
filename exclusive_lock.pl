#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: exclusive_lock.pl
#
#        USAGE: ./exclusive_lock.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Heince Kurniawan
#       EMAIL : heince.kurniawan@itgroupinc.asia
# ORGANIZATION: IT Group Indonesia
#      VERSION: 1.0
#      CREATED: 08/28/18 14:48:05
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Carp;
use v5.10.1;
use Fcntl qw /:DEFAULT :flock/;

my $file        = 'file1';
my $no_of_write = 10;

open ( my $fh, ">>", $file ) or die "$!\n";

unless ( flock( $fh, LOCK_EX | LOCK_NB ) ) 
{
    print "waiting for lock ...\n";
    flock ( $fh, LOCK_EX) || die "can't lock - $!\n";
    print "got it\n";
    write_something();
}
else
{
    flock( $fh, LOCK_EX | LOCK_NB ) or die "$!\n";
    write_something();
}

sub write_something
{
    for (1 .. $no_of_write)
    {
        my $output = scalar localtime . " - " . $ENV{HOSTNAME} . "\n";
        print $fh $output;
        sleep 1;
    }
}
