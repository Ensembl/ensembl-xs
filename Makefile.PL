=head1 LICENSE

  Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
  Copyright [2016-2024] EMBL-European Bioinformatics Institute

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

=cut

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
