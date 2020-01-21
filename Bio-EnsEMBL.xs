/*
  Copyright [1999-2015] Wellcome Trust Sanger Institute and the 
  EMBL-European Bioinformatics Institute
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
*/

#ifdef __cplusplus
extern "C" {
#endif

#define PERL_NO_GET_CONTEXT

#ifdef ENABLE_DEBUG
#define TRACEME(x) do { \
	if (SvTRUE(perl_get_sv("Bio::EnsEMBL::XS::ENABLE_DEBUG", TRUE))) \
	  { PerlIO_stdoutf (x); PerlIO_stdoutf ("\n"); }	    \
} while (0)
#else
#define TRACEME(x)
#endif

#include "EXTERN.h"
#include "perl.h"
#define NEED_sv_2pv_flags
#define NEED_newRV_noinc
#include "XSUB.h"
#include "ppport.h"
  
#include "interval.h"
#include "interval_list.h"
#include "interval_tree.h"

#include <string.h>
  
#ifdef __cplusplus
}
#endif

typedef interval_t* Bio__EnsEMBL__XS__Utils__Tree__Interval__Mutable__Interval;
typedef itree_t* Bio__EnsEMBL__XS__Utils__Tree__Interval__Mutable;

/* C-level callbacks required by the interval tree library */

static SV* svclone(SV* p) {
  dTHX;       /* fetch context */

  return SvREFCNT_inc(p);
}

void svdestroy(SV* p) {
  dTHX;       /* fetch context */

  SvREFCNT_dec(p);
}

/*====================================================================
 * XS SECTION                                                     
 *====================================================================*/

MODULE = Bio::EnsEMBL::XS            PACKAGE = Bio::EnsEMBL::XS::Utils::Argument

PROTOTYPES: DISABLED

void 
rearrange(...)
  INIT:
	/* if(!items) { */
	/*      XSRETURN_UNDEF; */
	/* } */
	if(items < 2) {
	     XSRETURN_UNDEF; /* croak("missing arguments"); */
	}
	
	int oindex = 0, pindex = 1; /* put in PREINIT?! */

	/* skip object if one provided */
	if(SvOK(ST(0)) && SvTYPE(ST(0)) == SVt_PV && strEQ(SvPVX(ST(0)), "Bio::EnsEMBL::Utils::Argument")) {
	     oindex = 1;
	     pindex = 2;
	}
	SV* order = sv_2mortal(newSVsv(ST(oindex)));

	/* order must be an array ref */
	if ((! SvROK(order))
	   || (SvTYPE(SvRV(order)) != SVt_PVAV)) {
	      /*XSRETURN_UNDEF;*/
	      croak("order argument must be array ref");
	} else { /* must contain elements */
	  if(av_len((AV *)SvRV(order)) < 0) {
	  	croak("order array_ref must contain elements");
	  }	  
	}
  CODE:
	/* If we've got parameters, we need to check whether
  	   they are named or simply listed. If they are listed, 
	   we can just return them */
	int return_as_is = 0;
	if(SvOK(ST(pindex)) && SvTYPE(ST(pindex)) == SVt_PV) {
	      char* s = (char*)SvPV_nolen(ST(pindex)); 
	      if(s[0] != '-') {
	            return_as_is = 1;
	      }
        } else {
	      return_as_is = 1;
        }
	if(return_as_is) {
	      int i, j;
	      for(i=0, j=pindex; j < items; ++i, ++j) {
	            ST(i) = sv_2mortal(newSVsv(ST(j)));		      	       
	      }
	      XSRETURN(i);
	}

	/* TODO: push undef onto the end if % 2 != 0 to stop warnings? */
	
	/* We have named arguments 
	   Store the values in a hash
	*/
	HV* params = newHV(); /*(HV*)sv_2mortal((SV*)newHV());*/
	int i;
	for(i = pindex; i < items-1; i+=2) {
	      if(!(SvOK(ST(i)) && SvTYPE(ST(i)) == SVt_PV)) {
	            croak("argument should be named");
	      }
	      /* delete dash and uppercase arg key */
	      /*char *key = (char*)SvPV_nolen(ST(i)) + 1;*/ /* add 1 to skip dash */
	      char *key = savepv(SvPV_nolen(ST(i))) + 1; /* add 1 to skip dash */
	      char *p = key;
	      while(*p != '\0') {
	            *p = toupper(*p);
		    p++;
	      }

	      /* have to copy to new SV otherwise doesn't properly recognise type */
	      hv_store(params, key, strlen(key), newSVsv(ST(i+1)), 0);
	}

	AV* order_list = (AV*)SvRV(order);
	int avi, j;
	for(avi=0, j=0; avi<=AvFILL(order_list); ++avi, ++j) {
	      STRLEN len;
	      char* key = SvPV(*av_fetch(order_list, avi, 0), len);
	      char *p = key;
	      while(*p != '\0') {
	            *p = toupper(*p);
	      	    p++;
	      }
	      
	      SV** svp = hv_fetch(params, key, len, 0);
	      if(svp != NULL) {
	      	     ST(j) = sv_2mortal(newSVsv(*svp));
		     hv_delete(params, key, len, G_DISCARD); /* prevent memory leak */
		 
	      } else {
	             ST(j) = &PL_sv_undef;
              }	     
	}

	/*hv_undef(params);*/
	SvREFCNT_dec((SV*)params); /* otherwise memory leak */
	
	XSRETURN(j);


MODULE = Bio::EnsEMBL::XS            PACKAGE = Bio::EnsEMBL::XS::Utils::Scalar

PROTOTYPES: DISABLED

IV
check_ref(ref,expected)
  SV* ref
  SV* expected
  CODE:
    RETVAL = 0;

    if(SvTYPE(expected) == SVt_NULL) {
      croak("Undefined expected type");
    } else if(!(SvOK(expected) && SvTYPE(expected) == SVt_PV)) {
      croak("Expected type should be a string");
    }

    if(SvTYPE(ref) != SVt_NULL) {
      const char* exp_class_name = (const char*)SvPV_nolen(expected);

      if(sv_isobject(ref)) {
        const char* ref_class_name = HvNAME(SvSTASH(SvRV(ref)));
    
        if(strstr(ref_class_name, "Proxy") != NULL) {
          /* If the ref is a proxy object (i.e. inherits from Bio::EnsEMBL::Utils::Proxy */
	  /* The real class to check is that of the proxied object */
	  /* We can do this by calling the isa method of the proxy object */
	  dSP;
	  int count;

	  PUSHMARK(SP);
	  XPUSHs(sv_2mortal(newSVsv(ref)));
	  XPUSHs(sv_2mortal(newSVpv(exp_class_name, 0)));
	  PUTBACK;

	  count = call_method("isa", G_SCALAR);
	 
	  SPAGAIN;
	 
	  /* Check whether the proxied object is of the expected class */
	  if(POPi) /*sv_derived_from(POPi, exp_class_name)) */
	    RETVAL = 1;
	  PUTBACK;
        } else if(sv_derived_from(ref, exp_class_name))
          RETVAL = 1;
      } else if(SvROK(ref)) {
        /* See http://perldoc.perl.org/perlapi.html#SV-Flags */
      	char* e = SvPVX(expected);
      	switch (SvTYPE(SvRV(ref))) {
	  case SVt_PVAV:
	    if(strEQ(e, "ARRAY"))
	      RETVAL = 1;
	    break;
	  case SVt_PVHV:
	    if(strEQ(e, "HASH"))
	      RETVAL = 1;
	    break;
	  case SVt_PVCV:
	    if(strEQ(e, "CODE"))
	      RETVAL = 1;
	    break;
	  case SVt_PVGV:
	    if(strEQ(e, "GLOB"))
	      RETVAL = 1;
	    break;
#ifdef PERL_IS_5_14 
	  case SVt_REGEXP:
	    if(strEQ(e, "Regexp"))
	      RETVAL = 1;
	    break;
#endif
	  case SVt_PVIO:
	    if(strEQ(e, "IO"))
	      RETVAL = 1;
	    break;
	  case SVt_PVFM:
	    if(strEQ(e, "FORMAT"))
	      RETVAL = 1;
	    break;
	  /* handle the reference to scalar case */
	  case SVt_IV:
	  case SVt_NV:
	  case SVt_PV:
	  case SVt_PVIV:
	  case SVt_PVNV:
	  case SVt_PVMG:
	    if(strEQ(e, "SCALAR"))
	      RETVAL = 1;
	    break;	    
	  default:
	    break;
	}
      }
    }
  OUTPUT:
    RETVAL

IV
assert_ref(ref,expected, ...)
  SV* ref
  SV* expected
  PREINIT:
    char* attribute_name;
  CODE:
    RETVAL = 1;

    if (!SvTRUE(get_sv("Bio::EnsEMBL::Utils::Scalar::ASSERTIONS", FALSE)))
      XSRETURN_YES;

    attribute_name = "-Unknown-";
    if(items > 2 && SvOK(ST(2)) && SvTYPE(ST(2)) != SVt_NULL)     /* attribute_name might be explicitly set to undef */
      attribute_name = SvPV_nolen(ST(2));

    if(SvTYPE(ref) == SVt_NULL) {
      croak("The given reference for attribute %s was undef", attribute_name);
    } 
    if(SvTYPE(expected) == SVt_NULL) {
      croak("No expected type given");
    } else if(!(SvOK(expected) && SvTYPE(expected) == SVt_PV)) {
      croak("Expected type should be a string");
    }
    
    if(!SvROK(ref))
      /* msg is not exactly what we've done, but the
         end result is the same */ 
      croak("Asking for the type of the attribute %s produced no type; check it is a reference", attribute_name);
    
    const char* exp_class_name = (const char*)SvPV_nolen(expected);

    if(sv_isobject(ref)) { 
       const char* ref_class_name = HvNAME(SvSTASH(SvRV(ref)));
    
       if(strstr(ref_class_name, "Proxy") != NULL) {
         /* If the ref is a proxy object (i.e. inherits from Bio::EnsEMBL::Utils::Proxy */
	 /* The real class to check is that of the proxied object */
	 /* We can do this by calling the isa method of the proxy object */
	 dSP;
	 int count;

	 PUSHMARK(SP);
	 XPUSHs(sv_2mortal(newSVsv(ref)));
	 XPUSHs(sv_2mortal(newSVpv(exp_class_name, 0)));
	 PUTBACK;

	 count = call_method("isa", G_SCALAR);
	 
	 SPAGAIN;
	 
	 /* Check whether the proxied object is of the expected class */
	 if(!POPi) /*sv_derived_from(POPi, exp_class_name)) */
	   croak("%s's type is not an ISA of '%s'", attribute_name, exp_class_name);
	 PUTBACK;

       } else if(!sv_derived_from(ref, exp_class_name))
         croak("%s's type (%s) is not an ISA of '%s'", attribute_name, ref_class_name, exp_class_name);
    } else {
      char* class;
      switch (SvTYPE(SvRV(ref))) {
        case SVt_PVAV:
          class = "ARRAY";
	  break;
        case SVt_PVHV:
          class = "HASH";
          break;
        case SVt_PVCV:
          class = "CODE";
          break;
        case SVt_PVGV:
          class = "GLOB";
          break;
#ifdef PERL_IS_5_14
      case SVt_REGEXP:
          class = "Regexp";
	  break;
#endif
        case SVt_PVIO:
          class = "IO";
          break;
        case SVt_PVFM:
          class = "FORMAT";
          break;
        /* handle the reference to scalar case */
        case SVt_IV:
        case SVt_NV:
        case SVt_PV:
        case SVt_PVIV:
        case SVt_PVNV:
        case SVt_PVMG:
          class = "SCALAR";
	  break;	    	    
        default:
          break;
      }

      if(!strEQ(SvPVX(expected), class))
        croak("%s was expected to be '%s' but was '%s'", attribute_name, exp_class_name, class);
    }

  OUTPUT:
    RETVAL

IV
assert_numeric(scalar, ...)
  SV* scalar
  PREINIT:
    char* attribute_name;
  CODE:
    RETVAL = 1;

    if (!SvTRUE(get_sv("Bio::EnsEMBL::Utils::Scalar::ASSERTIONS", FALSE)))
      XSRETURN_YES;

    attribute_name = "-Unknown-";
    if(items > 1 && SvOK(ST(1)) && SvTYPE(ST(1)) != SVt_NULL)     /* attribute_name might be explicitly set to undef */
      attribute_name = SvPV_nolen(ST(1));

    if(SvTYPE(scalar) == SVt_NULL) {
      croak("%s attribute is undefined", attribute_name);
    } else if(sv_isobject(scalar)) {
        croak("The given attribute %s is blessed; cannot work with blessed values", attribute_name);
    } else {
      if(!looks_like_number(scalar))
        croak("Attribute %s was not a number", attribute_name);
    }

  OUTPUT:
    RETVAL

IV
assert_integer(scalar, ...)
  SV* scalar
  PREINIT:
    char* attribute_name;
  CODE:
    RETVAL = 1;

    if (!SvTRUE(get_sv("Bio::EnsEMBL::Utils::Scalar::ASSERTIONS", FALSE)))
      XSRETURN_YES;

    attribute_name = "-Unknown-";
    if(items > 1 && SvOK(ST(1)) && SvTYPE(ST(1)) != SVt_NULL)     /* attribute_name might be explicitly set to undef */
      attribute_name = SvPV_nolen(ST(1));

    /*
       Do not call the perl assert_numeric subroutine from C,
       as the call represents a significant overhead wrt to 
       the actual function work.
       Just reimplement what assert_numeric is doing.
    */
	
    /* /\* Call perl subroutines directly from C */
    /*    See http://perldoc.perl.org/perlcall.html *\/ */
    /* dSP; */
    
    /* /\* Disposing of temporaries would create */
    /*    seg fault, comment it *\/ */
    /* /\* ENTER; *\/ */
    /* /\* SAVETMPS; *\/ */

    /* PUSHMARK(SP); */
    /* XPUSHs(sv_2mortal(newSVsv(scalar))); */
    /* XPUSHs(sv_2mortal(newSVpv(attribute_name, 0))); */
    /* PUTBACK; */
    
    /* call_pv("Bio::EnsEMBL::Utils::Scalar::assert_numeric_pp", G_DISCARD); */

    /* /\* FREETMPS; *\/ */
    /* /\* LEAVE; *\/ */

    if(SvTYPE(scalar) == SVt_NULL) {
      croak("%s attribute is undefined", attribute_name);
    } else if(sv_isobject(scalar)) {
      croak("The given attribute %s is blessed; cannot work with blessed values", attribute_name);
    } else {
      if(!looks_like_number(scalar))
        croak("Attribute %s was not a number", attribute_name);
    }

    if(SvNOK(scalar) || SvPOK(scalar)) {
      croak("Attribute %s was a number but not an Integer", attribute_name);
    }

  OUTPUT:
    RETVAL


MODULE = Bio::EnsEMBL::XS            PACKAGE = Bio::EnsEMBL::XS::Variation::Utils::VariationEffect

PROTOTYPES: DISABLED

int
overlap(f1_start,f1_end,f2_start,f2_end)
  int f1_start;
  int f2_start;
  int f1_end;
  int f2_end;
  
  CODE:
    RETVAL = 0;
    
    if(f1_end >= f2_start) {
      if(f1_start <= f2_end) {
        RETVAL = 1;
      }
    }
    
  OUTPUT:
    RETVAL

MODULE = Bio::EnsEMBL::XS            PACKAGE = Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval

Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval
new(packname, low, high, data)
    char* packname
    float low
    float high
    SV*   data
  PROTOTYPE: $$$
  CODE:
    RETVAL = interval_new(low, high, data, svclone, svdestroy);

  OUTPUT:
    RETVAL

Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval
copy(interval)
    Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval interval
  PROTOTYPE: $
  CODE:
    RETVAL = interval_copy(interval);

  OUTPUT:
    RETVAL

int
overlap(i1, i2)
    Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval i1
    Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval i2
  PROTOTYPE: $$ 
  CODE:
    RETVAL = interval_overlap(i1, i2);

  OUTPUT:
    RETVAL

int
equal(i1, i2)
    Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval i1
    Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval i2
  PROTOTYPE: $$ 
  CODE:
    RETVAL = interval_equal(i1, i2);

  OUTPUT:
    RETVAL

float
low(interval)
    Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval interval
  PROTOTYPE: $
  CODE:
    RETVAL = interval->low;

  OUTPUT:
    RETVAL

float
high(interval)
    Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval interval
  PROTOTYPE: $
  CODE:
    RETVAL = interval->high;

  OUTPUT:
    RETVAL

SV*
data(interval)
    Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval interval
  PROTOTYPE: $
  CODE:
    RETVAL = newSVsv(interval->data);

  OUTPUT:
    RETVAL

void
DESTROY(interval)
    Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval interval
  PROTOTYPE: $
  CODE:
    interval_delete(interval);
  
MODULE = Bio::EnsEMBL::XS            PACKAGE = Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable

Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable
new( class )
    char* class
  PROTOTYPE: $
  CODE:

    TRACEME("Allocating interval tree");
    RETVAL = itree_new(svclone, svdestroy);

    if(RETVAL == NULL) {
      warn("Unable to allocate interval tree");
      XSRETURN_UNDEF;
    }

  OUTPUT:
    RETVAL

SV*
find( tree, low, high )
    Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable tree
    int low
    int high
  PROTOTYPE: $$$
  PREINIT:
    interval_t *i, *result;
    
  CODE:
    i = interval_new( low, high, &PL_sv_undef, svclone, svdestroy);

    result = itree_find( tree, i );
    interval_delete(i);

    if(result == NULL)
      XSRETURN_UNDEF;

    /*
     * Return a copy of the result as this belongs to the tree
     *
     * WARNING
     *
     * Invoking interval_copy on the result generates segfault.
     * Couldn't figure out why so far.
     *
     * RETVAL = interval_new( result->low, result->high, result->data, svclone, svdestroy);
     */

    /* Return an ensembl core API compatible interval as result */
    HV* hash = newHV();
    hv_store( hash, "start", 5, newSVnv(result->low), 0 );
    hv_store( hash, "end", 3, newSVnv(result->high), 0 );
    hv_store( hash, "data", 4, newSVsv(result->data), 0 );

    RETVAL = newRV_noinc( (SV*)hash );
    sv_bless( RETVAL, gv_stashpv("Bio::EnsEMBL::Utils::Interval", FALSE) );

  OUTPUT:
    RETVAL

SV*
search( tree, low, high )
    Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable tree
    int low
    int high
  PROTOTYPE: $$$
  PREINIT:
    AV* av_ref;
    interval_t *i;
    const interval_t *item;
    ilist_t* results;
    ilisttrav_t* trav;
    
  CODE:
    i = interval_new ( low, high, &PL_sv_undef, svclone, svdestroy );

    results = itree_findall ( tree, i );
    interval_delete ( i );

    /* empty results set, return undef */
    if ( results == NULL || !ilist_size ( results ) ) {
      ilist_delete ( results );
      XSRETURN_UNDEF;
    }

    /* return a reference to an array of intervals */
    av_ref = (AV*) sv_2mortal( (SV*) newAV() );

    trav = ilisttrav_new( results );
    if ( trav == NULL ) {
      ilist_delete ( results );
      croak("Cannot traverse results set");
    }

    for(item = ilisttrav_first(trav); item!=NULL; item=ilisttrav_next(trav)) {
      /*
       * SV* ref = newSV(0);
       * sv_setref_pv( ref, "Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable::Interval", 
       *               (void*)interval_new(item->low, item->high, item->data, svclone, svdestroy) );
       *
       */
      HV* hash = newHV();
      hv_store( hash, "start", 5, newSVnv(item->low), 0 );
      hv_store( hash, "end", 3, newSVnv(item->high), 0 );
      hv_store( hash, "data", 4, newSVsv(item->data), 0 );
      
      SV* ref = newRV_noinc( (SV*)hash );
      sv_bless( ref, gv_stashpv("Bio::EnsEMBL::Utils::Interval", FALSE) );
      
      av_push( av_ref, ref );
    }

    RETVAL = newRV( (SV*) av_ref );
    ilist_delete ( results );

  OUTPUT:
    RETVAL


int
insert( tree, interval )
    Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable tree
    SV* interval
  PROTOTYPE: $$
  PREINIT:
    interval_t *i;
    float low, high;
  INIT:
    if( !(SvOK(interval) && sv_isobject(interval) && sv_isa(interval, "Bio::EnsEMBL::Utils::Interval")) )
      croak("Need a Bio::EnsEMBL::Utils::Interval instance as parameter");

  CODE:
    SV** svp = hv_fetch((HV*)SvRV(interval), "start", 5, 0);
    if(svp == NULL)
      croak("Unable to access interval start field \n");
    low = SvNV(*svp);

    svp = hv_fetch((HV*)SvRV(interval), "end", 3, 0);
    if(svp == NULL)
      croak("Unable to access interval end field \n");
    high = SvNV(*svp);

    svp = hv_fetch((HV*)SvRV(interval), "data", 4, 0);
    if(svp == NULL)
      croak("Unable to access interval data field \n");

    i = interval_new(low, high, *svp, svclone, svdestroy);
    RETVAL = itree_insert ( tree, i );
    interval_delete ( i );

  OUTPUT:
    RETVAL
    
int
remove( tree, interval )
    Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable tree
    SV* interval
  PROTOTYPE: $$
  PREINIT:
    interval_t *i;
    float low, high;
  INIT:
    if( !(SvOK(interval) && sv_isobject(interval) && sv_isa(interval, "Bio::EnsEMBL::Utils::Interval")) )
      croak("Need a Bio::EnsEMBL::Utils::Interval instance as parameter");

  CODE:
    SV** svp = hv_fetch((HV*)SvRV(interval), "start", 5, 0);
    if(svp == NULL)
      croak("Unable to access interval start field \n");
    low = SvNV(*svp);

    svp = hv_fetch((HV*)SvRV(interval), "end", 3, 0);
    if(svp == NULL)
      croak("Unable to access interval end field \n");
    high = SvNV(*svp);

    svp = hv_fetch((HV*)SvRV(interval), "data", 4, 0);
    if(svp == NULL)
      croak("Unable to access interval data field \n");

    i = interval_new(low, high, *svp, svclone, svdestroy);
    RETVAL = itree_remove( tree, i );
    interval_delete ( i );

  OUTPUT:
    RETVAL
	 
int
size( tree )
    Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable tree
  PROTOTYPE: $
  CODE:
    RETVAL = itree_size( tree );

  OUTPUT:
    RETVAL

void
DESTROY( tree )
    Bio::EnsEMBL::XS::Utils::Tree::Interval::Mutable  tree
  PROTOTYPE: $
  CODE:
      TRACEME("Deleting interval tree");
      itree_delete( tree );
