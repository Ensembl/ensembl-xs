#!perl 
#
# Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
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

use 5.8.9;
use strict;
use warnings FATAL => 'all';

use Test::More;
use File::Temp qw/ tempfile /;

BEGIN { use_ok('Bio::EnsEMBL::XS'); }

#
# Test exceptions, e.g. missing or wrong typed arguments
#
my $test_name = 'not enough arguments';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref([]); };
if ($@) { ok($@ =~ 'Usage', $test_name); } else { ok(0, $test_name); }

ok(Bio::EnsEMBL::XS::Utils::Scalar::assert_ref(undef, undef), "assertions not set");

$Bio::EnsEMBL::Utils::Scalar::ASSERTIONS = 1;
$test_name = 'undefined reference';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref(undef, 'ARRAY') };
if ($@) { ok($@ =~ 'The given reference', $test_name); } else { ok(0, $test_name); }

$test_name = 'undefined expected type';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref([], undef) };
if ($@) { ok($@ =~ 'No expected', $test_name); } else { ok(0, $test_name); }

$test_name = 'expected type must be string';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref([], 2) };
if ($@) { ok($@ =~ 'string', $test_name); } else { ok(0, $test_name); }

$test_name = 'reference type';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref(1, 'ARRAY') };
if ($@) { ok($@ =~ 'Asking for the type', $test_name); } else { ok(0, $test_name); }


#
# Test normal mode of operation
#
my $a = 10;
ok(Bio::EnsEMBL::XS::Utils::Scalar::assert_ref(\$a, 'SCALAR'), 'scalar');
$test_name = 'not scalar';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref({a=>1,b=>2}, 'SCALAR') };
if ($@) { ok($@ =~ 'was expected to be', $test_name); } else { ok(0, $test_name); }

ok(Bio::EnsEMBL::XS::Utils::Scalar::assert_ref([1,2,3], 'ARRAY'), 'array');
$test_name = 'not array';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref({a=>1,b=>2}, 'ARRAY') };
if ($@) { ok($@ =~ 'was expected to be', $test_name); } else { ok(0, $test_name); }

ok(Bio::EnsEMBL::XS::Utils::Scalar::assert_ref({a=>1,b=>2}, 'HASH'), 'hash');
$test_name = 'not hash';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref([1,2,3], 'HASH') };
if ($@) { ok($@ =~ 'was expected to be', $test_name); } else { ok(0, $test_name); }

ok(Bio::EnsEMBL::XS::Utils::Scalar::assert_ref(sub { my $a = shift}, 'CODE'), 'code');
$test_name = 'not code';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref([1,2,3], 'CODE') };
if ($@) { ok($@ =~ 'was expected to be', $test_name); } else { ok(0, $test_name); }

# TODO
# test I/O objects and FORMAT types

# Test with EnsEMBL blessed objects
SKIP: {
  skip 'Cannot continue testing: Bio::EnsEMBL::[Slice|CoordSystem] module not found', 1
    unless eval { require Bio::EnsEMBL::Slice; require Bio::EnsEMBL::CoordSystem; 1 };

  my $test_coord_system = Bio::EnsEMBL::CoordSystem->new(-NAME    => 'chromosome',
							 -VERSION => 'NCBI33',
							 -DBID    => 1,
							 -TOP_LEVEL => 0,
							 -RANK    => 1,
							 -SEQUENCE_LEVEL => 0,
							 -DEFAULT => 1);
  my $test_slice = Bio::EnsEMBL::Slice->new(-seq_region_name => 'test',
					    -start           => 1,
					    -end             => 3,
					    -coord_system    => $test_coord_system);
  ok(Bio::EnsEMBL::XS::Utils::Scalar::assert_ref($test_slice, 'Bio::EnsEMBL::Slice'), 'Bio::EnsEMBL::Slice');
  $test_name = 'not Bio::EnsEMBL::CoordSystem';
  eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref($test_slice, 'Bio::EnsEMBL::CoordSystem') };
  if ($@) { ok($@ =~ 'is not an ISA', $test_name); } else { ok(0, $test_name); }
  
  ok(Bio::EnsEMBL::XS::Utils::Scalar::assert_ref($test_coord_system, 'Bio::EnsEMBL::CoordSystem'), 'Bio::EnsEMBL::CoordSystem');
  $test_name = 'not Bio::EnsEMBL::Slice';
  eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref($test_coord_system, 'Bio::EnsEMBL::Slice') };
  if ($@) { ok($@ =~ 'is not an ISA', $test_name); } else { ok(0, $test_name); }  
}

# Test with EnsEMBL proxy objects
SKIP: {
  skip 'Cannot continue testing: Bio::EnsEMBL::[DBConnection|ProxyDBConnection] module not found', 1
    unless eval { require Bio::EnsEMBL::DBSQL::DBConnection; require Bio::EnsEMBL::DBSQL::ProxyDBConnection; 1 };

  my $dbc = Bio::EnsEMBL::DBSQL::DBConnection->new(-HOST => 'host', -PORT => 3306, -USER => 'user');
  my $proxy = Bio::EnsEMBL::DBSQL::ProxyDBConnection->new(-DBC => $dbc, -DBNAME => 'human');

  ok(Bio::EnsEMBL::XS::Utils::Scalar::assert_ref($proxy, 
						'Bio::EnsEMBL::DBSQL::DBConnection'), 'Bio::EnsEMBL::DBSQL::DBConnection');
  $test_name = 'not Bio::EnsEMBL::Gene';
  eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref($proxy, 'Bio::EnsEMBL::Gene') };
  if ($@) { ok($@ =~ 'is not an ISA', $test_name); } else { ok(0, $test_name); }  
}

#
# bug reported by Will McLaren (19/02/2015)
#
# assert_ref throws a warning when you only give it two args:
# assert_ref($obj, $class, $name);
# where $name is undef gives:
# e.g. 
# Use of uninitialized value in subroutine entry at /nfs/users/nfs_w/wm2/Perl/ensembl-funcgen/modules/Bio/EnsEMBL/Funcgen/DBSQL/DBAdaptor.pm line 270.
#
$test_name = 'undefined reference (attribute name == undef)';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref(undef, 'ARRAY', undef) };
if ($@) { ok($@ =~ /The given reference.+?Unknown/, $test_name); } else { ok(0, $test_name); }
$test_name = 'undefined reference (attribute name assigned)';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref(undef, 'ARRAY', "dummy") };
if ($@) { ok($@ =~ /dummy/, $test_name); } else { ok(0, $test_name); }


diag( "Testing assert_ref in Bio::EnsEMBL::XS::Utils::Scalar $Bio::EnsEMBL::XS::VERSION, Perl $], $^X" );

done_testing();
