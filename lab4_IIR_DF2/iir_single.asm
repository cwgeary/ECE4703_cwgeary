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

		;; load address of intermediate coefficients into memory
		MVKL	.S1		_w_asm, A7
		MVKH	.S1		_w_asm, A7

		;; load address of global counter into memory
		MVKL	.S1		_n, A8
		MVKH	.S1		_n, A8
		LDW		.D1		*A8, A12			; copy value of global counter to register A1
		NOP				4

		;; scale input by 32768
		SHR		.S1		A4, 15, A4

		;; load address of global order into memory
		;MVKL	.S2		_NL, B5
		;MVKH	.S2		_NL, B5
		;LDW		.D2		*B5, B0
		;NOP				4

		CMPGT	.L1		A12,10,A1
	[!A1]	SUB		.L1		A12, 10, A12 		; check if counter is 0, if so, add filter order to reset
		NOP		5

		ZERO	.S2		B1				;;Zero the k value register
		ZERO	.S2		B8				;;Zero the i value register
		ZERO	.S2		B12				;;zero the sum value register
		MV		.S2x	A12, B9
		ADD		.S2		B1,10,B1
LOOP:
		SUB		.S2		B9, B5, B6		;; store difference of loop counter to register B6 (i = n - k)
		CMPLTSP	.S2		B6, B8, B2
	[!B2]	B		.S2		NO_WRAP		;;
		NOP 	5
		ADD		.S2		B6, 10, B6		;; wrap i value for circular buffer
NO_WRAP:
		MV		.S1x	B1, A9
		LDW		.D1		*++A5[A9], B7	;;load denominator coefficient value at B1 position
		NOP				4
		MV		.S1x	B6, A10
		LDW		.D1		*++A7[A10], B10;;load intermediate value at B6 position
		NOP				4

		MPYSP	.M2		B10,B7,B11		;;multiply the two
		NOP				3
		ADD		.S2		B11, B12, B12 	;;ACCUMULATE into sum register




		SUB		.S2		B1, 1, B1		;; sub one from loop counter
	[B1]	B		.S2		LOOP
		NOP		5

		SUB		.S1x	A4, B12, A11
		STW		.D1		A11, *A7[A12]

		ZERO	.S2		B1				;;Zero the k value register
		ZERO	.S2		B8				;;Zero the i value register
		ZERO	.S2		B12				;;zero the sum value register
		ADD		.S2		B1,10,B1
LOOP_2:
		SUB		.S2		B9, B5, B6		;; store difference of loop counter to register B6 (i = n - k)
		CMPLTSP	.S2		B6, B8, B2
	[!B2]	B		.S2		NO_WRAP_2		;;
		NOP		5
		ADD		.S2		B6, 10, B6		;; wrap i value for circular buffer
NO_WRAP_2:
		MV		.S1x	B1, A9
		LDW		.D1		*++A6[A9], B7	;;load denominator coefficient value at B1 position
		NOP				4
		MV		.S1x	B6, A10
		LDW		.D1		*++A7[A10], B10;;load intermediate value at B6 position
		NOP				4

		MPYSP	.M2		B10,B7,B11		;;multiply the two
		NOP				3
		ADD		.S2		B11, B12, B12 	;;ACCUMULATE into sum register




		SUB		.S2		B1, 1, B1		;; sub one from loop counter
		CMPLTSP	.S2		B1, B8, B0
	[!B0]	B		.S2		LOOP_2
		NOP		5
		ADD		.S1		A12, 1, A12
		STW		.D1		A12, *A8
		NOP		5
		SHL		.S2		B12, 15, B12	; shift sum output by 15
		MV		.S1x	B12, A4
		B		B3						; branch back to calling function
										; This function passes result in A4
		NOP		5						; Clear pipeline

		.end