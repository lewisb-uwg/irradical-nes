

DrawTextBox:

	LDA gameHandler
	AND #%00100000
	BEQ dodrawTextBox
	JMP dontDrawTextBox
dodrawTextBox:


   ; HideSprites
   
;;; this means that npc text is off right now
;;; so create the box and disable object updates.
    DrawBox #BOX_1_ORIGIN_X,#BOX_1_ORIGIN_Y,#BOX_1_WIDTH, #BOX_1_HEIGHT, #BOX_1_ATT_WIDTH, #BOX_1_ATT_HEIGHT, #$00, #$00, #$00
 
    
    LDA #BOX_1_ORIGIN_X
    ASL
    CLC
    ADC #$01
    STA temp
    
    LDA #BOX_1_ORIGIN_Y
    ASL
    CLC
    ADC #$01
    STA temp1
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	LDY stringTemp
	LDA screenText,y
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	STA stringGroupOffset

	
    DrawText temp, temp1
    LDA gameHandler
    ORA #%00100000
    STA gameHandler
 dontDrawTextBox:
	LDA writingText
	BEQ canPressBeBecauseNotWritingText
	JMP dontTurnOffTextBox ;; can't press b to advance or close because still writing text
canPressBeBecauseNotWritingText:
	LDA gamepad
	AND #%00000010 ;; is b button pressed when there is a textbox on the screen?
	BNE  turnOffTextBox
	JMP dontTurnOffTextBox
turnOffTextBox:
	LDA stringEnd
	BEQ dontLoadANewTextString
  DrawBox #BOX_1_ORIGIN_X,#BOX_1_ORIGIN_Y,#BOX_1_WIDTH, #BOX_1_HEIGHT, #BOX_1_ATT_WIDTH, #BOX_1_ATT_HEIGHT, #$00, #$01, #$00
	;LDA stringGroupPointer
	;ASL
	;ASL
	;CLC
	;ADC stringTemp

	;STA stringGroupOffset
	
	LDY stringTemp
	LDA screenText,y
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	STA stringGroupOffset
	
	
	LDA #BOX_1_ORIGIN_X
    ASL
    CLC
    ADC #$01
    STA temp
    
    LDA #BOX_1_ORIGIN_Y
    ASL
    CLC
    ADC #$01
    STA temp1
	
	ContinueText temp, temp1
	RTS
dontLoadANewTextString:
	
	HideBox #BOX_1_ORIGIN_X,#BOX_1_ORIGIN_Y,#BOX_1_WIDTH, #BOX_1_HEIGHT, #BOX_1_ATT_WIDTH, #BOX_1_ATT_HEIGHT
	LDA gameHandler
	AND #%11011111
	STA gameHandler
	ShowSprites
	LDA #$00
	STA textBoxFlag
	STA updateHUD_offset
dontTurnOffTextBox:
    rts

;turnOffNpcText:
;;; this means that npc text is on right now
;;; so hide the box and enable object updates.
;;; though, object updates should really be enambled at the end of 
;;; box hid, or you'll be able to move as soon as this is triggered.
 ;   HideBox #BOX_1_ORIGIN_X,#BOX_1_ORIGIN_Y,#BOX_1_WIDTH, #BOX_1_HEIGHT, #BOX_1_ATT_WIDTH, #BOX_1_ATT_HEIGHT
 ;   LDA gameHandler
  ;  AND #%11011111
   ; STA gameHandler
    ;rts