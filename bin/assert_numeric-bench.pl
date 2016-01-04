#!perl 
#
# Copyright [1999-2016] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
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

print '-' x 30, "\n Call assert_numeric 1K times\n", '-' x 30, "\n\n";

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

print '-' x 30, "\n Call assert_integer 1K times\n", '-' x 30, "\n\n";

print "[Bio::EnsEMBL::Utils::Scalar] ";
$i = 1;
$start = new Benchmark;
for (1 .. 1000) {
  Bio::EnsEMBL::Utils::Scalar::assert_integer_pp(123);
  print '.' unless $i++ % 100;
}
$end = new Benchmark;
$diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

print "[Bio::EnsEMBL::XS::Utils::Scalar] ";
$i = 1;
$start = new Benchmark;
for (1 .. 1000) {
  Bio::EnsEMBL::XS::Utils::Scalar::assert_integer(123);
  print '.' unless $i++ % 100; 
}
$end = new Benchmark;
$diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

print '-' x 32, "\n Call assert_numeric 100K times\n", '-' x 32, "\n\n";

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

print '-' x 32, "\n Call assert_integer 100K times\n", '-' x 32, "\n\n";

print "[Bio::EnsEMBL::Utils::Scalar] ";
$i = 1;
$start = new Benchmark;
for (1 .. 100000) {
  Bio::EnsEMBL::Utils::Scalar::assert_integer_pp(123);
  print '.' unless $i++ % 10000;
}
$end = new Benchmark;
$diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

print "[Bio::EnsEMBL::XS::Utils::Scalar] ";
$i = 1;
$start = new Benchmark;
for (1 .. 100000) {
  Bio::EnsEMBL::XS::Utils::Scalar::assert_integer(123);
  print '.' unless $i++ % 10000; 
}
$end = new Benchmark;
$diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

