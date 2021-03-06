;ECE4703 B-term 2014
; An example of C-callable assembly functions
; original by DRB (2011) edited smj (2014)

	.def 	_iir_single  ; make label _test_asm visible to external progs
ZZZ	.equ	100		; declare constant (not necessary, just an example)
	.ref	_DEN	; refer to denminator coefficients as global
	.ref	_NUM	; refer to numerator coefficients as global
	.ref	_w_asm	; refer to intermediate value array as global
	.ref	_n		; refer to counter as global
	.ref	_NL		; refer to filter order as global
	                   ; two things get passed in:
	                   ; A4 = x_asm
	                   ; B4 = N_asm
	                   ; This code computes iir single section of order N from x_asm
	                   ; and returns the result

_iir_single:

											;; load address of denominator coefficients into memory
		MVKL	.S1		_DEN, A5
		MVKH	.S1		_DEN, A5

											;; load address of numerator coefficients into memory
		MVKL 	.S1		_NUM, A6
		MVKH	.S1		_NUM, A6

											;; load address of intermediate values into memory
		MVKL	.S1		_w_asm, A7
		MVKH	.S1		_w_asm, A7

											;; load address of global counter into memory
		MVKL	.S1		_n, A8
		MVKH	.S1		_n, A8
		LDW		.D1		*A8, A12			;;copy value of global counter to register A1
		NOP				4

											;; scale input by 32768
		SHR		.S1		A4, 15, A4

		CMPGT	.L1		A12,10,A1			;;check whether the global counter has coutned up to 12
	[A1]	SUB		.L1		A12, 11, A12 	;;check if counter is 11, if so, subtract filter order to reset
		NOP		5

		ZERO	.S2		B1					;;Zero the k value register
		ZERO	.S2		B8					;;Zero the i value register
		ZERO	.S2		B12					;;zero the sum value register
		MV		.S2x	A12, B9				;;copy global counter value to B9
		ADD		.S2		B1,1,B1				;;initialize the k counter value to 1
LOOP:
		SUB		.S2		B9, B1, B8			;;store difference (i = n - k) to register B6
		CMPLT	.L2		B8, 0, B2			;;check if the i counter has dropped below zero
	[!B2]	B		.S2		NO_WRAP			;;if i counter has dropped below zero, wrap to upper index
		NOP 	5
		ADD		.S2		B8, 11, B8			;;wrap i value for circular buffer
NO_WRAP:
		MV		.S1x	B1, A9
		LDW		.D1		*+A5[A9], B7		;;load denominator coefficient value at A9 position
		NOP		4
		MV		.S1x	B8, A10
		LDW		.D1		*+A7[A10], B10		;;load intermediate value at A10 position
		NOP		4

		MPYSP	.M2		B10,B7,B11			;;multiply the two
		NOP		3
		ADDSP	.L2		B11, B12, B12 		;;ACCUMULATE into sum register
		NOP		3

		ADD		.S2		B1, 1, B1			;;add one to loop counter
		CMPGT	.L2		B1, 10, B2			;;is loop counter greater than 10
	[!B2]	B		.S2		LOOP
		NOP		5

		SUBSP	.L1x	A4, B12, A11		;;subtract sum from current reading in A4
		NOP		3

		STW		.D1		A11, *+A7[A12]		;;store result into intermediate value
		NOP		5

;;exit first loop
		ZERO	.S2		B1					;;Zero the k value register
		ZERO	.S2		B8					;;Zero the i value register
		ZERO	.S2		B12					;;zero the sum value register
LOOP_2:
		SUB		.S2		B9, B1, B8			;;store difference (i = n - k) to register B6
		CMPLT	.L2		B8, 0, B2			;;if i < 0, wrap to top
	[!B2]	B		.S2		NO_WRAP_2		;;
		NOP		5
		ADD		.S2		B8, 11, B8			;; wrap i value for circular buffer
NO_WRAP_2:
		MV		.S1x	B1, A9
		LDW		.D1		*+A6[A9], B7		;;load denominator coefficient value at B1 position
		NOP		4
		MV		.S1x	B8, A10
		LDW		.D1		*+A7[A10], B10		;;load intermediate value at B6 position
		NOP		4

		MPYSP	.M2		B10,B7,B11			;;multiply the two
		NOP		3
		ADDSP	.L2		B11, B12, B12 		;;ACCUMULATE into sum register
		NOP		3
		ADD		.S2		B1, 1, B1			;;add one to loop counter
		CMPGT	.L2		B1, 10, B0			;;check if k > 10
	[!B0]	B		.S2		LOOP_2
		NOP		5

;;exit second loop
		ADD		.S1		A12, 1, A12			;;increment global counter
		STW		.D1		A12, *A8			;;and store at global address
		NOP		5
		SHL		.S2		B12, 15, B12		; shift sum output by 15
		MV		.S1x	B12, A4				; and move to output
		B		B3							; branch back to calling function
											; This function passes result in A4
		NOP		5							; Clear pipeline

		.end
