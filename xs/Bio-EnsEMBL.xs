#ifdef __cplusplus
extern "C" {
#endif

#define PERL_NO_GET_CONTEXT

#ifdef DEBUGME
#define TRACEME(x) do { \
	if (SvTRUE(perl_get_sv("Bio::EnsEMBL::XS::DEBUGME", TRUE))) \
	   { PerlIO_stdoutf x; PerlIO_stdoutf ("\n"); } \
} while (0)
#else
#define TRACEME(x)
#endif

#include "EXTERN.h"
#include "perl.h"
#define NEED_sv_2pv_flags
#define NEED_newRV_noinc
/*#include "ppport.h"*/
#include "XSUB.h"

#ifdef __cplusplus
}
#endif

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
	      char *key = (char*)SvPV_nolen(ST(i)) + 1; /* add 1 to skip dash */
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
      if(sv_isobject(ref) && 
         sv_derived_from(ref, (char*)SvPV_nolen(expected))) {
        RETVAL = 1;
      } else if(SvROK(ref)) {
      	switch (SvTYPE(SvRV(ref))) {
	  case SVt_PVAV:
	    if(strEQ(SvPVX(expected), "ARRAY"))
	      RETVAL = 1;
	    break;
	  case SVt_PVHV:
	    if(strEQ(SvPVX(expected), "HASH"))
	      RETVAL = 1;
	    break;
	  case SVt_PVCV:
	    if(strEQ(SvPVX(expected), "CODE"))
	      RETVAL = 1;
	    break;
	  case SVt_PVGV:
	    if(strEQ(SvPVX(expected), "GLOB"))
	      RETVAL = 1;
	    break;
	  default:
	    break;
	}
      }
    }
  OUTPUT:
    RETVAL