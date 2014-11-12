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

 void serialPortRcvISR(void);

 float x[29] = {0};
 int n = 0;

void main()
{
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

		float out = 0;
		temp.combo = MCBSP_read(DSK6713_AIC23_DATAHANDLE);
		// Note that right channel is in temp.channel[0]
		// Note that left channel is in temp.channel[1]

		//temp.channel[1] = temp.channel[0];

		//create temporary variable of left channel for processing
		float tempF = temp.channel[1];

		//perform scaling => [-1, 1)
		tempF /= 32768;

		//wait for buffer to fill up with samples before filtering
		if(n<45){
			x[n] = tempF;
			n++;
		}
		else{
			//buffer is full, now perform filter
			short i;

			//shift indices to make room for current sample
			for(i = 43; i >= 0; i--){
				x[i+1] = x[i];
			}
			//store current sample in as "current sample"
			x[0] = tempF;

			//Calculate filter gain
			for(i = 0; i < 45; i++){
				out += B[i] * x[i];
			}
		}

		//rescale and output
		out *= 32768;
		temp.channel[0] = (short)out;

		MCBSP_write(DSK6713_AIC23_DATAHANDLE, temp.combo);
}

