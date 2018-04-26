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
				 'Test::Deep' => 0,
				 'Test::LeakTrace' => 0
				},
	      PREREQ_PM => {
			    #'ABC'              => 1.6,
			    #'Foo::Bar::Module' => 5.0401,
			   },
	      META_MERGE => {
			     'meta-spec' => { version => 2 },
			     resources => {
					   repository => {
							  type => 'git',
							  url  => 'https://github.com/Ensembl/ensembl-xs.git',
							  web  => 'https://github.com/Ensembl/ensembl-xs',
							 },
					  },
			    },

	      # 'DIR'  => [ 'avltree', 'xs' ], # where to look for additional Makefile.PLs
	      LIBS      => [''],   # e.g., '-lm',
	      DEFINE    => '-DENABLE_DEBUG', # e.g., '-DHAVE_SOMETHING'
	      INC       => '-Iitree',
	      'C'        => [ qw( Bio-EnsEMBL.c ) ],
	      'XS'       => { 'Bio-EnsEMBL.xs' => 'Bio-EnsEMBL.c' },
	      'OBJECT'   => 'Bio-EnsEMBL.o',
	      MYEXTLIB  => 'itree/libitree$(LIB_EXT)', 
	      dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
	      clean => { FILES => 'Bio-EnsEMBL-XS-*' },
	     );

sub MY::postamble {
'
$(MYEXTLIB): itree/Makefile
	cd itree && $(MAKE) $(PASSTHRU)
';
}
