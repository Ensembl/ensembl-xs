# Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
# Copyright [2016-2020] EMBL-European Bioinformatics Institute
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

ok(Bio::EnsEMBL::XS::Variation::Utils::VariationEffect::overlap(1, 5, 3, 7), "overlap partial 3'");
ok(Bio::EnsEMBL::XS::Variation::Utils::VariationEffect::overlap(3, 5, 1, 4), "overlap partial 5'");
ok(Bio::EnsEMBL::XS::Variation::Utils::VariationEffect::overlap(1, 10, 2, 4), "overlap within 1");
ok(Bio::EnsEMBL::XS::Variation::Utils::VariationEffect::overlap(3, 5, 1, 10), "overlap within 2");
ok(!Bio::EnsEMBL::XS::Variation::Utils::VariationEffect::overlap(1, 5, 6, 7), "no overlap 3'");
ok(!Bio::EnsEMBL::XS::Variation::Utils::VariationEffect::overlap(4, 5, 1, 3), "no overlap 5'");

diag( "Testing variation overlap Bio::EnsEMBL::XS $Bio::EnsEMBL::XS::VERSION, Perl $], $^X" );

done_testing();
