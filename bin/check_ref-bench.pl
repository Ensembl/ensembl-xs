#!perl 
# Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
# Copyright [2016-2019] EMBL-European Bioinformatics Institute
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
use strict;
use warnings;

################################################
#                                              #
# Benchmark                                    #
#                                              #
# Bio::EnsEMBL::XS::Utils::Scalar::check_ref   #
#  vs                                          #
# Bio::EnsEMBL::Utils::Scalar::check_ref       #
#                                              #
################################################

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
  Bio::EnsEMBL::Utils::Scalar::check_ref_pp([1,2,3], 'ARRAY');
  Bio::EnsEMBL::Utils::Scalar::check_ref_pp(1, 'ARRAY');
  print '.' unless $i++ % 100;
}
my $end = new Benchmark;
my $diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

print "[Bio::EnsEMBL::XS::Utils::Scalar] ";
$i = 1;
$start = new Benchmark;
for (1 .. 1000) {
  Bio::EnsEMBL::XS::Utils::Scalar::check_ref([1,2,3], 'ARRAY');
  Bio::EnsEMBL::XS::Utils::Scalar::check_ref(1, 'ARRAY');
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
  Bio::EnsEMBL::Utils::Scalar::check_ref_pp([1,2,3], 'ARRAY');
  Bio::EnsEMBL::Utils::Scalar::check_ref_pp(1, 'ARRAY');
  print '.' unless $i++ % 10000;
}
$end = new Benchmark;
$diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

print "[Bio::EnsEMBL::XS::Utils::Scalar] ";
$i = 1;
$start = new Benchmark;
for (1 .. 100000) {
  Bio::EnsEMBL::XS::Utils::Scalar::check_ref([1,2,3], 'ARRAY');
  Bio::EnsEMBL::XS::Utils::Scalar::check_ref(1, 'ARRAY');
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
    Bio::EnsEMBL::Utils::Scalar::check_ref_pp($slice, 'Bio::EnsEMBL::Slice');
    Bio::EnsEMBL::Utils::Scalar::check_ref_pp($slice, 'Bio::EnsEMBL::Registry');
    print '.' unless $i++ % 100;
  }
  my $end = new Benchmark;
  my $diff = timediff($end, $start);
  printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

  print "[Bio::EnsEMBL::XS::Utils::Scalar] ";
  $i = 1;
  $start = new Benchmark;
  for (1 .. 1000) {
    Bio::EnsEMBL::XS::Utils::Scalar::check_ref($slice, 'Bio::EnsEMBL::Slice');
    Bio::EnsEMBL::XS::Utils::Scalar::check_ref($slice, 'Bio::EnsEMBL::Registry');
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
    Bio::EnsEMBL::Utils::Scalar::check_ref_pp($slice, 'Bio::EnsEMBL::Slice');
    Bio::EnsEMBL::Utils::Scalar::check_ref_pp($slice, 'Bio::EnsEMBL::Registry');
    print '.' unless $i++ % 10000;
  }
  $end = new Benchmark;
  $diff = timediff($end, $start);
  printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

  print "[Bio::EnsEMBL::XS::Utils::Scalar] ";
  $i = 1;
  $start = new Benchmark;
  for (1 .. 100000) {
    Bio::EnsEMBL::XS::Utils::Scalar::check_ref($slice, 'Bio::EnsEMBL::Slice');
    Bio::EnsEMBL::XS::Utils::Scalar::check_ref($slice, 'Bio::EnsEMBL::Registry');
    print '.' unless $i++ % 10000; 
  }
  $end = new Benchmark;
  $diff = timediff($end, $start);
  printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

}
