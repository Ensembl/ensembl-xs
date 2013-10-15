package Bio::EnsEMBL::XS;

use 5.8.9;
use strict;
use warnings FATAL => 'all';

=head1 NAME

Bio::EnsEMBL::XS - C extensions of the Ensembl API

=head1 VERSION

Version 1.0

=cut

our $VERSION = 1.0; # has to be set to number otherwise DynaLoader complains

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Bio::EnsEMBL::XS;

    my $foo = Bio::EnsEMBL::XS->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

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

You can find documentation for this module with the perldoc command:

  perldoc Bio::EnsEMBL::XS

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
