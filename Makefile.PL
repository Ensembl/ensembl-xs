use 5.8.9;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Bio::EnsEMBL::XS',
    AUTHOR           => q{Alessandro Vullo <avullo@ebi.ac.uk>},
    VERSION_FROM     => 'lib/Bio/EnsEMBL/XS.pm',
    # ABSTRACT_FROM    => 'lib/Bio/EnsEMBL/XS.pm',
    # LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.8.9,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    'DIR'  => [ 'xs' ], # where to look for additional Makefile.PLs
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Bio-EnsEMBL-XS-*' },
);
