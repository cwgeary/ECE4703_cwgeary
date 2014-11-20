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

#define L 11
#define Q_25 28
#define X_25 2
#define W_25 (Q_25 - X_25)
#define OUT_25 (Q_25 - 15)

DSK6713_AIC23_CodecHandle hCodec;							// Codec handle
DSK6713_AIC23_Config config = DSK6713_AIC23_DEFAULTCONFIG;  // Codec configuration with default settings

//Create storage array for signal components
int w[11] = {0};
int n = 0;

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
	int tempF = temp.channel[1];
	tempF = tempF << (Q_25 - 16);

	int sum = 0;

	int k, i;
	if(n >= 11)
	{
		n = 0;
	}


	//calculate intermediate values

	//iterate to sum the last 18 intermediate values*A_coefficients
	for(k = 1; k<L; k++){
		i = n - k;
		if(i < 0){
			i += L;
		}
		sum += ((DEN[k] >> 1)*(w[i] >> 14));
	}
	//subtract sum from the current scaled reading
	w[n] = tempF - sum;

	//iterate to sum the current and last 18 intermediate values*B_coefficients
	for(k=0;k<L;k++){
		i = n - k;
		if(i < 0){
			i += L;
		}
		out += ((NUM[k] >> 1) * (w[i] >> 14));
	}

	n++;

	temp.channel[0] = (short)(out >> 10);

	MCBSP_write(DSK6713_AIC23_DATAHANDLE, temp.combo);
}

