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

# I/O objects?!
# ok(Bio::EnsEMBL::XS::Utils::Scalar::check_ref($re, 'IO'), 'io');
# is(Bio::EnsEMBL::XS::Utils::Scalar::check_ref([1,2,3], 'IO'), 0, 'not io');

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

diag( "Testing check_ref in Bio::EnsEMBL::XS::Utils::Scalar $Bio::EnsEMBL::XS::VERSION, Perl $], $^X" );

done_testing();
