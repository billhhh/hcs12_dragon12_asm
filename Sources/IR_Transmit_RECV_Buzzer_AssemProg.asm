;Using IR Transmitter/Receiver to sound the buzzer for Dragon12 Plus Trainer Board 
;PT5 of PORTT is connected to buzzer/speaker on Dragon12+ board
;This program sounds the buzzer whenever the IR receiver (IRRX) detect an object
;Put your hands in front of them and buzzer will sound. Remove your and and buzzer stops sounding. 

;On Dragon12 board the PT4 is used to turn on the Astable multivibrator (Square wave Freq generator) made of 4093 chip
;It is an active low so PT4=0 turns it on and it provides 38 KHz frequency to IR Transmitter (IRTX) 
;The IR Receiver (IRRX) is connected to PT3. So we can sample the IR receiver (PT3) as many times per second as we want (10 times per second)
;Written and tested by M. Mazidi with some input from Travis Chandler.

;MAKE SURE YOU MOVE THE JUMPERS ON J27 (IT IS ON BOTTOM LEFT OF CPU) BEFORE RUNNING THIS PROGRAM
;PUT JUMPER BETWEEN 6 AND 5 (SIDEWAY VERTICAL). ALSO PUT JUMPER BETWEEN 4 AND 5 (SIDEWAY VERTICAL)
;IF JUMPERS ARE SET PROPERLY BOTH TX AND RX LEDs ARE TURNED ON        


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
               
        
        BSET    DDRT,%00110000  ;PT4=Output for for IR Transmiter (IRTX), PT5=out for buzzer
        BCLR    DDRT,%00001000  ;PT3=Input pin for IR receiver (IRRX) 
        
  
;-------Turn on and off the Buzzer upon IR Receiver detection

        BCLR PTT,%00010000     ;PT4=0 to turn on IR Trans (IRTX)
    	  NOP
    	  NOP        
BACK   	BRCLR PTT,%00001000, BACK  ;check IR Receive (IRRX) at PT3
        LDAA PTT                   ;if high
   	    EORA #%00100000            ;toggle PT5 to sound buzzer
   	    STAA PTT
   	    JSR DELAY
   	    BRA BACK              ;Keep doing it    
  
;----------DELAY
DELAY

        PSHA		;Save Reg A on Stack
        LDAA    #100	;100 msec delay  
        STAA    R3		  
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