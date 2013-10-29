#!perl 
use strict;
use warnings;

###########################################################
#                                                         #
# Benchmark                                               #
#                                                         #
# Bio::EnsEMBL::XS::Utils::Scalar::assert_numeric|integer #
#  vs                                                     #
# Bio::EnsEMBL::Utils::Scalar::assert_numeric|integer     #
#                                                         #
###########################################################

use Benchmark;

use Bio::EnsEMBL::Utils::Scalar;
use Bio::EnsEMBL::XS;

$| = 1;

#
# Benchmark with lots of small iterations 
#
# use array_ref
#
print '-' x 15, "\n Call 1K times\n", '-' x 15, "\n\n";

print "[Bio::EnsEMBL::Utils::Scalar] ";
my $i = 1;
my $start = new Benchmark;
for (1 .. 1000) {
  Bio::EnsEMBL::Utils::Scalar::assert_numeric_pp(1e-11);
  print '.' unless $i++ % 100;
}
my $end = new Benchmark;
my $diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

print "[Bio::EnsEMBL::XS::Utils::Scalar] ";
$i = 1;
$start = new Benchmark;
for (1 .. 1000) {
  Bio::EnsEMBL::XS::Utils::Scalar::assert_numeric(1e-11);
  print '.' unless $i++ % 100; 
}
$end = new Benchmark;
$diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

print '-' x 17, "\n Call 100K times\n", '-' x 17, "\n\n";

print "[Bio::EnsEMBL::Utils::Scalar] ";
$i = 1;
$start = new Benchmark;
for (1 .. 100000) {
  Bio::EnsEMBL::Utils::Scalar::assert_numeric_pp(1e-11);
  print '.' unless $i++ % 10000;
}
$end = new Benchmark;
$diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

print "[Bio::EnsEMBL::XS::Utils::Scalar] ";
$i = 1;
$start = new Benchmark;
for (1 .. 100000) {
  Bio::EnsEMBL::XS::Utils::Scalar::assert_numeric(1e-11);
  print '.' unless $i++ % 10000; 
}
$end = new Benchmark;
$diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

