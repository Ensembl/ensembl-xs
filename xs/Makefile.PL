use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'     => 'Bio::EnsEMBL::XS',
    'C'        => [ qw( Bio-EnsEMBL.c ) ],
    'XS'       => { 'Bio-EnsEMBL.xs' => 'Bio-EnsEMBL.c' },
    'OBJECT'   => 'Bio-EnsEMBL.o',
    'VERSION'  => 1.1, # has to be set (to number), otherwise XSLoader complains
    'NORECURS' => 1,
);
