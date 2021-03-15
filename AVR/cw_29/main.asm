/*
 * cw_29.asm
 *
 *  Created: 10/7/2020 2:31:25 PM
 *   Author: student
 */ 

.macro LOAD_CONST		; argumenty MSB, LSB, number
ldi @1, low(@2)			; MSB
ldi @0, high(@2)		; LSB
.endmacro

ldi R20, 0b111111		; "0"
ldi R21, 0b110			; "1"
ldi R22, 2				; PIN 1 PORT B
OUT DDRB, R22
OUT PORTB, R22
OUT DDRD, R20
LOAD_CONST R17, R16, 250

MainLoop:
	OUT PORTD, R21
	rcall DelayInMs
	OUT PORTD, R20
	rcall DelayInMs
rjmp MainLoop


// In: R17 - MSB, R16 - LSB; R17:R16 - delay in ms --> formula R17:R16 * 1ms
DelayInMs:                              ; zwyk�a etykieta, 
    push R24
	push R25 
	mov R24, R16						; R24 - LSB
	mov R25, R17						; R25 - MSB
	LoopOneMs:
		rcall DelayOneMs
		sbiw R25:R24, 1                             
		brne LoopOneMs
	pop R25
	pop R24 
ret ;powr�t do miejsca wywo�ania 


DelayOneMs:
/* Ochrona rejestr�w */
push R24                            ; Zapis R24 na stosie
push R25                            ; Zapis R25 na stosie
ldi R25, $6                 ; MSB
ldi R24, $32                ; LSB

InnerLoop:
    nop
    sbiw R25:R24,1                 
    cp R25, R0                      ; R0 is equal to 0 during whole program
    brne InnerLoop
/* Ochrona rejestr�w */
pop R25                             ; Sciagniecie danych ze stosu do rejestru R25
pop R24                             ; Sciagniecie danych ze stosu do rejestru R24
ret                                 ;powr�t do miejsca wywo�ania


    