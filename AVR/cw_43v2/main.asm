/*
 * cw_43v2.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */

.macro LOAD_CONST		; argumenty MSB, LSB, number
ldi @1, low(@2)			; MSB
ldi @0, high(@2)		; LSB
.endmacro


LOAD_CONST R17, R16, 9876			; divident

;*** NumberToDigits *** 
;input : Number: R16-17 
;output: Digits: R16-19 
;internals: X_R,Y_R,Q_R,R_R - see _Divide 
 
; internals 
.def Dig0=R22 ; Digits temps 
.def Dig1=R23 ;  
.def Dig2=R24 ;  
.def Dig3=R25 ; 

NumberToDigits:
	push Dig0
	push Dig1
	push Dig2
	push Dig3

	LOAD_CONST R19, R18, 1000			; divisor 1000
	rcall Divide
	mov Dig3, R18					; quotient --> Dig3

	LOAD_CONST R19, R18, 100
	rcall Divide
	mov Dig2, R18

	LOAD_CONST R19, R18, 10
	rcall Divide
	mov Dig1, R18
	
	mov Dig0, R16

	mov R16, Dig0
	mov R17, Dig1
	mov R18, Dig2
	mov R19, Dig3

	pop Dig3
	pop Dig2
	pop Dig1
	pop Dig0
ret

;*** Divide *** 
; X/Y -> Quotient,Remainder 
; Input/Output: R16-19, Internal R24-25 
 
; inputs 
.def XL=R16 ; divident   
.def XH=R17  
 
.def YL=R18 ; divisor 
.def YH=R19  
 
; outputs 
.def RL=R16 ; remainder 
.def RH=R17  
 
.def QL=R18 ; quotient 
.def QH=R19  
 
; internal 
.def QCtrL=R24 
.def QCtrH=R25 


Divide:
	push R24
	push R25
	
	clr QCtrL 
	clr QCtrH

DivideLoop:	
	cp XL, YL
	cpc XH, YH
	brlo ExitDivide
	sub XL, YL
	sbc XH, YH
	adiw QCtrH:QCtrL, 1
	rjmp DivideLoop


ExitDivide:
	mov QL, QCtrL
	mov QH, QCtrH
	pop R25
	pop R24
ret

    