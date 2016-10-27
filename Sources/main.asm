;*****************************************************************
;* This stationery serves as the framework for a                 *
;* user application (single file, absolute assembly application) *
;* For a more comprehensive program that                         *
;* demonstrates the more advanced functionality of this          *
;* processor, please see the demonstration applications          *
;* located in the examples subdirectory of the                   *
;* Freescale CodeWarrior for the HC12 Program directory          *
;*****************************************************************

; export symbols
            ABSENTRY Entry        ; for absolute assembly: mark this as application entry point
	        	INCLUDE 'mc9s12dp512.inc' 

ROMStart    EQU  $8000  ; absolute address to place my code/constant data


; code section
            ORG   ROMStart


Entry:

SUM EQU $4210  ;RAM loc 210H for SUM
    LDAA #$25 ;A = 25H
    ADDA #$34 ;add 34H to A (A=59H)
    ADDA #$11 ;add 11H to A (A=6AH) 
    ADDA #18  ;A = A + 12H = 7CH
    ADDA #%00011100 ;A = A + 1CH = 98H
    STAA SUM        ;save the SUM in loc 210H
HERE JMP HERE       ;infinity loop

    END

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
