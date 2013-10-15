#!perl 
use strict;
use warnings;

################################################
#                                              #
# Benchmark                                    #
#                                              #
# Bio::EnsEMBL::XS::Utils::Argument::rearrange #
#  vs                                          #
# Bio::EnsEMBL::Utils::Argument::rearrange     #
#                                              #
################################################

use List::Util qw(shuffle);
use Benchmark;

use Bio::EnsEMBL::Utils::Argument;
use Bio::EnsEMBL::XS;

$| = 1;

#
# Benchmark using large artificial argument list
#
print '-' x 18, "\n 1M argument list\n", '-' x 18, "\n\n";
my @args = ("0000001" .. "1000000");

my @random_args;
for my $i (shuffle @args) {
  push @random_args, "-$i", $i;
}

print "[Bio::EnsEMBL::Utils::Argument]\t\t";
my $start = new Benchmark;
my @args1 = Bio::EnsEMBL::Utils::Argument::rearrange_pp([@args], @random_args);
my $end = new Benchmark;
my $diff = timediff($end, $start);
printf "time taken was %s seconds\n", timestr($diff, 'all');

print "[Bio::EnsEMBL::XS::Utils::Argument]\t";
$start = new Benchmark;
my @args2 = Bio::EnsEMBL::XS::Utils::Argument::rearrange([@args], @random_args);
$end = new Benchmark;
$diff = timediff($end, $start);
printf "time taken was %s seconds\n\n", timestr($diff, 'all');

#
# Benchmark calling 10K times
#
print '-' x 16, "\n Call 10K times\n", '-' x 16, "\n\n";
my $keys = [qw/one two three four five six seven eight nine ten/];

print "[Bio::EnsEMBL::Utils::Argument] ";
my $i = 1;
$start = new Benchmark;
for (1 .. 10000) {
  my @two_output = Bio::EnsEMBL::Utils::Argument::rearrange_pp($keys, (-SIX => 6, -THrEE => 3));
  my @six_output = Bio::EnsEMBL::Utils::Argument::rearrange_pp($keys, (-SIX => 6, -THREE => 3, -ten => 10, -four => 4, -ONE => 1, -TWO => 2));
  print '.' unless $i++ % 1000;
}
$end = new Benchmark;
$diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

print "[Bio::EnsEMBL::XS::Utils::Argument] ";
$i = 1;
$start = new Benchmark;
for (1 .. 10000) {
  my @two_output = Bio::EnsEMBL::XS::Utils::Argument::rearrange($keys, (-SIX => 6, -THrEE => 3));
  my @six_output = Bio::EnsEMBL::XS::Utils::Argument::rearrange($keys, (-SIX => 6, -THREE => 3, -ten => 10, -four => 4, -ONE => 1, -TWO => 2));
  print '.' unless $i++ % 1000; 
}
$end = new Benchmark;
$diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');
