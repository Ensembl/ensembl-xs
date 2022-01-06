# Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
# Copyright [2016-2022] EMBL-European Bioinformatics Institute
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
use File::Temp qw/ tempfile /;
use FindBin '$Bin';

use lib "$Bin/../lib", "$Bin/../blib/lib", "$Bin/../blib/arch";
use_ok('Bio::EnsEMBL::XS');


#
# Test exceptions, e.g. missing or wrong typed arguments
#
my $test_name = 'not enough arguments';
eval { Bio::EnsEMBL::XS::Utils::Scalar::check_ref([]); };
if ($@) { ok($@ =~ 'Usage', $test_name); } else { ok(0, $test_name); }

$test_name = 'undefined expected type';
eval { Bio::EnsEMBL::XS::Utils::Scalar::check_ref([], undef) };
if ($@) { ok($@ =~ 'Undefined', $test_name); } else { ok(0, $test_name); }

$test_name = 'expected type must be string';
eval { Bio::EnsEMBL::XS::Utils::Scalar::check_ref([], 2) };
if ($@) { ok($@ =~ 'string', $test_name); } else { ok(0, $test_name); }

#
# Test normal mode of operation
#
my $a = 10;
my $b = \$a;
ok(Bio::EnsEMBL::XS::Utils::Scalar::check_ref($b, 'SCALAR'), 'scalar');
is(Bio::EnsEMBL::XS::Utils::Scalar::check_ref({a=>1,b=>2}, 'SCALAR'), 0, 'not scalar');

ok(Bio::EnsEMBL::XS::Utils::Scalar::check_ref([1,2,3], 'ARRAY'), 'array');
is(Bio::EnsEMBL::XS::Utils::Scalar::check_ref({a=>1,b=>2}, 'ARRAY'), 0, 'not array');
is(Bio::EnsEMBL::XS::Utils::Scalar::check_ref(1, 'ARRAY'), 0, 'not array');

ok(Bio::EnsEMBL::XS::Utils::Scalar::check_ref({a=>1,b=>2}, 'HASH'), 'hash');
is(Bio::EnsEMBL::XS::Utils::Scalar::check_ref([1,2,3], 'HASH'), 0, 'not hash');

ok(Bio::EnsEMBL::XS::Utils::Scalar::check_ref(sub { my $a = shift; }, 'CODE'), 'code');
is(Bio::EnsEMBL::XS::Utils::Scalar::check_ref([1,2,3], 'CODE'), 0, 'not code');

my $fh = tempfile(); #open my $fh, "<03-check_ref.t" or die "Cannot open file for reading: $!\n";
ok(Bio::EnsEMBL::XS::Utils::Scalar::check_ref($fh, 'GLOB'), 'glob');
is(Bio::EnsEMBL::XS::Utils::Scalar::check_ref([1,2,3], 'GLOB'), 0, 'not glob');

my $re = qr/^hello, world/;
ok(Bio::EnsEMBL::XS::Utils::Scalar::check_ref($re, 'Regexp'), 'regexp');
is(Bio::EnsEMBL::XS::Utils::Scalar::check_ref([1,2,3], 'Regexp'), 0, 'not regexp');

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
  ok(Bio::EnsEMBL::XS::Utils::Scalar::check_ref($test_slice, 'Bio::EnsEMBL::Slice'), 'Bio::EnsEMBL::Slice');
  is(Bio::EnsEMBL::XS::Utils::Scalar::check_ref($test_slice, 'Bio::EnsEMBL::CoordSystem'), 0, 'slice is not coord sytem');
  ok(Bio::EnsEMBL::XS::Utils::Scalar::check_ref($test_coord_system, 'Bio::EnsEMBL::CoordSystem'), 'Bio::EnsEMBL::CoordSystem');
  is(Bio::EnsEMBL::XS::Utils::Scalar::check_ref($test_coord_system, 'Bio::EnsEMBL::Slice'), 0, 'coord system is not slice');  
}

# Test with EnsEMBL proxy objects
SKIP: {
  skip 'Cannot continue testing: Bio::EnsEMBL::[DBConnection|ProxyDBConnection] module not found', 1
    unless eval { require Bio::EnsEMBL::DBSQL::DBConnection; require Bio::EnsEMBL::DBSQL::ProxyDBConnection; 1 };

  my $dbc = Bio::EnsEMBL::DBSQL::DBConnection->new(-HOST => 'host', -PORT => 3306, -USER => 'user');
  my $proxy = Bio::EnsEMBL::DBSQL::ProxyDBConnection->new(-DBC => $dbc, -DBNAME => 'human');

  ok(Bio::EnsEMBL::XS::Utils::Scalar::check_ref($proxy, 
						'Bio::EnsEMBL::DBSQL::DBConnection'), 'Bio::EnsEMBL::DBSQL::DBConnection');
  is(Bio::EnsEMBL::XS::Utils::Scalar::check_ref($proxy, 'Bio::EnsEMBL::Gene'), 0, 'Bio::EnsEMBL::Utils::Proxy');  
}


diag( "Testing check_ref in Bio::EnsEMBL::XS::Utils::Scalar $Bio::EnsEMBL::XS::VERSION, Perl $], $^X" );

done_testing();
