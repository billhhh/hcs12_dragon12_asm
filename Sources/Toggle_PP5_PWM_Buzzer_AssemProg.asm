;Toggling PP5 to sound the buzzer using PWM (pulse width modulation) on Dragon12 Plus Trainer Board 
;The J26 jumper selection allows to SPK_SEL (speaker selection) to be PT5, PP5 (PWM chan 5) or DACB output
;When the Dragon12 board is shipped the J26 jumper is set for PT5 of PORTT speaker/buzzer selection (Default setting). 
;Because of this PT5 jumper setting you hear the speaker sound when the board is RESET
   
;This program toggles PP5 to sound the speaker/buzzer using the PWM of channel 5. 
;Modified from Example 17-13 Mazidi & Causey HCS12 book. See Chapter 17 for PWM discussion
;Written and tested by M. Mazidi

;Before you run this program MAKE SURE YOU MOVE THE JUMPER ON J26 FROM PT5 TO PP5

;AFTER YOU RUN THIS PROGRAM MAKE SURE TO MOVE THE JUMPER BACK TO PT5. 
;OTHERWISE UPON RESETING THE BOARD YOU WILL NOT HEAR THE SPEAKER/BUZZER SOUND 
   
        ABSENTRY Entry        ; for absolute assembly: mark this as application entry point
    
; Include derivative-specific definitions 
		INCLUDE 'mc9s12dp256.inc'     ;CPU used by Dragon12+ board
 


;code section
        ORG   $4000     ;Flash ROM address for Dragon12+
Entry:
	      LDS     #$4000    ;Stack
       
        MOVB #$04, PWMPRCLK	 ;ClockA=Fbus/2**4=24MHz/16=1.5MHz
	      MOVB #125, PWMSCLA	 ;ClockSA=1.5MHz/2x125=1.5Mhz/250=6000Hz
	      MOVB #$20, PWMCLK	   ;Use clockSA for chan 5 PWM
	      MOVB #$20,PWMPOL		 ;high then low for polarity
	      MOVB #$0,PWMCAE		   ;left aligned
	      MOVB #$0, PWMCTL	   ;8-bit chan,pwm during feeze and wait
	      MOVB #100, PWMPER5	 ;PWM_Freq=ClockSA/100=6000 Hz/100=60 Hz. CHANGE THIS
	      MOVB #50, PWMDTY5		 ;50% duty cycle                 AND THIS TO GET DIFFERENT SOUND
	      MOVB #0,PWMCNT5		   ;start the counter with zero (optional)
	      BSET PWME,%00100000  ;enable chan 5 PWM
	      BRA $

        
            
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry     ;Reset Vector. CPU wakes here and it is sent to start of the code at $4000



