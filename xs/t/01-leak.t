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

use constant HAS_LEAKTRACE => eval{ require Test::LeakTrace };
use Test::More HAS_LEAKTRACE ? (tests => 4) : (skip_all => 'require Test::LeakTrace');
use Test::LeakTrace;

BEGIN { use_ok('Bio::EnsEMBL::XS'); }

no_leaks_ok {
  my @args = ('-TwO' => 2,
	      '-oNE' => 1,
	      '-THreE' => 3);
  my ($one, $two, $three) = 
    Bio::EnsEMBL::XS::Utils::Argument::rearrange(['one','tWO','THRee'], @args);
} 'Bio::EnsEMBL::XS::Utils::rearrange';

no_leaks_ok {
  my ($is_array) = 
    Bio::EnsEMBL::XS::Utils::Scalar::check_ref([1,2,3], 'ARRAY');
} 'Bio::EnsEMBL::XS::Utils::check_ref';

$Bio::EnsEMBL::Utils::Scalar::ASSERTIONS = 1;
no_leaks_ok {
  my $is_array = 
    eval { Bio::EnsEMBL::XS::Utils::Scalar::assert_ref({a=>1,b=>2,c=>3}, 'ARRAY'); }
} 'Bio::EnsEMBL::XS::Utils::assert_ref';

diag( "Testing memory leaking Bio::EnsEMBL::XS $Bio::EnsEMBL::XS::VERSION, Perl $], $^X" );
