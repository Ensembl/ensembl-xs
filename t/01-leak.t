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

use strict;
use warnings FATAL => 'all';
use FindBin '$Bin';

use constant HAS_LEAKTRACE => eval{ require Test::LeakTrace };
use constant HAS_INTERVAL => eval{ require Bio::EnsEMBL::Utils::Interval };
use Test::More HAS_LEAKTRACE ? (tests => 11) : (skip_all => 'require Test::LeakTrace');
use Test::LeakTrace;

use lib "$Bin/../lib", "$Bin/../blib/lib", "$Bin/../blib/arch";

use_ok('Bio::EnsEMBL::XS');
use_ok('Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval');
use_ok('Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable');

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
    
no_leaks_ok {
  my $i1 = Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval->new(10, 20, 10);
  my ($low, $high, $data) = ($i1->low, $i1->high, $i1->data);
  
  my $i2 = $i1->copy;
  ($low, $high, $data) = ($i2->low, $i2->high, $i2->data);
  
  my $i3 = Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval->new(21, 30, 21);
  $i1->overlap($i3); $i3->equal($i1);
  
  my $i4 = Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval->new(5, 15, 5);
  $i1->equal($i4); $i4->overlap($i1);

  my $i5 = Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval->new(10, 20, { a => 1, b => 2 });
  ($low, $high, $data) = ($i5->low, $i5->high, $i5->data);
  $i1->overlap($i5); $i5->equal($i1);
 
} 'Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval';

no_leaks_ok {
  my $tree = Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable->new();
} 'Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval: empty tree';

SKIP: {
  skip "You should install the branch experimental/mapper_update to test interval trees for leak traces",
    3 unless HAS_INTERVAL;

  my $intervals = [
	    Bio::EnsEMBL::Utils::Interval->new(15, 20, 10),
	    Bio::EnsEMBL::Utils::Interval->new(10, 30, 20),
	    Bio::EnsEMBL::Utils::Interval->new(17, 19, 30),
	    Bio::EnsEMBL::Utils::Interval->new(5, 20, 40),
	    Bio::EnsEMBL::Utils::Interval->new(12, 15, 50),
	    Bio::EnsEMBL::Utils::Interval->new(30, 40, 25)
		  ];
  
  no_leaks_ok {
    my $tree = Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable->new();
    foreach my $interval (@{$intervals}) {
      $tree->insert($interval);
    }
    $tree->size();
  } 'Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval: tree after insertion';

  no_leaks_ok {
    my $tree = Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable->new();
    foreach my $interval (@{$intervals}) {
      $tree->insert($interval);
    }

    my $result = $tree->find(6., 7.);
    $result = $tree->find(1, 4);

    my $results = $tree->search(8, 11);

  } 'Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval: tree after insertion/querying';

  no_leaks_ok {
    my $tree = Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable->new();
    foreach my $interval (@{$intervals}) {
      $tree->insert($interval);
    }

    for my $i (0 .. 5) {
      $tree->remove($intervals->[$i]);
      $tree->size();
    }
  } 'Bio::EnsEMBL::XS::Utils::Tree::Interval: after insertion/removal';
}

diag( "Testing memory leaking Bio::EnsEMBL::XS $Bio::EnsEMBL::XS::VERSION, Perl $], $^X" );
