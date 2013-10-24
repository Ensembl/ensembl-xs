package Bio::EnsEMBL::XS;

use 5.8.9;
use strict;
use warnings FATAL => 'all';

=head1 NAME

Bio::EnsEMBL::XS - C extensions of the Ensembl API

=head1 VERSION

Version 1.1

=cut

our $VERSION = 1.1; 

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

The first release features one fast reimplementation of the method rearrange
of module Bio::EnsEMBL::Argument.

=cut 

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw() ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

require XSLoader;
XSLoader::load('Bio::EnsEMBL::XS', $VERSION);

=head1 AUTHOR

Alessandro Vullo, C<< <avullo at ebi.ac.uk> >>

=head1 BUGS

No known bugs at the moment. Development in progress.

=head1 SUPPORT

Please email comments or questions to the public Ensembl
developers list at <dev@ensembl.org>.

Questions may also be sent to the Ensembl help desk at
<helpdesk@ensembl.org>.

=head1 ACKNOWLEDGEMENTS

Greatly in debt with Andy Yates, C<< <ayates at ebi.ac.uk> >>, 
for his generous support, kindness and expertise.

=head1 LICENSE AND COPYRIGHT

Copyright (c) 1999-2013 The European Bioinformatics Institute and
Genome Research Limited.  All rights reserved.

This software is distributed under a modified Apache license.
For license details, please see

  http://www.ensembl.org/info/about/code_licence.html

=cut

1; # End of Bio::EnsEMBL::XS
