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

#define FILTER_ORDER 27

//number of bits to shift to produce 16bit output=> 9 calculated from ceiling(log2(sum(B)))
#define P_BITS 2

DSK6713_AIC23_CodecHandle hCodec;							// Codec handle
DSK6713_AIC23_Config config = DSK6713_AIC23_DEFAULTCONFIG;  // Codec configuration with default settings

//Create storage array for signal components
short x[FILTER_ORDER] = {0};
short B_shifted[FILTER_ORDER] = {0};
short n = 0;

interrupt void serialPortRcvISR(void);

void main()
{

	DSK6713_init();		// Initialize the board support library, must be called first
    hCodec = DSK6713_AIC23_openCodec(0, &config);	// open codec and get handle

	// Configure buffered serial ports for 32 bit operation
	// This allows transfer of both right and left channels in one read/write
	MCBSP_FSETS(SPCR1, RINTM, FRM);
	MCBSP_FSETS(SPCR1, XINTM, FRM);
	MCBSP_FSETS(RCR1, RWDLEN1, 32BIT);
	MCBSP_FSETS(XCR1, XWDLEN1, 32BIT);

	// set codec sampling frequency
	DSK6713_AIC23_setFreq(hCodec, DSK6713_AIC23_FREQ_16KHZ);


	//shift filter coefficients so they obey Q-15 format
	for(n = 0; n < FILTER_ORDER; n++)
	{
		B_shifted[n] = B[n] << 8;
	}

	//initialize input buffer to 0
	for(n = 0; n < FILTER_ORDER; n++)
	{
		x[n] = 0;
	}


	// interrupt setup
	IRQ_globalDisable();			// Globally disables interrupts
	IRQ_nmiEnable();				// Enables the NMI interrupt
	IRQ_map(IRQ_EVT_RINT1,15);		// Maps an event to a physical interrupt
	IRQ_enable(IRQ_EVT_RINT1);		// Enables the event
	IRQ_globalEnable();				// Globally enables interrupts

	while(1)						// main loop - do nothing but wait for interrupts
	{
	}
}

interrupt void serialPortRcvISR()
{
	union {Uint32 combo; short channel[2];} temp;

	int out = 0;
	temp.combo = MCBSP_read(DSK6713_AIC23_DATAHANDLE);
	// Note that right channel is in temp.channel[0]
	// Note that left channel is in temp.channel[1]

	//create temporary variable of left channel for processing
	short tempF = temp.channel[1];

	//sample number tracking for circular buffer index tracking
	int i,j;
	if(n >= FILTER_ORDER)
	{
		n = 0;
	}

	x[n] = tempF;

	//Calculate filter gain
	for(i = 0; i < FILTER_ORDER; i++){
		j = n - i;
		if(j < 0){
			j += FILTER_ORDER;
		}

		//multiply each Q-15 value and convert to 16-bit number for extended precision accumulator
		out += (B_shifted[i] * x[j]) >> 15;
	}

	n++;

	//cast 32bit number as 16bits after shifting by calculated number of bits
	temp.channel[0] = (short)(out);

	MCBSP_write(DSK6713_AIC23_DATAHANDLE, temp.combo);
}

