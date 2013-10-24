#!perl -T
use 5.8.9;
use strict;
use warnings FATAL => 'all';

use Test::More tests => 1;

BEGIN { use_ok('Bio::EnsEMBL::XS'); }

#
# Test exceptions, e.g. missing arguments
#
# UPDATE: do not throw exception with missing or not enough arguments
#         to replicate original rearrange behaviour
# throws_ok doesn't catch the exception
# throws_ok { &Bio::EnsEMBL::XS::Utils::Argument::rearrange() }
#  qr/missing argument/, 'call without arguments';
# my $test_name = 'call without arguments';
# eval { &Bio::EnsEMBL::XS::Utils::Argument::rearrange() };
# if ($@) { ok($@ =~ 'missing arguments', $test_name); } else { ok(0, $test_name); }

# $test_name = 'call with not enough arguments';
# eval { &Bio::EnsEMBL::XS::Utils::Argument::rearrange([]) };
# if ($@) { ok($@ =~ 'missing arguments', $test_name); } else { ok(0, $test_name); }

my $test_name = 'no expected type';
&Bio::EnsEMBL::XS::Utils::Scalar::check_ref([]);
# eval { check_ref([]) };
# if ($@) { ok($@ =~ 'expected type', $test_name); } else { ok(0, $test_name); }


$test_name = 'expected type should be string';
check_ref([], 2)
# eval { check_ref([], 2) };
# if ($@) { ok($@ =~ 'string', $test_name); } else { ok(0, $test_name); }

