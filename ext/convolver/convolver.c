// ext/convolver/convolver.c

#include <ruby.h>
#include "narray.h"
#include <stdio.h>

#include "arch_detector.h"
#ifdef ARCH_ARM
  #include "sse2neon.h"
#else
  #include <xmmintrin.h>
#endif

#include "narray_shared.h"
#include "convolve_raw.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

// To hold the module object
VALUE Convolver = Qnil;

/* @overload fit_kernel_backwards( fft_temp_space, kernel )
 * @!visibility private
 * Over-writes fft_temp_space at edges with a reversed copy of kernel, in such a way that
 * an FFTW3-based convolve has a result set in an easy-to-extract position later. This is
 * implemented as a native extension for convenience and speed - to do this with methods provided
 * by narray gem would take several complex steps and be inefficient.
 * @param [NArray<sfloat>] fft_temp_space target array for pre-fft copy of kernel, is over-written
 * @param [NArray] kernel must be same size or smaller than fft_temp_space in each dimension
 * @return [nil]
 */
static VALUE narray_fit_backwards( VALUE self, VALUE a, VALUE b ) {
  struct NARRAY *na_a, *na_b;
  volatile VALUE val_a, val_b;
  int target_rank, i;
  int shift_by[LARGEST_RANK];

  val_a = na_cast_object(a, NA_SFLOAT);
  GetNArray( val_a, na_a );

  val_b = na_cast_object(b, NA_SFLOAT);
  GetNArray( val_b, na_b );

  if ( na_a->rank != na_b->rank ) {
    rb_raise( rb_eArgError, "narray a must have equal rank to narray b (a rank %d, b rank %d)", na_a->rank,  na_b->rank );
  }

  if ( na_a->rank > LARGEST_RANK ) {
    rb_raise( rb_eArgError, "exceeded maximum narray rank for convolve of %d", LARGEST_RANK );
  }

  target_rank = na_a->rank;

  for ( i = 0; i < target_rank; i++ ) {
    if ( ( na_a->shape[i] - na_b->shape[i] ) < 0 ) {
      rb_raise( rb_eArgError, "no space for backward fit" );
    }
    shift_by[i] = na_b->shape[i] >> 1;
  }

  fit_backwards_raw(
    target_rank,
    na_a->shape, (float*) na_a->ptr,
    na_b->shape, (float*) na_b->ptr,
    shift_by );

  return Qnil;
}


/* @overload convolve_basic( signal, kernel )
 * Calculates convolution of an array of floats representing a signal, with a second array representing
 * a kernel. The two parameters must have the same rank. The output has same rank, its size in each dimension d is given by
 *  signal.shape[d] - kernel.shape[d] + 1
 * @param [NArray] signal must be same size or larger than kernel in each dimension
 * @param [NArray] kernel must be same size or smaller than signal in each dimension
 * @return [NArray] result of convolving signal with kernel
 */
static VALUE narray_convolve( VALUE self, VALUE a, VALUE b ) {
  struct NARRAY *na_a, *na_b, *na_c;
  volatile VALUE val_a, val_b, val_c;
  int target_rank, i;
  int target_shape[LARGEST_RANK];

  val_a = na_cast_object(a, NA_SFLOAT);
  GetNArray( val_a, na_a );

  val_b = na_cast_object(b, NA_SFLOAT);
  GetNArray( val_b, na_b );

  if ( na_a->rank != na_b->rank ) {
    rb_raise( rb_eArgError, "narray a must have equal rank to narray b (a rack %d, b rank %d)", na_a->rank,  na_b->rank );
  }

  if ( na_a->rank > LARGEST_RANK ) {
    rb_raise( rb_eArgError, "exceeded maximum narray rank for convolve of %d", LARGEST_RANK );
  }

  target_rank = na_a->rank;

  for ( i = 0; i < target_rank; i++ ) {
    target_shape[i] = na_a->shape[i] - na_b->shape[i] + 1;
    if ( target_shape[i] < 1 ) {
      rb_raise( rb_eArgError, "narray b is bigger in one or more dimensions than narray a" );
    }
  }

  val_c = na_make_object( NA_SFLOAT, target_rank, target_shape, CLASS_OF( val_a ) );
  GetNArray( val_c, na_c );

  convolve_raw(
    target_rank, na_a->shape, (float*) na_a->ptr,
    target_rank, na_b->shape, (float*) na_b->ptr,
    target_rank, target_shape, (float*) na_c->ptr );

  return val_c;
}

void Init_convolver() {
  Convolver = rb_define_module( "Convolver" );
  rb_define_singleton_method( Convolver, "convolve_basic", narray_convolve, 2 );

  // private method
  rb_define_singleton_method( Convolver, "fit_kernel_backwards", narray_fit_backwards, 2 );
}
