#!perl -T
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
