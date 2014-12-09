/*************************************************************************
 *  Basic stereo loop code for C6713 DSK and AIC23 codec
 *  D. Richard Brown on 22-Aug-2011
 *  Based on code from "Real-Time Digital Signal Processing Based on TMS320C6000"
 *  by N. Kehtarnavaz and N. Kim.
 *************************************************************************/

#define CHIP_6713 1

#include <stdio.h>
#include <c6x.h>
#include <csl.h>
#include <csl_mcbsp.h>
#include <csl_irq.h>

#include "dsk6713.h"
#include "dsk6713_aic23.h"
#include "fdacoefs.h"


DSK6713_AIC23_CodecHandle hCodec;							// Codec handle
DSK6713_AIC23_Config config = DSK6713_AIC23_DEFAULTCONFIG;  // Codec configuration with default settings

//Create storage array for signal components
float w[11];
float w_asm[11];
int n = 0;

void serialPortRcvISR(void);
short iirDFII(float x_n, short N);
short iir_single(float x_asm, short N_asm);

void main()
{
	short i;
	for(i  = 0; i < 11; i++)
	{
		w[i] = 0;
		w_asm[i] = 0;
	}

	// Configure buffered serial ports for 32 bit operation
	// This allows transfer of both right and left channels in one read/write
	MCBSP_FSETS(SPCR1, RINTM, FRM);
	MCBSP_FSETS(SPCR1, XINTM, FRM);
	MCBSP_FSETS(RCR1, RWDLEN1, 32BIT);
	MCBSP_FSETS(XCR1, XWDLEN1, 32BIT);

	while(1)						// main loop - do nothing but wait for interrupts
	{
		serialPortRcvISR();
	}
}


void serialPortRcvISR()
{
	union {Uint32 combo; short channel[2];} temp;

	temp.combo = MCBSP_read(DSK6713_AIC23_DATAHANDLE);
	// Note that right channel is in temp.channel[0]
	// Note that left channel is in temp.channel[1]

//	short out = iirDFII(temp.channel[1], 11);
//	temp.channel[0] = out;

	short out1 = iir_single(temp.channel[1], 10);
	temp.channel[0] = out1;

	MCBSP_write(DSK6713_AIC23_DATAHANDLE, temp.combo);
}

