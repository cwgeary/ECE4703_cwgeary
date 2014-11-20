/*
 * Filter Coefficients (C Source) generated by the Filter Design and Analysis Tool
 * Generated by MATLAB(R) 8.3 and the DSP System Toolbox 8.6.
 * Generated on: 19-Nov-2014 19:31:30
 */

/*
 * Discrete-Time IIR Filter (real)
 * -------------------------------
 * Filter Structure    : Direct-Form II
 * Numerator Length    : 11
 * Denominator Length  : 11
 * Stable              : Yes
 * Linear Phase        : No
 * Arithmetic          : fixed
 * Numerator           : s16,14 -> [-2 2)
 * Denominator         : s16,12 -> [-8 8)
 * Input               : s16,15 -> [-1 1)
 * Output              : s16,9 -> [-64 64)
 * State               : s16,15 -> [-1 1)
 * Numerator Prod      : s32,29 -> [-4 4)
 * Denominator Prod    : s32,27 -> [-16 16)
 * Numerator Accum     : s40,29 -> [-1024 1024)
 * Denominator Accum   : s40,27 -> [-4096 4096)
 * Round Mode          : convergent
 * Overflow Mode       : wrap
 * Cast Before Sum     : true
 */

/* General type conversion for MATLAB generated C-code  */
//#include "tmwtypes.h"
/* 
 * Expected path to tmwtypes.h 
 * C:\Program Files\MATLAB\R2014a\extern\include\tmwtypes.h 
 */
const int NL = 11;
const short NUM[11] = {
      410,      0,  -2048,      0,   4096,      0,  -4096,      0,   2048,
        0,   -410
};
const int DL = 11;
const short DEN[11] = {
     4096,      0,  13654,      0,  19013,      0,  13646,      0,   5018,
        0,    753
};