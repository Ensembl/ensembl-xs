#!perl -T
use 5.8.9;
use strict;
use warnings FATAL => 'all';

use constant HAS_LEAKTRACE => eval{ require Test::LeakTrace };
use Test::More HAS_LEAKTRACE ? (tests => 1) : (skip_all => 'require Test::LeakTrace');
use Test::LeakTrace;

use Bio::EnsEMBL::XS;

no_leaks_ok {
  my @args = ('-TwO' => 2,
	      '-oNE' => 1,
	      '-THreE' => 3);
  my ($one, $two, $three) = 
    Bio::EnsEMBL::XS::Utils::Argument::rearrange(['one','tWO','THRee'], @args);
} 'Bio::EnsEMBL::XS::Utils::rearrange';

diag( "Testing memory leaking Bio::EnsEMBL::XS $Bio::EnsEMBL::XS::VERSION, Perl $], $^X" );
