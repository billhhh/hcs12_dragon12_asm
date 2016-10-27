;Displaying numbers on all 7-Seg LEDs of Dragon12+ Trainer Board 
;with HCS12 Serial Monitor Program installed. This code is for CodeWarrior IDE
;On Dragon12+ board we have 4-digit common cathode 7-Seg LEDs
;PORTB drives 7-Seg LEDs (anode) See Page 24 of Dragon12+ User's Manual
;and PTP0-PTP3 provide grounds (cathode) to 7-Seg LEDs 

;Make sure you are in HCS12 Serial Monitor Mode before downloading 
;and also make sure SW7=LOAD (SW7 is 2-bit red DIP Switch on bottom right side of the board and must be 00, or LOAD) 
;Press F7 (to Make), then F5(Debug) to downLOAD,and F5 once more to start the program execution
   
        ABSENTRY Entry        ; for absolute assembly: mark this as application entry point
    
; Include derivative-specific definitions 
		INCLUDE 'mc9s12dp256.inc'     ;CPU used by Dragon12+ board
 
 
;----------------------USE $1000-$2FFF for Scratch Pad 
R1      EQU     $1001
R2      EQU     $1002
R3      EQU     $1003

;code section
        ORG   $4000     ;Flash ROM address for Dragon12+
Entry:
	      LDS     #$4000    ;Stack
        LDAA    #$FF
        STAA    DDRB		;PORTB as Output
        LDAA    #$FF
        STAA    DDRP    ;PTP as Output 
   
;-------Display numbers (2018) on all 7-Seg LEDs

BACK    LDAA #$5B        ;number 2
    	  STAA PORTB
    	  LDAA #$0E        ;on the most left digit of 7-Seg
        STAA PTP
    	  JSR DELAY       ;Increase the delay to 100ms on all 4 to see what happens 
    	  
    	  LDAA #$3F        
    	  STAA PORTB
    	  LDAA #$0D        
        STAA PTP
    	  JSR DELAY        
    	  
    	  LDAA #$06        
    	  STAA PORTB
    	  LDAA #$0B       
        STAA PTP
    	  JSR DELAY        
    	  
    	  LDAA #$7F        ;number 8
    	  STAA PORTB
    	  LDAA #$07        ;on the most right digit of 7-Seg
        STAA PTP
    	  JSR DELAY        
    	 	  
    	  
	      BRA BACK        ;Keep refreshing the 7-Seg LEDs    
  
;----------DELAY
DELAY

        PSHA		;Save Reg A on Stack
        LDAA    #100		;Change this value to see  
        STAA    R3		;how fast 7-Seg displays data 
;--1 msec delay. The Serial Monitor works at speed of 48MHz with XTAL=8MHz on Dragon12+ board
;Freq. for Instruction Clock Cycle is 24MHz (1/2 of 48Mhz). 
;(1/24MHz) x 10 Clk x240x10=1 msec. Overheads are excluded in this calculation.         
L3      LDAA    #10
        STAA    R2
L2      LDAA    #240
        STAA    R1
L1      NOP         ;1 Intruction Clk Cycle
        NOP         ;1
        NOP         ;1
        DEC     R1  ;4
        BNE     L1  ;3
        DEC     R2  ;Total Instr.Clk=10
        BNE     L2
        DEC     R3
        BNE     L3
;--------------        
        PULA			;Restore Reg A
        RTS
;-------------------

            
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry     ;Reset Vector. CPU wakes here and it is sent to start of the code at $4000