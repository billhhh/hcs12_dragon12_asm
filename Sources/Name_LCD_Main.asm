;Main
    
; Include derivative-specific definitions 
		  INCLUDE 'mc9s12dp256.inc'     ;CPU used by Dragon12+ board
		  		  
		  XREF DELAY
 
	
LCD_DATA	EQU PORTK		
LCD_CTRL	EQU PORTK		
RS	EQU mPORTK_BIT0	
EN	EQU mPORTK_BIT1	

;----------------------USE $1000-$2FFF for Scratch Pad 

TEMP    EQU     $1200

;code section
      ORG   $4000     ;Flash ROM address for Dragon12+
Entry:
	    LDS   #$4000    ;Stack
      
  		LDAA  #$FF
		  STAA  DDRK		
		  LDAA  #$33
		  JSR	  COMWRT4    	
  		JSR   DELAY
  		LDAA  #$32
		  JSR	  COMWRT4		
 		  JSR   DELAY
		  LDAA	#$28	
		  JSR	  COMWRT4    	
		  JSR	  DELAY   		
		  LDAA	#$0E     	
		  JSR	  COMWRT4		
		  JSR   DELAY
		  LDAA	#$01     	
		  JSR	  COMWRT4    	
		  JSR   DELAY
		  LDAA	#$06     	
		  JSR	  COMWRT4    	
		  JSR   DELAY
		  LDAA	#$80     	
		  JSR	  COMWRT4    	
		  JSR   DELAY
		  LDAA	#'Y'     	
		  JSR	  DATWRT4    	
		  JSR   DELAY
		  LDAA  #'E'     	
		  JSR	  DATWRT4 
		  JSR   DELAY
		  LDAA  #'S'     	
		  JSR	  DATWRT4 
		  JSR   DELAY
		   	
AGAIN: BRA	AGAIN      	
;----------------------------
COMWRT4:               		
		  STAA	TEMP		
		  ANDA  #$F0
		  LSRA
		  LSRA
		  STAA  LCD_DATA
		  BCLR  LCD_CTRL,RS 	
		  BSET  LCD_CTRL,EN 	
		  NOP
		  NOP
		  NOP				
		  BCLR  LCD_CTRL,EN 	
		  LDAA  TEMP
		  ANDA  #$0F
    	LSLA
    	LSLA
  		STAA  LCD_DATA
		  BCLR  LCD_CTRL,RS 	
		  BSET  LCD_CTRL,EN 	
		  NOP
		  NOP
		  NOP				
		  BCLR  LCD_CTRL,EN 	
		  RTS
;--------------		  
DATWRT4:                   	
		  STAA	 TEMP		
		  ANDA   #$F0
		  LSRA
		  LSRA
		  STAA   LCD_DATA
		  BSET   LCD_CTRL,RS 	
		  BSET   LCD_CTRL,EN 	
		  NOP
		  NOP
		  NOP				
		  BCLR   LCD_CTRL,EN 	
		  LDAA   TEMP
		  ANDA   #$0F
    	LSLA
      LSLA
  		STAA   LCD_DATA
  		BSET   LCD_CTRL,RS
		  BSET   LCD_CTRL,EN 	
		  NOP
		  NOP
		  NOP				
		  BCLR   LCD_CTRL,EN 	
		  RTS
;-------------------		  





            
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
      ORG   $FFFE
      DC.W  Entry     ;Reset Vector. CPU wakes here and it is sent to start of the code at $4000