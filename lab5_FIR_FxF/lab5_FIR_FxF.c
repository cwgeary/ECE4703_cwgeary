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
#include <math.h>

#include "dsk6713.h"
#include "dsk6713_aic23.h"

#include "lowpass_50.h"
#define ORDER 51

//#include "lowpass_100.h"
//#define ORDER 101

//#include "lowpass_300.h"
//#define ORDER 301

//#include "bandpass_200.h"
//#define ORDER 201

//#include "bandpass_400.h"
//#define ORDER 401

#define FFT_LENGTH 1024
#define RADIX 2
#define PI 3.14159265358979

DSK6713_AIC23_CodecHandle hCodec;							// Codec handle
DSK6713_AIC23_Config config = DSK6713_AIC23_DEFAULTCONFIG;  // Codec configuration with default settings

typedef struct {
	float re, im;
} COMPLEX;

//Create input/output buffers and flags
COMPLEX PING[FFT_LENGTH - (ORDER - 1)] = {0};
COMPLEX PONG[FFT_LENGTH - (ORDER - 1)] = {0};
char pingFlag = 1, pongFlag = 0;
char pingIndex = 0, pongIndex = 0;

//Create complex coefficient and ping/pong arrays
COMPLEX h[FFT_LENGTH] = {0};
COMPLEX pingU[FFT_LENGTH] = {0};
COMPLEX pongU[FFT_LENGTH] = {0};
COMPLEX Z[ORDER - 1] = {0};

//Create twiddle array
COMPLEX w[(FFT_LENGTH - (ORDER - 1))/RADIX];

//create output array
float output[FFT_LENGTH - (ORDER - 1)] = {0};

//create arrays containing indices for bit reversal (FFT)
short iw[FFT_LENGTH/2],ix[FFT_LENGTH];			// indices for bit reversal (these arrays are unnecessarily large)

//create other variables for ease-of-computation
float DELTA = 2.0*PI/FFT_LENGTH;
short n = 0;

//function prototypes
interrupt void serialPortRcvISR(void);
void cfftr2_dit(COMPLEX*, COMPLEX*, short);
void bitrev(COMPLEX*, short*, int);
void digitrev_index(short*, int, int);

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
	DSK6713_AIC23_setFreq(hCodec, DSK6713_AIC23_FREQ_8KHZ);

	//initialize buffers to zero
	for(n = 0; n < (FFT_LENGTH - (ORDER - 1)); n++)
	{
		PING[n].re = 0;
		PING[n].im = 0;

		PONG[n].re = 0;
		PONG[n].im = 0;

		output[n] = 0;
	}
	for(n = 0; n < FFT_LENGTH; n++)
	{
		if(n >= ORDER)
		{
			h[n].re = 0;
			h[n].im = 0;
		}
		else
		{
			h[n].re = B[n];
			h[n].im = 0;
		}

		pingU[n].re = 0;
		pingU[n].im = 0;

		pongU[n].re = 0;
		pongU[0].im = 0;
	}
	for(n = 0; n < ORDER - 1; n++){
		Z[n].re = 0;
		Z[n].im = 0;
	}

	// compute first N/2 twiddle factors
	for(n=0;n<FFT_LENGTH/RADIX;n++){
		w[n].re = cos(DELTA*n);
		w[n].im = sin(DELTA*n);		// negative imag component
	}

	for (n=0; n <FFT_LENGTH/2; n++)
	  iw[n] = -1;

	for (n=0; n<FFT_LENGTH; n++)
	  ix[n] = -1;

	digitrev_index(iw, FFT_LENGTH/RADIX, RADIX);
	bitrev(w, iw, FFT_LENGTH/RADIX);

	cfftr2_dit(h, w, FFT_LENGTH);


	// interrupt setup
	IRQ_globalDisable();			// Globally disables interrupts
	IRQ_nmiEnable();				// Enables the NMI interrupt
	IRQ_map(IRQ_EVT_RINT1,15);		// Maps an event to a physical interrupt
	IRQ_enable(IRQ_EVT_RINT1);		// Enables the event
	IRQ_globalEnable();				// Globally enables interrupts

	while(1)						// main loop - do nothing but wait for interrupts
	{
		if(pingFlag){
			for(n = 0; n < FFT_LENGTH; n++){
				if(n < (ORDER - 1)){
					pingU[n] = Z[n];
				}
				else{
					pingU[n] = PING[n - (ORDER - 1)];
				}
			}


			cfftr2_dit(pingU,w,FFT_LENGTH) ; //TI floating-pt complex FFT
			digitrev_index(ix, FFT_LENGTH, RADIX); //produces index for bitrev() X
			bitrev(pingU,ix,FFT_LENGTH); //freq scrambled->bit-reverse X
		}
		else if(pongFlag){
			for(n = 0; n < FFT_LENGTH; n++){
				if(n < (ORDER - 1)){
					pongU[n] = Z[n];
				}
				else{
					pongU[n] = PING[n - (ORDER - 1)];
				}
			}
			cfftr2_dit(pongU,w,FFT_LENGTH) ; //TI floating-pt complex FFT
			digitrev_index(ix, FFT_LENGTH, RADIX); //produces index for bitrev() X
			bitrev(pongU,ix,FFT_LENGTH); //freq scrambled->bit-reverse X
		}

	}
}

interrupt void serialPortRcvISR()
{
	union {Uint32 combo; short channel[2];} temp;

	temp.combo = MCBSP_read(DSK6713_AIC23_DATAHANDLE);
	// Note that right channel is in temp.channel[0]
	// Note that left channel is in temp.channel[1]

	if(pingFlag)
	{
		PONG[pongIndex].re = temp.channel[1];
		PONG[pongIndex].im = 0;
		pongIndex++;

		if(pongIndex >= FFT_LENGTH - (ORDER - 1))
		{
			pongFlag = 1;
			pongIndex = 0;
			pingFlag = 0;
		}
	}

	if(pongFlag)
	{
		PING[pingIndex].re = temp.channel[1];
		PING[pingIndex].im = 0;
		pingIndex++;

		if(pingIndex >= FFT_LENGTH - (ORDER - 1))
		{
			pingFlag = 1;
			pingIndex = 0;
			pongFlag = 0;
		}
	}

	MCBSP_write(DSK6713_AIC23_DATAHANDLE, temp.combo);
}

