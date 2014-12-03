; ECE4703 B-term 2014
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
	LDW		.D1		*A8, A1	; copy value of global counter to register A1
	NOP		4

	;; load address of global order into memory
	MVKL	.S2		_NL, B5
	MVKH	.S2		_NL, B5
	LDW		.D2		*B5, B0
	NOP		4

	[A1] ADD	.L1x	A1, B0, A1 ; check if counter is 0, if so, add filter order to reset
	NOP		3

LOOP:
	ZERO	.L2		B5			;; zero loop counter
	ADDSP	.S2		B5, 1, B5	;; set loop counter to 1
	NOP 3
	SUB		.S2		B5, A1, B6	;; store difference of loop counter to register B6 (i = n - k)
	NOP 3

	;; continue in single.c at line 94 for conditional branch and then multiplication and addition

	MPYSP	.M1		A1,A4,A5	; A5 = A1*A4 (temp result = a*x)
	NOP		3		; wait 3 delay slots for result
	ADDSP	.L1x	A5,B4,A4	; final result = (a*x)+b
				 	; need to use "cross path" designated
					; by x to bring B4 to L1
	NOP		3		; wait 3 delay slots for result
	B		B3		; branch back to calling function
					; This function passes result in A4
	NOP		5		; Clear pipeline

	.end
