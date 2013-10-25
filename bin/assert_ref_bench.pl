#!perl 
use strict;
use warnings;

#################################################
#                                               #
# Benchmark                                     #
#                                               #
# Bio::EnsEMBL::XS::Utils::Scalar::assert_ref   #
#  vs                                           #
# Bio::EnsEMBL::Utils::Scalar::assert_ref       #
#                                               #
#################################################

use Benchmark;

use Bio::EnsEMBL::Utils::Scalar;
use Bio::EnsEMBL::XS;

$| = 1;

#
# Benchmark with lots of small iterations 
#
# use array_ref
#
print '-' x 30, "\n Call 1K times with array_ref\n", '-' x 30, "\n\n";

print "[Bio::EnsEMBL::Utils::Scalar] ";
my $i = 1;
my $start = new Benchmark;
for (1 .. 1000) {
  Bio::EnsEMBL::Utils::Scalar::assert_ref_pp([1,2,3], 'ARRAY');
  eval { Bio::EnsEMBL::Utils::Scalar::assert_ref_pp({}, 'ARRAY'); };
  print '.' unless $i++ % 100;
}
my $end = new Benchmark;
my $diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

print "[Bio::EnsEMBL::XS::Utils::Scalar] ";
$i = 1;
$start = new Benchmark;
for (1 .. 1000) {
  Bio::EnsEMBL::XS::Utils::Scalar::assert_ref([1,2,3], 'ARRAY');
  eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref({}, 'ARRAY'); };
  print '.' unless $i++ % 100; 
}
$end = new Benchmark;
$diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

print '-' x 32, "\n Call 100K times with array_ref\n", '-' x 32, "\n\n";

print "[Bio::EnsEMBL::Utils::Scalar] ";
$i = 1;
$start = new Benchmark;
for (1 .. 100000) {
  Bio::EnsEMBL::Utils::Scalar::assert_ref_pp([1,2,3], 'ARRAY');
  eval { Bio::EnsEMBL::Utils::Scalar::assert_ref_pp({}, 'ARRAY'); };
  print '.' unless $i++ % 10000;
}
$end = new Benchmark;
$diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

print "[Bio::EnsEMBL::XS::Utils::Scalar] ";
$i = 1;
$start = new Benchmark;
for (1 .. 100000) {
  Bio::EnsEMBL::XS::Utils::Scalar::assert_ref([1,2,3], 'ARRAY');
  eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref({}, 'ARRAY'); };
  print '.' unless $i++ % 10000; 
}
$end = new Benchmark;
$diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

#
# use object
#
if (eval { require Bio::EnsEMBL::Slice; require Bio::EnsEMBL::CoordSystem; 1 }) {
  my $coord_system = 
    Bio::EnsEMBL::CoordSystem->new(-NAME    => 'chromosome',
				   -VERSION => 'NCBI33',
				   -DBID    => 1,
				   -TOP_LEVEL => 0,
				   -RANK    => 1,
				   -SEQUENCE_LEVEL => 0,
				   -DEFAULT => 1);
  my $slice = 
    Bio::EnsEMBL::Slice->new(-seq_region_name => 'test',
			     -start           => 1,
			     -end             => 3,
			     -coord_system    => $coord_system);

  print '-' x 27, "\n Call 1K times with object\n", '-' x 27, "\n\n";

  print "[Bio::EnsEMBL::Utils::Scalar] ";
  my $i = 1;
  my $start = new Benchmark;
  for (1 .. 1000) {
    Bio::EnsEMBL::Utils::Scalar::assert_ref_pp($slice, 'Bio::EnsEMBL::Slice');
    eval { Bio::EnsEMBL::Utils::Scalar::assert_ref_pp($slice, 'Bio::EnsEMBL::Registry'); };
    print '.' unless $i++ % 100;
  }
  my $end = new Benchmark;
  my $diff = timediff($end, $start);
  printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

  print "[Bio::EnsEMBL::XS::Utils::Scalar] ";
  $i = 1;
  $start = new Benchmark;
  for (1 .. 1000) {
    Bio::EnsEMBL::XS::Utils::Scalar::assert_ref($slice, 'Bio::EnsEMBL::Slice');
    eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref($slice, 'Bio::EnsEMBL::Registry'); };
    print '.' unless $i++ % 100; 
  }
  $end = new Benchmark;
  $diff = timediff($end, $start);
  printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

  print '-' x 29, "\n Call 100K times with object\n", '-' x 29, "\n\n";

  print "[Bio::EnsEMBL::Utils::Scalar] ";
  $i = 1;
  $start = new Benchmark;
  for (1 .. 100000) {
    Bio::EnsEMBL::Utils::Scalar::assert_ref_pp($slice, 'Bio::EnsEMBL::Slice');
    eval { Bio::EnsEMBL::Utils::Scalar::assert_ref_pp($slice, 'Bio::EnsEMBL::Registry'); };
    print '.' unless $i++ % 10000;
  }
  $end = new Benchmark;
  $diff = timediff($end, $start);
  printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

  print "[Bio::EnsEMBL::XS::Utils::Scalar] ";
  $i = 1;
  $start = new Benchmark;
  for (1 .. 100000) {
    Bio::EnsEMBL::XS::Utils::Scalar::assert_ref($slice, 'Bio::EnsEMBL::Slice');
    eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref($slice, 'Bio::EnsEMBL::Registry'); };
    print '.' unless $i++ % 10000; 
  }
  $end = new Benchmark;
  $diff = timediff($end, $start);
  printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

}
