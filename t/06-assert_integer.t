# Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
# Copyright [2016-2024] EMBL-European Bioinformatics Institute
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
use Bio::EnsEMBL::Utils::Scalar;

use_ok('Bio::EnsEMBL::XS');

#
# Test exceptions, e.g. missing or wrong typed arguments
#
my $test_name = 'not enough arguments';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_integer(); };
if ($@) { ok($@ =~ 'Usage', $test_name); } else { ok(0, $test_name); }

$Bio::EnsEMBL::Utils::Scalar::ASSERTIONS = 0;
ok(Bio::EnsEMBL::XS::Utils::Scalar::assert_integer(undef), "assertions not set");

$Bio::EnsEMBL::Utils::Scalar::ASSERTIONS = 1;

$test_name = 'undefined argument';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_integer(undef) };
if ($@) { ok($@ =~ 'attribute is undefined', $test_name); } else { ok(0, $test_name); }

$test_name = 'blessed argument';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_integer(bless([], 'Foo')) };
if ($@) { ok($@ =~ 'cannot work with blessed', $test_name); } else { ok(0, $test_name); }

$test_name = 'not a number';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_integer("test string") };
if ($@) { ok($@ =~ 'was not a number', $test_name); } else { ok(0, $test_name); }

$test_name = 'not an integer';
my $a = 123.45;
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_integer($a) };
if ($@) { ok($@ =~ 'not an Integer', $test_name); } else { ok(0, $test_name); }
$a = 1e-11;
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_integer($a) };
if ($@) { ok($@ =~ 'not an Integer', $test_name); } else { ok(0, $test_name); }

#
# Test normal mode of operation
#
$a = 123;
ok(Bio::EnsEMBL::XS::Utils::Scalar::assert_numeric($a), "integer");

$test_name = 'non numeric argument (attribute name == undef)';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_integer([], undef) };
if ($@) { ok($@ =~ /Attribute.+?Unknown/, $test_name); } else { ok(0, $test_name); }
$test_name = 'non numeric argument (attribute name assigned)';
eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_integer([], "dummy") };
if ($@) { ok($@ =~ /dummy/, $test_name); } else { ok(0, $test_name); }

diag( "Testing assert_integer in Bio::EnsEMBL::XS::Utils::Scalar $Bio::EnsEMBL::XS::VERSION, Perl $], $^X" );

done_testing();
