#!perl 
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

diag( "Testing assert_ref in Bio::EnsEMBL::XS::Utils::Scalar $Bio::EnsEMBL::XS::VERSION, Perl $], $^X" );

done_testing();