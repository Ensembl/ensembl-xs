#!perl -T
# Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
# Copyright [2016-2017] EMBL-European Bioinformatics Institute
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
use 5.8.9;
use strict;
use warnings FATAL => 'all';

use Test::More;

use Data::Dumper;

# BEGIN {
#   use FindBin qw/$Bin/;
#   use lib "$Bin/../../blib";  
# }

BEGIN { use_ok('Bio::EnsEMBL::XS'); }

my $tree = Bio::EnsEMBL::XS::Utils::Tree::Interval->new();
isa_ok($tree, 'Bio::EnsEMBL::XS::Utils::Tree::Interval');

note Dumper $tree;

diag( "Testing Interval Tree in Bio::EnsEMBL::XS::Utils::Tree::Interval $Bio::EnsEMBL::XS::VERSION, Perl $], $^X" );

done_testing();