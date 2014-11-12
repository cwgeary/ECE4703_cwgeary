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
float w[57] = {0};

interrupt void serialPortRcvISR(void);
float lordBiquad(float x, int row);

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

	float out = 0;
	temp.combo = MCBSP_read(DSK6713_AIC23_DATAHANDLE);
	// Note that right channel is in temp.channel[0]
	// Note that left channel is in temp.channel[1]

	//create temporary variable of left channel for processing
	float tempF = temp.channel[1];

	//perform scaling => [-1, 1)
	tempF /= 32768;

	int i;
	out = tempF;
	//calculate the output of each second order section and pass it to the next
	for(i = 0; i < 19; i++)
	{
		out = lordBiquad(out, i);
	}


	//rescale and output
	out *= 32768;
	temp.channel[0] = (short)out;

	MCBSP_write(DSK6713_AIC23_DATAHANDLE, temp.combo);
}

float lordBiquad(float x, int row)
{
	int i;
	float y = 0;

	//Shift the current section of the intermediate value array forward
	for(i = 1; i >= 0; i--)
	{
		w[(i+1)+(row*3)] = w[i+(row*3)]; //reference only the current subsection of the intermediate value array
	}

	//compute the current intermediate value result for this section
	w[(row*3)] = x - DEN[row][1]*w[1+(row*3)] - DEN[row][2]*w[2+(row*3)];

	//compute the current output of this section of the filter
	y = NUM[row][0]*w[0+(row*3)] + NUM[row][1]*w[1+(row*3)] + NUM[row][2]*w[2+(row*3)];

	return y;
}