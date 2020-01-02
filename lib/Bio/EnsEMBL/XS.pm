=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2020] EMBL-European Bioinformatics Institute

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


=head1 CONTACT

  Please email comments or questions to the public Ensembl
  developers list at <http://lists.ensembl.org/mailman/listinfo/dev>.

  Questions may also be sent to the Ensembl help desk at
  <http://www.ensembl.org/Help/Contact>.

=cut

package Bio::EnsEMBL::XS;

use 5.8.9;
use strict;
use warnings FATAL => 'all';

=head1 NAME

Bio::EnsEMBL::XS - C extensions of the Ensembl API

=head1 VERSION

Version 1.3.1

=cut

our $VERSION = '2.3.2';
our $ENABLE_DEBUG = 1;

=head1 SYNOPSIS

Efficient implementations of Ensembl API routines and methods in C.

    # First (not recommended) mode of operation, i.e. directly use 
    # the fast reimplementation of Bio::EnsEMBL::Utils::Argument::rearrange, 
    # e.g.

    use Bio::EnsEMBL::XS;

    my ($one, $two, $three) = 
      Bio::EnsEMBL::XS::Utils::Argument::rearrange(['one','tWO','THRee'], 
                                                   ('-TwO' => 2,
                                                    '-oNE' => 1,
                                                    '-THreE' => 3));

    # Second (recommended) mode of operation, i.e. import the original 
    # module which will then detect whether Bio::EnsEMBL::XS is installed and
    # use its reimplementation instead, e.g.

    use Bio::EnsEMBL::Utils::Argument;

    # use Bio::EnsEMBL::XS::Utils::Argument::rearrage if Bio::EnsEMBL is installed
    my ($one, $two, $three) = rearrange(['one','tWO','THRee'], 
                                        ('-TwO' => 2,
                                         '-oNE' => 1,
                                         '-THreE' => 3));
    

=head1 DESCRIPTION

The Bio::EnsEMBL::XS module only exists to provide dynamic loading of 
all compiled and installed extensions written for specific parts of the 
Ensembl API.

The namespace is organised to closely mirror that of the original Ensembl
API, with the difference of an extra 'XS' put between 'Bio::EnsEMBL' and
what would appear as the rest in the original module namespace, e.g. 
'Utils::Argument'.

The module supports two modes of operation. In the first one, you import 
Bio::EnsEMBL::XS and then directly call the optimised version of a method.
The second mode is designed to be the most transparent and hence the 
preferred way. You just import the original module, which will then detect 
whether Bio::EnsEMBL::XS has been installed in the system and use the 
corresponding optimised version of the module's method.

=cut 

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw() ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

require XSLoader;
XSLoader::load('Bio::EnsEMBL::XS', $VERSION);

=head1 METHODS

=cut

=head2 rearrange

=cut

=head2 check_ref

=cut

=head2 assert_ref

=cut

=head2 assert_numeric

=cut

=head2 assert_integer

=cut

=head1 AUTHOR

Alessandro Vullo, C<< <avullo at ebi.ac.uk> >>

=head1 BUGS


=head1 SUPPORT

Please email comments or questions to the public Ensembl
developers list at <http://lists.ensembl.org/mailman/listinfo/dev>.

Questions may also be sent to the Ensembl help desk at
<http://www.ensembl.org/Help/Contact>.

=cut

1; # End of Bio::EnsEMBL::XS
