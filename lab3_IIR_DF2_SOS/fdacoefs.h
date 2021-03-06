	/*
 * Filter Coefficients (C Source) generated by the Filter Design and Analysis Tool
 * Generated by MATLAB(R) 8.1 and the DSP System Toolbox 8.4.
 * Generated on: 18-Nov-2014 20:40:13
 */

/*
 * Discrete-Time IIR Filter (real)
 * -------------------------------
 * Filter Structure    : Direct-Form II, Second-Order Sections
 * Number of Sections  : 5
 * Stable              : Yes
 * Linear Phase        : No
 * Arithmetic          : fixed
 * Numerator           : s8,6 -> [-2 2)
 * Denominator         : s8,6 -> [-2 2)
 * Scale Values        : s8,9 -> [-2.500000e-01 2.500000e-01)
 * Input               : s16,15 -> [-1 1)
 * Section Input       : s16,12 -> [-8 8)
 * Section Output      : s16,11 -> [-16 16)
 * Output              : s16,11 -> [-16 16)
 * State               : s16,15 -> [-1 1)
 * Numerator Prod      : s24,21 -> [-4 4)
 * Denominator Prod    : s24,21 -> [-4 4)
 * Numerator Accum     : s40,21 -> [-262144 262144)
 * Denominator Accum   : s40,21 -> [-262144 262144)
 * Round Mode          : convergent
 * Overflow Mode       : wrap
 * Cast Before Sum     : true
 */

/* General type conversion for MATLAB generated C-code  */
//#include "tmwtypes.h"
/* 
 * Expected path to tmwtypes.h 
 * C:\Program Files\MATLAB\R2013a\extern\include\tmwtypes.h 
 */
#define MWSPT_NSEC 11
const int NL[MWSPT_NSEC] = { 1,3,1,3,1,3,1,3,1,3,1 };
const char NUM[MWSPT_NSEC][3] = {
  {
     15,    0,    0 
  },
  {
     64,    0,  -64 
  },
  {
     15,    0,    0 
  },
  {
     64,    0,  -64 
  },
  {
     14,    0,    0 
  },
  {
     64,    0,  -64 
  },
  {
     14,    0,    0 
  },
  {
     64,    0,  -64 
  },
  {
     14,    0,    0 
  },
  {
     64,    0,  -64 
  },
  {
     64,    0,    0 
  }
};
const int DL[MWSPT_NSEC] = { 1,3,1,3,1,3,1,3,1,3,1 };
const char DEN[MWSPT_NSEC][3] = {
  {
     64,    0,    0 
  },
  {
     64,   29,   55 
  },
  {
     64,    0,    0 
  },
  {
     64,  -29,   55 
  },
  {
     64,    0,    0 
  },
  {
     64,   17,   42 
  },
  {
     64,    0,    0 
  },
  {
     64,  -17,   42 
  },
  {
     64,    0,    0 
  },
  {
     64,    0,   37 
  },
  {
     64,    0,    0 
  }
};
