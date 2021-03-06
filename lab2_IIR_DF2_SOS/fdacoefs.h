/*
 * Filter Coefficients (C Source) generated by the Filter Design and Analysis Tool
 * Generated by MATLAB(R) 8.1 and the Signal Processing Toolbox 6.19.
 * Generated on: 12-Nov-2014 18:12:52
 */

/*
 * Discrete-Time IIR Filter (real)
 * -------------------------------
 * Filter Structure    : Direct-Form II, Second-Order Sections
 * Number of Sections  : 5
 * Stable              : Yes
 * Linear Phase        : No
 */

/* General type conversion for MATLAB generated C-code  */
//#include "tmwtypes.h"
/* 
 * Expected path to tmwtypes.h 
 * C:\Program Files\MATLAB\R2013a\extern\include\tmwtypes.h 
 */
/*
 * Warning - Filter coefficients were truncated to fit specified data type.  
 *   The resulting response may not match generated theoretical response.
 *   Use the Filter Design & Analysis Tool to design accurate
 *   single-precision filter coefficients.
 */
#define MWSPT_NSEC 11
const int NL[MWSPT_NSEC] = { 1,3,1,3,1,3,1,3,1,3,1 };
const float NUM[MWSPT_NSEC][3] = {
  {
  0.0005674039712,              0,              0 
  },
  {
                1,8.644357149e-05,   -1.001096368 
  },
  {
                1,              0,              0 
  },
  {
                1,    2.000365019,    1.000365496 
  },
  {
                1,              0,              0 
  },
  {
                1,   -2.000311375,    1.000311613 
  },
  {
                1,              0,              0 
  },
  {
                1,   -1.999183774,   0.9991840124 
  },
  {
                1,              0,              0 
  },
  {
                1,    1.999043584,   0.9990439415 
  },
  {
                1,              0,              0 
  }
};
const int DL[MWSPT_NSEC] = { 1,3,1,3,1,3,1,3,1,3,1 };
const float DEN[MWSPT_NSEC][3] = {
  {
                1,              0,              0 
  },
  {
                1,8.326672685e-17,   0.5797671676 
  },
  {
                1,              0,              0 
  },
  {
                1,   0.2611946762,   0.6531198621 
  },
  {
                1,              0,              0 
  },
  {
                1,  -0.2611946762,   0.6531198621 
  },
  {
                1,              0,              0 
  },
  {
                1,  -0.4567240179,   0.8566188812 
  },
  {
                1,              0,              0 
  },
  {
                1,   0.4567240179,   0.8566188812 
  },
  {
                1,              0,              0 
  }
};
