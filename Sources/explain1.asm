;Gettting Data from DIP swiches of PTH and send it to PORTB in Assembly Language for Dragon12 Plus Trainer Board 
;with HCS12 Serial Monitor Program installed. This code is for CodeWarrior IDE
;In Dragon12+ DIP switches are connected to PORTH and LEDs are to PORTB
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
        LDAA    #$0
        STAA    DDRH    ;PTH as Input 
  ;PTJ1 controls the LEDs connected to PORTB (For Dragon12+ ONLY)
        LDAA    #$FF      	
	      STAA    DDRJ   	;Make PORTJ output, (Needed by Dragon12+) 
	      LDAA    #$0
	      STAA    PTJ   	;Turn off PTJ1 to allow the LEDs on PORTB to show data (Needed by Dragon12+) 
;
;-------Get data from DIP switches connected to PORTH and send it to LEDs of PORTB

BACK    LDAA PTH        ;Get data from DIP Switches of PTH
    	  JSR DELAY       ;Optional
	      STAA PORTB      ;and send it to PORTB
	     
	      BRA BACK    
  
;----------DELAY
DELAY

        PSHA		;Save Reg A on Stack
        LDAA    #10		;Change this value to see  
        STAA    R3		;how fast LEDs shows data coming from PTH DIP switches
;--10 msec delay. The Serial Monitor works at speed of 48MHz with XTAL=8MHz on Dragon12+ board
;Freq. for Instruction Clock Cycle is 24MHz (1/2 of 48Mhz). 
;(1/24MHz) x 10 Clk x240x100=10 msec. Overheads are excluded in this calculation.         
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