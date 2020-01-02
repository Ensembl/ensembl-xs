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

use constant HAS_INTERVAL => eval{ require Bio::EnsEMBL::Utils::Interval };
use Test::More HAS_INTERVAL ? (tests => 65) : (skip_all => 'require Bio::EnsEMBL::Utils::Interval');

use lib "$Bin/../lib", "$Bin/../blib/lib", "$Bin/../blib/arch";

use_ok('Bio::EnsEMBL::XS');
use_ok('Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval');
use_ok('Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable');
use_ok('Bio::EnsEMBL::Utils::Interval');

my $interval = Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval->new(10, 20, [1,2,3]);
isa_ok($interval, "Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval");
is($interval->low, 10, 'left bound');
is($interval->high, 20, 'right bound');
is_deeply($interval->data, [1,2,3], 'interval data');

my $copy = $interval->copy;
isa_ok($copy, "Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval");
is($copy->low, 10, 'left bound');
is($copy->high, 20, 'right bound');
is_deeply($copy->data, [1,2,3], 'interval data');

my $non_overlapping = Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval->new(21, 30, 21);
ok(!$interval->overlap($non_overlapping), 'does not overlap');
ok(!$non_overlapping->overlap($interval), 'does not overlap');
ok(!$interval->equal($non_overlapping), 'not equal');
ok(!$non_overlapping->equal($interval), 'not equal');
   
my $overlapping = Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval->new(5, 15, 5);
ok($interval->overlap($overlapping), 'overlaps');
ok($overlapping->overlap($interval), 'overlaps');
ok(!$interval->equal($overlapping), 'not equal');
ok(!$overlapping->equal($interval), 'not equal');

my $interval2 = Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval->new(10, 20, { a => 1, b => 2 });
is_deeply($interval2->data, { a => 1, b => 2}, 'store any kind of data');
ok($interval->overlap($interval2), 'overlaps');
ok($interval2->overlap($interval), 'overlaps');
ok($interval->equal($interval2), 'equal');
ok($interval2->equal($interval), 'equal');

my $tree = Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable->new();
isa_ok($tree, 'Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable');
ok(!$tree->size(), 'empty tree');

my $intervals = make_intervals();

foreach my $interval (@{$intervals}) {
  ok($tree->insert($interval), 'insert interval');
}
is($tree->size(), 6, 'size after insert');

my $result = $tree->find(6, 7);
isa_ok($result, 'Bio::EnsEMBL::Utils::Interval');
is($result->start, 5, 'result left bound');
is($result->end, 20, 'result right bound');
is($result->data, 40, 'result data');

$result = $tree->find(1, 4);
ok(!$result, 'no results');

$result = $tree->find(18, 25);
isa_ok($result, 'Bio::EnsEMBL::Utils::Interval');
is($result->start, 15, 'result left bound');
is($result->end, 20, 'result right bound');
is($result->data, 10, 'result data');

my $results = $tree->find(1, 2);
ok(!$results, 'no results');

$results = $tree->search(8, 11);
is(scalar @$results, 2, 'result set size');
foreach my $item (@{$results}) {
  isa_ok($item, 'Bio::EnsEMBL::Utils::Interval');
  ok($item->start == 5 || $item->start == 10, 'search item left bound');
  ok($item->end == 20 || $item->end == 30, 'search item left bound');
  ok($item->data == 40 || $item->data == 20, 'search item data');
}

for my $i (0 .. 5) {
  ok($tree->remove($intervals->[$i]), 'remove interval');
  is($tree->size(), 5-$i, 'size after removal');
}

diag( "Testing Interval Tree in Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable $Bio::EnsEMBL::XS::VERSION, Perl $], $^X" );

sub make_intervals {
  return [
	  Bio::EnsEMBL::Utils::Interval->new(15, 20, 10),
	  Bio::EnsEMBL::Utils::Interval->new(10, 30, 20),
	  Bio::EnsEMBL::Utils::Interval->new(17, 19, 30),
	  Bio::EnsEMBL::Utils::Interval->new(5, 20, 40),
	  Bio::EnsEMBL::Utils::Interval->new(12, 15, 50),
	  Bio::EnsEMBL::Utils::Interval->new(30, 40, 25)
	 ];
}

done_testing();
