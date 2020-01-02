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

package Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable;

use Bio::EnsEMBL::XS; # load the XS

$Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::VERSION = '2.3.2';

=head1 METHODS

=cut

=head2 new

Construct an empty interval tree

=cut

=head2 find

Return an overlapping interval with the query

=cut

=head2 search

Return all overlapping interval with the query

=cut

=head2 insert

Insert an interval in the tree

=cut

=head2 remove

Remove an interval from the tree

=cut

=head2 size

Return the size of the tree

=cut

1;
