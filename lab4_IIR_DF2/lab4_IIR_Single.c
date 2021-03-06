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
float w[NL];
float w_asm[11];
int n = 0;

interrupt void serialPortRcvISR(void);
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

short iirDFII(float x_n, short N)
{
	//check to see if supplied order is greater than actual filter order, don't do shit if it is
	if(N > NL)
	{
		printf("Supplied Filter Order Exceeds Actual Filter Order: %d", NL);
		return 1;
	}
	else
	{
		//create variable for output
		float output = 0, sum = 0;

		//scale input to [-1, 1)
		x_n /= 32786;

		//make sure index current intermediate index never exceeds supplied order
		int k,i;
		if(n >= N)
		{
			n = 0;
		}

		//calculate output from intermediate buffer with circular indexing
		for(k = 1; k < N; k++)
		{
			i = n - k;
			if(i < 0)
			{
				i += N;
			}

			sum += DEN[k] * w[i];
		}

		//store intermediate value at current index
		w[n] = x_n - sum;

		//calculate output from current intermediate buffer index
		for(k = 0; k < N; k++)
		{
			i = n - k;
			if(i < 0)
			{
				i += N;
			}

			output += NUM[k] * w[i];
		}

		//increment circular buffer index
		n++;

		//scale output back to full range of float
		output *= 32768;

		//return 16bit output
		return (short)output;
	}

}

interrupt void serialPortRcvISR()
{
	union {Uint32 combo; short channel[2];} temp;

	temp.combo = MCBSP_read(DSK6713_AIC23_DATAHANDLE);
	// Note that right channel is in temp.channel[0]
	// Note that left channel is in temp.channel[1]

//	short out = iirDFII(temp.channel[1], 11);
//	temp.channel[0] = out;

	short out1 = iir_single(temp.channel[1], 11);
	temp.channel[0] = out1;

	MCBSP_write(DSK6713_AIC23_DATAHANDLE, temp.combo);
}

