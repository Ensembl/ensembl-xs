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
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_numeric(); };
if ($@) { ok($@ =~ 'Usage', $test_name); } else { ok(0, $test_name); }

ok(Bio::EnsEMBL::XS::Utils::Scalar::assert_numeric(undef), "assertions not set");

$Bio::EnsEMBL::Utils::Scalar::ASSERTIONS = 1;
$test_name = 'undefined argument';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_numeric(undef) };
if ($@) { ok($@ =~ 'attribute is undefined', $test_name); } else { ok(0, $test_name); }

$test_name = 'blessed argument';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_numeric(bless([], 'Foo')) };
if ($@) { ok($@ =~ 'cannot work with blessed', $test_name); } else { ok(0, $test_name); }

$test_name = 'not a number';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_numeric("test string") };
if ($@) { ok($@ =~ 'was not a number', $test_name); } else { ok(0, $test_name); }

#
# Test normal mode of operation
#
ok(Bio::EnsEMBL::XS::Utils::Scalar::assert_numeric(123456), "integer");
ok(Bio::EnsEMBL::XS::Utils::Scalar::assert_numeric(1e-11), "float");
ok(Bio::EnsEMBL::XS::Utils::Scalar::assert_numeric("2332323"), "stringified integer");

diag( "Testing assert_[numeric|integer] in Bio::EnsEMBL::XS::Utils::Scalar $Bio::EnsEMBL::XS::VERSION, Perl $], $^X" );

done_testing();
