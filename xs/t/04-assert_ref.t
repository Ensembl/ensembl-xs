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
ok(Bio::EnsEMBL::XS::Utils::Scalar::assert_ref([1,2,3], 'ARRAY'), 'array');
$test_name = 'not array';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref({a=>1,b=>2}, 'ARRAY') };
if ($@) { ok($@ =~ 'was expected to be', $test_name); } else { ok(0, $test_name); }

ok(Bio::EnsEMBL::XS::Utils::Scalar::assert_ref({a=>1,b=>2}, 'HASH'), 'hash');
$test_name = 'not hash';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref([1,2,3], 'HASH') };
if ($@) { ok($@ =~ 'was expected to be', $test_name); } else { ok(0, $test_name); }



diag( "Testing assert_ref in Bio::EnsEMBL::XS::Utils::Scalar $Bio::EnsEMBL::XS::VERSION, Perl $], $^X" );

done_testing();
