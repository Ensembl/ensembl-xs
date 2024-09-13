# Bio::EnsEMBL::XS - Version 2.3.2

> **WARNING**: the ensembl-xs repository on GitHub has had its history rewritten
> on 2019-03-14 around 12:00 UTC. If you work with this repository you are
> advised to clone it from scratch rather than to update a clone from before
> the rewrite in order to make sure your local commit history is clean.

The `Bio::EnsEMBL::XS` module uses the Perl XS layer to provide fast re-implementations 
in C of some procedures of the Ensembl API, written in pure perl. 

## QUICK INSTALL

To install this module from source code, run the following commands:
```sh
perl Makefile.PL
make
make test
make install
```
See file INSTALL for more detailed documentation on how to obtain, build, test, 
install and benchmark the extensions.
    
## SUPPORT AND DOCUMENTATION

After installing, you can find documentation for this module with the
perldoc command:
```sh
perldoc Bio::EnsEMBL::XS
```

## AUTHOR

The module and the extensions have been written by Alessandro Vullo <avullo@ebi.ac.uk>
with the assistance of Andy Yates and contribution of Will McLaren.

## Contact us
Please email comments or questions to the public Ensembl developers list at

<http://lists.ensembl.org/mailman/listinfo/dev>.

Questions may also be sent to the Ensembl help desk at

<http://www.ensembl.org/Help/Contact>.
