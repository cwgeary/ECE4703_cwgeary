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

#define ORDER 	50		// filter order for test filter in adaptive filter algorithm
#define MU 		1 		// step size for adaptive filter algorithm

float e[ORDER];		// error buffer
float x[ORDER];		// input buffer
float b_adpt[ORDER];// adapted filter coefficients

unsigned int n = 0;	// global index for adaptive filter

DSK6713_AIC23_CodecHandle hCodec;							// Codec handle
DSK6713_AIC23_Config config = DSK6713_AIC23_DEFAULTCONFIG;  // Codec configuration with default settings

interrupt void serialPortRcvISR(void);
void init(void);

void main()
{

	DSK6713_init();		// Initialize the board support library, must be called first
    hCodec = DSK6713_AIC23_openCodec(0, &config);	// open codec and get handle

    //initialize buffers
    init();

	// Configure buffered serial ports for 32 bit operation
	// This allows transfer of both right and left channels in one read/write
	MCBSP_FSETS(SPCR1, RINTM, FRM);
	MCBSP_FSETS(SPCR1, XINTM, FRM);
	MCBSP_FSETS(RCR1, RWDLEN1, 32BIT);
	MCBSP_FSETS(XCR1, XWDLEN1, 32BIT);

	// set codec sampling frequency
	DSK6713_AIC23_setFreq(hCodec, DSK6713_AIC23_FREQ_44KHZ);

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

	float tempF, out;

	temp.combo = MCBSP_read(DSK6713_AIC23_DATAHANDLE);
	// Note that right channel is in temp.channel[0]
	// Note that left channel is in temp.channel[1]

	tempF = temp.channel[0];
	tempF /= 32768;

	int i,j, error;
	if(n >= (ORDER - 1))
	{
		n = 0;
	}

	x[n] = tempF;

	//Perform FIR Filter
	for(i = 0; i < (ORDER - 1); i++){
		j = n - i;
		if(j < 0){
			j += (ORDER - 1);
		}
		out += b_adpt[i] * x[j];
	}

	error = out - x[n];

	//perform adaptive algorithm
	for(i = 0; i < n; i++)
	{
		b_adpt[i] = b_adpt[i] - ((MU)*(error)*x[n - i]);
	}

	out *= 32768;
	temp.channel[1] = (short)out;

	n++;

	MCBSP_write(DSK6713_AIC23_DATAHANDLE, temp.combo);
}

void init(void)
{
	unsigned int i;
	for(i = 0; i < (ORDER - 1); i++)
	{
		e[i] = 0;
		x[i] = 0;
		b_adpt[i] = 1;
	}
}
