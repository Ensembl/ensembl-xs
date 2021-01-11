#!perl 
# Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
# Copyright [2016-2021] EMBL-European Bioinformatics Institute
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

################################################################
#                                                              #
# Benchmark                                                    #
#                                                              #
# Bio::EnsEMBL::XS::Variation::Utils::VariationEffect::overlap #
#  vs                                                          #
# Bio::EnsEMBL::Variation::Utils::VariationEffect::overlap     #
#                                                              #
################################################################

use Benchmark;

use Bio::EnsEMBL::Variation::Utils::VariationEffect;
use Bio::EnsEMBL::XS;

$| = 1;

print '-' x 30, "\n Call overlap 1M times\n", '-' x 30, "\n\n";

print "[Bio::EnsEMBL::Variation::Utils::VariationEffect] ";
my $i = 1;
my $start = new Benchmark;
for (1 .. 1000000) {
  Bio::EnsEMBL::Variation::Utils::VariationEffect::overlap(1, 5, 3, 7);
  print '.' unless $i++ % 10000;
}
my $end = new Benchmark;
my $diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

print "[Bio::EnsEMBL::XS::Variation::Utils::VariationEffect] ";
$i = 1;
$start = new Benchmark;
for (1 .. 1000000) {
  Bio::EnsEMBL::XS::Variation::Utils::VariationEffect::overlap(1, 5, 3, 7);
  print '.' unless $i++ % 10000; 
}
$end = new Benchmark;
$diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');




print '-' x 30, "\n Call random overlap 1M times\n", '-' x 30, "\n\n";

print "[Bio::EnsEMBL::Variation::Utils::VariationEffect] ";
$i = 1;
$start = new Benchmark;
for (1 .. 1000000) {
  Bio::EnsEMBL::Variation::Utils::VariationEffect::overlap(map {int(rand(10))} (1..4));
  print '.' unless $i++ % 10000;
}
$end = new Benchmark;
$diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');

print "[Bio::EnsEMBL::XS::Variation::Utils::VariationEffect] ";
$i = 1;
$start = new Benchmark;
for (1 .. 1000000) {
  Bio::EnsEMBL::XS::Variation::Utils::VariationEffect::overlap(map {int(rand(10))} (1..4));
  print '.' unless $i++ % 10000; 
}
$end = new Benchmark;
$diff = timediff($end, $start);
printf "\nTime taken was %s seconds\n\n", timestr($diff, 'all');
