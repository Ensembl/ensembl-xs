#!perl -T
use 5.8.9;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 1;

BEGIN {
  use_ok( 'Bio::EnsEMBL::XS' ) || print "Bail out!\n";
}

diag( "Loading Bio::EnsEMBL::XS $Bio::EnsEMBL::XS::VERSION, Perl $], $^X" );
