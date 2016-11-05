;Author: Bill Wang
;Date: 11/05/2016 
;MY BIRTHDAY IS OCT 23
   
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
   

BACK    LDAA #$3F        ;letter o
    	  STAA PORTB
    	  LDAA #$0E        ;on the most left digit of 7-Seg
        STAA PTP
    	  JSR DELAY       ;Increase the delay to 100ms on all 4 to see what happens 
    	  
    	  LDAA #$39        
    	  STAA PORTB
    	  LDAA #$0D        
        STAA PTP
    	  JSR DELAY        
    	  
    	  LDAA #$31        
    	  STAA PORTB
    	  LDAA #$0B       
        STAA PTP
    	  JSR DELAY        
    	  
    	  LDAA #$0F        ;delay
        STAA PTP
    	  JSR DELAY        
    	  
    	  LDAA #$5B        
    	  STAA PORTB
    	  LDAA #$0E       
        STAA PTP
    	  JSR DELAY
    	  
    	  LDAA #$4F        
    	  STAA PORTB
    	  LDAA #$0D       
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
L3      LDAA    #100
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