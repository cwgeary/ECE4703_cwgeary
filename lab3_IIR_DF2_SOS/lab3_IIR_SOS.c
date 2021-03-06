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

DSK6713_AIC23_CodecHandle hCodec;							// Codec handle
DSK6713_AIC23_Config config = DSK6713_AIC23_DEFAULTCONFIG;  // Codec configuration with default settings

//Create storage array for signal components
int w[33] = {0};
int NUM_s[11][3] = {0};
int DEN_s[11][3] = {0};
short n = 0;

interrupt void serialPortRcvISR(void);
int lordBiquad(int x, int row);

void main()
{
	DSK6713_init();		// Initialize the board support library, must be called first
    hCodec = DSK6713_AIC23_openCodec(0, &config);	// open codec and get handle

    //convert coefficients to Q15 format
    short i,j;
    for(i = 0; i < 33; i++)
    {
    	w[i] = 0;
    }

    for(i = 0; i < 11; i++)
    {
    	for(j = 0; j < 3; j++)
    	{
    		NUM_s[i][j] = NUM[i][j] << 5;
    		DEN_s[i][j] = DEN[i][j] << 5;
    	}
    }

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
	short tempF = temp.channel[1];
	//scale up input value to Q-26
	int tempScaled = tempF << 11;

	int i;

	out = tempScaled;

	//reset the cyclical buffer sub-index
	if(n >= 3){
		n = 0;
	}

	//calculate the output of each second order section and pass it to the next
	for(i = 0; i < 11; i++)
	{
		out = lordBiquad(out, i);
	}
	n++;

	//downscale the output back to Q-15 and cast as a short before writing to the codec
	temp.channel[0] = (short)(out >> 11);

	MCBSP_write(DSK6713_AIC23_DATAHANDLE, temp.combo);
}

int lordBiquad(int x, int row)
{
	//reference markers for manipulating the cyclical array
	int n1,n2,n3;
	int y = 0;

	//adding n1 to the w index will shift 1 index back
	//adding n2 to the w index will shift 2 indicies back
	//adding n3 to the w index will shift 3 indices back, meaning the current index
	if(n == 0){
		n1 = 2;
		n2 = 1;
		n3 = 0;
	}
	else if(n == 1){
		n1 = 0;
		n2 = 2;
		n3 = 1;
	}
	else{
		n1 = 1;
		n2 = 0;
		n3 = 2;
	}

	//compute the current Q-15 intermediate value result for this section
	w[(row*3)+n] =
		(
			x										//input value in Q-26
			- (DEN_s[row][1]*(w[(row*3)+n1]))		//Q-11 coefficient multiplied by a Q-15 intermediary value
			- (DEN_s[row][2]*(w[(row*3)+n2]))		//Q-11 coefficient multiplied by a Q-15 intermediary value
		) >> 11;									//shift the Q-26 sum to a Q-15

	//compute the current output of this section of the filter as a sum of Q-26 values
	y = (NUM_s[row][0]*w[(row*3)+n3]) + (NUM_s[row][1]*w[(row*3)+n1]) + (NUM_s[row][2]*w[(row*3)+n2]);

	return y;
}
