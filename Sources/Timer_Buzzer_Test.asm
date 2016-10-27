;Sounding the Buzzer on PT5 using Chann 5 Timer (Output Compare option)
;PT5 of PORTT is connected to buzzer/speaker on Dragon12+ board
;Notice this is NOT using any Time Delay
;Modified from Example 9-11 HCS12 book by Mazidi & Causey for Dragon12+ board/CodeWarrior 
 
        ABSENTRY Entry        ; for absolute assembly: mark this as application entry point
    
; Include derivative-specific definitions 
		INCLUDE 'mc9s12dp256.inc'     ;CPU used by Dragon12+ board
 
 
;code section
        ORG   $4000     ;Flash ROM address for Dragon12+
Entry:
	      LDS     #$4000    ;Stack
        BSET    DDRT,%00100000     ;Make PT5 an out for Buzzer 
          
;---Sound the Buzzer by toggling PT5 pin using Timer chan 5   
 			  ;Timer Chan5 set-up
	      LDAA 	#$80			 ;if you use $90, then NO need for "BSET	TFLG1,%00100000" 
	      STAA	TSCR1			 ;at the end of this program righ above BRA OVER
	      LDAA 	#$05	    ;Prescaler=128. Change (0-7) to hear different sound
	      STAA	TSCR2			
	      BSET	TIOS,%00100000  ;Output Compare option for Channel 5	
	      LDAA 	#%00000100      ;Toggle PT5 pin option			
	      STAA	TCTL1
	      			
OVER	  LDD	  TCNT			
	      ADDD	#500			       ;Change this number to hear different sound
	      STD	  TC5            			
HERE	  BRCLR	TFLG1,mTFLG1_C5F,HERE	
	      BSET	TFLG1,%00100000  ;Clear the Chan 5 Timer flag for next round (writing HIGH will clear it). No need for this if you use TSCR1=$90	
	      BRA   OVER
 
            
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry     ;Reset Vector. CPU wakes here and it is sent to start of the code at $4000

 
 