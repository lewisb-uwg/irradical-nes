HandleHudData:
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	LDA textBoxFlag
	BEQ skipDoingTextBox
	JSR DrawAllSpritesOffScreen
	LDA currentBank
	STA prevBank
	LDY #$17
	JSR bankswitchY
	;LDA #$00
	;STA stringTemp
	JSR DrawTextBox
	LDY prevBank
	JSR bankswitchY
	
	
skipDoingTextBox:
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	
	
	
	LDA dummyVar
	BEQ canDoOnScreenHudUpdate
	JMP dontDoChrUpdate ;;; skip hud and chr update
canDoOnScreenHudUpdate:
	LDA writingText
	BEQ checkForUpdateOneChrTile
	JMP doDrawingText
	
checkForUpdateOneChrTile: 

	LDA updateOneChrTile
	BEQ doHudUpdates
	JMP updateChrData
;	LDA ActivateHudUpdate
;	BEQ doHudUpdates
;	JMP updateChrData
doHudUpdates:
	LDA #$00
	STA updateCHR_counter
	STA updateCHR_offset
	;STA DrawHudBytes
	LDA DrawHudBytes
	AND #%10000000 ;; first hud element.
	BNE keephandlingHud_1
	JMP SkipHandleHudElement1:
keephandlingHud_1:
	LDA #%01111111
	STA updateHUD_inverse
	LDA #BOX_0_ASSET_0_TYPE
	STA updateHUD_ASSET_TYPE
	LDA #BOX_0_ASSET_0_X
	STA updateHUD_ASSET_X
	LDA #BOX_0_ASSET_0_Y
	STA updateHUD_ASSET_Y
	LDA #BOX_0_ASSET_0_IMAGE
	STA updateHUD_IMAGE
	LDA #BOX_0_ASSET_0_BLANK
	STA updateHUD_BLANK
	LDA #BOX_0_ASSET_0_ROW
	STA updateHUD_ROW
	LDA #BOX_0_ASSET_0_COLUMN
	STA updateHUD_COLUMN
	LDA #BOX_0_ASSET_0_MAX_VALUE
	STA hudElementTilesFull
	LDA #BOX_0_ASSET_0_STRING
	STA updateHUD_STRING
	HudUpdateForNumericDisplay #BOX_0_ASSET_0_STRING
	JMP updateHud
SkipHandleHudElement1:
	LDA DrawHudBytes
	AND #%01000000
	BNE keephandlingHud_2
	JMP SkipHandleHudElement2
keephandlingHud_2:
	LDA #%10111111
	STA updateHUD_inverse
	LDA #BOX_0_ASSET_1_TYPE
	STA updateHUD_ASSET_TYPE
	LDA #BOX_0_ASSET_1_X
	STA updateHUD_ASSET_X
	LDA #BOX_0_ASSET_1_Y
	STA updateHUD_ASSET_Y
	LDA #BOX_0_ASSET_1_IMAGE
	STA updateHUD_IMAGE
	LDA #BOX_0_ASSET_1_BLANK
	STA updateHUD_BLANK
	LDA #BOX_0_ASSET_1_ROW
	STA updateHUD_ROW
	LDA #BOX_0_ASSET_1_COLUMN
	STA updateHUD_COLUMN
	LDA #BOX_0_ASSET_1_MAX_VALUE
	STA hudElementTilesFull
	LDA #BOX_0_ASSET_1_STRING
	STA updateHUD_STRING
	HudUpdateForNumericDisplay #BOX_0_ASSET_1_STRING
	JMP updateHud
SkipHandleHudElement2:

	LDA DrawHudBytes
	AND #%00100000
	BNE keephandlingHud_3
	JMP SkipHandleHudElement3
keephandlingHud_3:
	LDA #%11011111
	STA updateHUD_inverse
	LDA #BOX_0_ASSET_2_TYPE
	STA updateHUD_ASSET_TYPE
	LDA #BOX_0_ASSET_2_X
	STA updateHUD_ASSET_X
	LDA #BOX_0_ASSET_2_Y
	STA updateHUD_ASSET_Y
	LDA #BOX_0_ASSET_2_IMAGE
	STA updateHUD_IMAGE
	LDA #BOX_0_ASSET_2_BLANK
	STA updateHUD_BLANK
	LDA #BOX_0_ASSET_2_ROW
	STA updateHUD_ROW
	LDA #BOX_0_ASSET_2_COLUMN
	STA updateHUD_COLUMN
	LDA #BOX_0_ASSET_2_MAX_VALUE
	STA hudElementTilesFull
	LDA #BOX_0_ASSET_2_STRING
	STA updateHUD_STRING
	HudUpdateForNumericDisplay #BOX_0_ASSET_2_STRING
	JMP updateHud
SkipHandleHudElement3:

	LDA DrawHudBytes
	AND #%00010000
	BNE keephandlingHud_4
	JMP SkipHandleHudElement4
keephandlingHud_4:
	LDA #%11101111
	STA updateHUD_inverse
	LDA #BOX_0_ASSET_3_TYPE
	STA updateHUD_ASSET_TYPE
	LDA #BOX_0_ASSET_3_X
	STA updateHUD_ASSET_X
	LDA #BOX_0_ASSET_3_Y
	STA updateHUD_ASSET_Y
	LDA #BOX_0_ASSET_3_IMAGE
	STA updateHUD_IMAGE
	LDA #BOX_0_ASSET_3_BLANK
	STA updateHUD_BLANK
	LDA #BOX_0_ASSET_3_ROW
	STA updateHUD_ROW
	LDA #BOX_0_ASSET_3_COLUMN
	STA updateHUD_COLUMN
	LDA #BOX_0_ASSET_3_MAX_VALUE
	STA hudElementTilesFull
	LDA #BOX_0_ASSET_3_STRING
	STA updateHUD_STRING
	HudUpdateForNumericDisplay #BOX_0_ASSET_3_STRING
	JMP updateHud
SkipHandleHudElement4:

	LDA DrawHudBytes
	AND #%00001000
	BNE keephandlingHud_5
	JMP SkipHandleHudElement5
keephandlingHud_5:
	LDA #%11110111
	STA updateHUD_inverse
	LDA #BOX_0_ASSET_4_TYPE
	STA updateHUD_ASSET_TYPE
	LDA #BOX_0_ASSET_4_X
	STA updateHUD_ASSET_X
	LDA #BOX_0_ASSET_4_Y
	STA updateHUD_ASSET_Y
	LDA #BOX_0_ASSET_4_IMAGE
	STA updateHUD_IMAGE
	LDA #BOX_0_ASSET_4_BLANK
	STA updateHUD_BLANK
	LDA #BOX_0_ASSET_4_ROW
	STA updateHUD_ROW
	LDA #BOX_0_ASSET_4_COLUMN
	STA updateHUD_COLUMN
	LDA #BOX_0_ASSET_4_MAX_VALUE
	STA hudElementTilesFull
	LDA #BOX_0_ASSET_4_STRING
	STA updateHUD_STRING
	HudUpdateForNumericDisplay #BOX_0_ASSET_4_STRING
	JMP updateHud
SkipHandleHudElement5:

	LDA DrawHudBytes
	AND #%00000100
	BNE keephandlingHud_6
	JMP SkipHandleHudElement6
keephandlingHud_6:
	LDA #%11111011
	STA updateHUD_inverse
	LDA #BOX_0_ASSET_5_TYPE
	STA updateHUD_ASSET_TYPE
	LDA #BOX_0_ASSET_5_X
	STA updateHUD_ASSET_X
	LDA #BOX_0_ASSET_5_Y
	STA updateHUD_ASSET_Y
	LDA #BOX_0_ASSET_5_IMAGE
	STA updateHUD_IMAGE
	LDA #BOX_0_ASSET_5_BLANK
	STA updateHUD_BLANK
	LDA #BOX_0_ASSET_5_ROW
	STA updateHUD_ROW
	LDA #BOX_0_ASSET_5_COLUMN
	STA updateHUD_COLUMN
	LDA #BOX_0_ASSET_5_MAX_VALUE
	STA hudElementTilesFull
	LDA #BOX_0_ASSET_5_STRING
	STA updateHUD_STRING
	HudUpdateForNumericDisplay #BOX_0_ASSET_5_STRING
	JMP updateHud
SkipHandleHudElement6:
	
	LDA DrawHudBytes
	AND #%00000010
	BNE keephandlingHud_7
	JMP SkipHandleHudElement7
keephandlingHud_7:

	LDA #%11111101
	STA updateHUD_inverse
	LDA #BOX_0_ASSET_6_TYPE
	STA updateHUD_ASSET_TYPE
	LDA #BOX_0_ASSET_6_X
	STA updateHUD_ASSET_X
	LDA #BOX_0_ASSET_6_Y
	STA updateHUD_ASSET_Y
	LDA #BOX_0_ASSET_6_IMAGE
	STA updateHUD_IMAGE
	LDA #BOX_0_ASSET_6_BLANK
	STA updateHUD_BLANK
	LDA #BOX_0_ASSET_6_ROW
	STA updateHUD_ROW
	LDA #BOX_0_ASSET_6_COLUMN
	STA updateHUD_COLUMN
	LDA #BOX_0_ASSET_6_MAX_VALUE
	STA hudElementTilesFull
	LDA #BOX_0_ASSET_6_STRING
	STA updateHUD_STRING
	HudUpdateForNumericDisplay #BOX_0_ASSET_6_STRING
	JMP updateHud

SkipHandleHudElement7:

	LDA DrawHudBytes
	AND #%00000001
	BNE keephandlingHud_8
	JMP SkipHandleHudElement8
keephandlingHud_8:
	LDA #%11111110
	STA updateHUD_inverse
	LDA #BOX_0_ASSET_7_TYPE
	STA updateHUD_ASSET_TYPE
	LDA #BOX_0_ASSET_7_X
	STA updateHUD_ASSET_X
	LDA #BOX_0_ASSET_7_Y
	STA updateHUD_ASSET_Y
	LDA #BOX_0_ASSET_7_IMAGE
	STA updateHUD_IMAGE
	LDA #BOX_0_ASSET_7_BLANK
	STA updateHUD_BLANK
	LDA #BOX_0_ASSET_7_ROW
	STA updateHUD_ROW
	LDA #BOX_0_ASSET_7_COLUMN
	STA updateHUD_COLUMN
	LDA #BOX_0_ASSET_7_MAX_VALUE
	STA hudElementTilesFull
	LDA #BOX_0_ASSET_7_STRING
	STA updateHUD_STRING
	HudUpdateForNumericDisplay #BOX_0_ASSET_7_STRING
	JMP updateHud	
SkipHandleHudElement8:	
	;;;;; NO HUD TILES NEED TO BE UPDATED
	
	;; also see if there are any chrs to update.
	;; we handle this separately from tile updates
	;; due to overlapping variables
	
	JMP SkipHandleHudData
	
	

doDrawingText:

	LDA currentBank
	STA prevBank
	LDY #$17
	JSR bankswitchY
;;;;; GET POSITION TO DRAW THE NEXT LETTER
	;;; string group pointer was declared at screen load time.
	LDy stringGroupOffset
gotString_stringGroup:	
	;;;; ALSO WILL HAVE TO CHECK FOR NIGHT
	LDA stringsTableLo,y
	STA temp16
	LDA stringsTableHi,y
	STA temp16+1

	
	
	LDY updateHUD_offset
	LDA (temp16),y
	CMP #$FE
	BNE notTextLineSkip
	;; is text line skip
	LDA updateNT_pos
	CLC
	ADC #$20
	STA updateNT_pos
	LDA updateNT_pos+1
	ADC #$00
	STA updateNT_pos+1
	inc updateHUD_offset
	LDA updateHUD_offset
	STA hudTileCounter
	JMP lineJustSkipped
notTextLineSkip:
	
	CMP #$FF
	BNE notDOneWithText2
	JMP DoneWithText
notDOneWithText2:
	CMP #_MORE
	BNE notDOneWithText3
	JMP MoreText
notDOneWithText3:
	CMP #_ENDTRIGGER
	BNE notEndTrigger
	;; is an end trigger
	INC updateHUD_offset ;; get the very next value.
	LDY updateHUD_offset
	LDA (temp16),y
	STA temp
	;;;; this now has the trigger to change.
	TriggerScreen temp
	JMP DoneWithText
notEndTrigger:
	CMP #_ENDITEM 
	BNE notEndItem
	;;; gives player an item.
	INC updateHUD_offset ;; get the very next value.
	LDY updateHUD_offset
	LDA (temp16),y
	TAY
	;;; this now has the bit to flip in BOSSES DEFEATED constant.
	LDA ValToBitTable_inverse,y
	ORA weaponsUnlocked
	STA weaponsUnlocked
	TriggerScreen screenType ;; will flip the current screen type
	PlaySound #SFX_DO_TRIGGER
	JMP DoneWithText
	
notEndItem:

	CLC 
	ADC #$C0

	STA updateHUD_fire_Tile	
	LDA updateNT_pos
	CLC
	ADC updateHUD_offset
	SEC
	SBC hudTileCounter
	STA updateHUD_fire_Address_Lo
	LDA updateNT_pos+1
	STA updateHUD_fire_Address_Hi

	JMP notDoneWithText
MoreText:
	LDA #$01
	STA stringEnd
	LDA #$00 
	STA writingText

	JMP SkipHandleHudData
DoneWithText:

	LDA #$00 
	STA stringEnd
	STA writingText

	JMP SkipHandleHudData
notDoneWithText:
	inc updateHUD_offset
lineJustSkipped:
	LDY prevBank
	JSR bankswitchY
	JMP SkipHandleHudData

updateChrData:

	;LDA updateOneChrTile
	;BEQ dontDoChrUpdate
	LDA #$01
	STA updateOneChrTile
	;;;do chr update
	;; four asset type....yikes, this might be tricky.
	;; we need to replace a whole tile during the NMI.  hm.  
	LDA updateCHR_counter
	CMP #$04 ;; replace with max read.
	BNE notMaxReplaceCHR
	LDA #$00
	STA updateOneChrTile
	STA updateCHR_counter
	STA updateCHR_offset
	;LDA DrawHudBytes
	;AND updateHUD_inverse
	;STA DrawHudBytes
	JMP SkipHandleHudData
notMaxReplaceCHR:
	;;;whatever calls this has to set hudTileCounter
	;;; to the column value.

	
	LDX updateCHR_offset
	LDA HexShiftTable,x
	CLC 
	ADC #$b0  ;;;;; where do these start?
	STA updateCHR_translate
	
dontDoChrUpdate:
	RTS
	
	
	
updateHud:

	LDA updateHUD_ASSET_TYPE
	BNE notZeroHudAssetType

	
	JSR GetHudDrawPositionAndOffset

	LDA hudElementTilesMax
	CMP hudElementTilesFull
	BEQ doneWithThisHudElement
	;; not done with this element
	
	LDA player1_object
	CMP #$FF ;; this would mean he's dead.
			;;; if he's dead, fill with empty tiles.
	BEQ FinishWithBlankGraphics
	
	LDA hudElementTilesToLoad
	BEQ FinishWithBlankGraphics
	DEC hudElementTilesToLoad
	LdA updateHUD_IMAGE
	JMP gotHudElementImage
FinishWithBlankGraphics:	
	LDA updateHUD_BLANK
gotHudElementImage:
	CLC
	ADC #HUD_TILES_START
	STA updateHUD_fire_Tile
	INC updateHUD_offset
	inc hudElementTilesMax
	LDA #$01
	STA ActivateHudUpdate
	JMP SkipHandleHudData
doneWithThisHudElement:
	LDA DrawHudBytes
	AND updateHUD_inverse
	STA DrawHudBytes
	LDA #$00
	STA updateHUD_offset
	STA ActivateHudUpdate
	JMP SkipHandleHudData
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
notZeroHudAssetType:
;; do 1 and 2, but they don't have any updates mid frame.
	CMP #$03
	BEQ isAssetThreeType
	JMP notThreeHudAssetType
isAssetThreeType:
	;; is a variable value type.
;;;;;;;;;;;;;;;;;;;;;;
	
	;;;; if BOX_0_ASSET_0_MAX_VALUE is zero, then it doesn't need to fill with blanks first.
	;;;; if BOX_0_ASSET_0_MAX_VALUE is a number other than zero, it needs to fill the remainder with blanks.
	LDA #BOX_0_ORIGIN_X
	STA tileX
	LDA #BOX_0_ORIGIN_Y
	STA tileY 
	JSR coordinatesToMetaNametableValue
	;; establishes updateNT_pos and updateNT_pos+1
	;;; FIRST, IF this has been tripped, blank all of the values
	LDA updateHUD_ASSET_Y
	ASL
	ASL
	ASL
	ASL
	ASL
	CLC
	ADC updateHUD_ASSET_X
	CLC 
	ADC hudElementTilesFull
	SEC
	SBC updateHUD_offset
	SEC
	SBC #$01
	STA temp
	
	LDA updateHUD_ASSET_Y
	LSR 
	LSR
	LSR
	STA temp1
	
	LDA updateNT_pos 
	CLC
	ADC temp
	STA updateHUD_fire_Address_Lo
	LDA updateNT_pos+1
	ADC temp1
	ADC #$00
	STA updateHUD_fire_Address_Hi
;;;;;;;;;;;;;;;;;;;;;	

;;;;;;;;;;;;;;;;;;;;;;;;
	
	LDY updateHUD_offset
;;; temp16 was passed from the HudUpdateForNumericDisplay macro
	LDA (temp16),y
	CLC
	ADC #HUD_TILES_START
	CLC
	ADC #$10 ;; alphanumeric offset
	STA updateHUD_fire_Tile
	INC updateHUD_offset
	LDA updateHUD_offset
	SEC
	SBC #$01
	CMP hudElementTilesFull
	BEQ doneWithThisHudElement2
	LDA #$01
	STA ActivateHudUpdate
	JMP SkipHandleHudData
doneWithThisHudElement2
	;; if we're done...	
	LDA #$00
	STA value
	STA value+1
	STA value+2
	STA value+3
	STA value+4
	STA value+5
	STA value+6
	STA value+7

	
	LDA DrawHudBytes
	AND updateHUD_inverse
	STA DrawHudBytes
	LDA #$00
	STA updateHUD_offset
	STA ActivateHudUpdate
	
	JMP SkipHandleHudData 
	
	;;;;;;;;;;;;;;;;;;;;;;;;
	
notThreeHudAssetType:
	CMP #$04
	BNE notFourHudAssetType
	LDA #$b0
	STA hudTileCounter
	JSR updateChrData
notFourHudAssetType:
	LDA #$00
	STA ActivateHudUpdate
SkipHandleHudData:
	

	RTS
	
	
	
HandleHudData_direct:
	
	;;; READ CURRENT BOX ORIGIN VALUES AND PUSH THEM TO tileX and tileY
	LDA #BOX_0_ORIGIN_X
	STA tileX
	LDA #BOX_0_ORIGIN_Y
	STA tileY 
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	JSR coordinatesToMetaNametableValue
	;; establishes updateNT_pos and updateNT_pos+1
	;;; FIRST, IF this has been tripped, blank all of the values
	LDA updateHUD_ASSET_Y
	ASL
	ASL
	ASL
	ASL
	ASL
	CLC
	ADC updateHUD_ASSET_X
	
	STA temp
	
	LDA updateHUD_ASSET_Y
	LSR 
	LSR
	LSR
	STA temp1
	
	
	LDA #$00
	STA hudTileCounter
	
	
	
DoHandleHudDirect_Loop:	
	LDA updateNT_pos 
	SEC
	SBC hudTileCounter  ;; using this for rows / handling offset.
	CLC
	ADC updateHUD_offset
	CLC
	ADC temp
	STA updateHUD_fire_Address_Lo
	LDA updateNT_pos+1
	;CLC;
	ADC temp1
	ADC #$00
	STA updateHUD_fire_Address_Hi
	
	;;; NOW...depending on the TYPE of hud element...
	;; if this is text, it should read the text label + offset, unless that value is FF, in which case, it's done.
	LDA updateHUD_ASSET_TYPE
	CMP #$04
	BNE notVariableImage
	
	;;; this is a variable image type.
	LDA #$1f
	STA updateHUD_ROW
	LDA #$b0
	STA updateCHR_translate
	
	JSR updateChrData
	
	JMP doHudImageOrText
notVariableImage:
	CMP #$01
	BNE notStraightImage
	JMP doHudImageOrText
notStraightImage:	
	CMP #$02
	BNE notStraightHudText
doHudImageOrText:
	LDA updateHUD_POINTER
	sta temp16
	LDA updateHUD_POINTER+1
	STA temp16+1
	LDY updateHUD_offset
	LDA (temp16),y
	CMP #$FE ;; should we go down a line?
	BNE dontSkipLineInHudImageOrText
	;; do skip a line in hud image or text
	LDA updateNT_pos
	CLC
	ADC #$20
	STA updateNT_pos
	inc updateHUD_offset
	LDA updateHUD_offset
	STA hudTileCounter
	JMP DoHandleHudDirect_Loop
dontSkipLineInHudImageOrText:
	
	CMP #$FF
	BEQ doneWithThisHudElement_direct
	
	JMP gotHudElementImage_direct
notStraightHudText:
	CMP #$03
	BNE notVariableNumberValue
	;;; this is now a variable value element.
	;;; and it is going to use the max value to determine how many places to draw.

	LDA updateHUD_offset
	CMP hudElementTilesFull
	BEQ doneWithThisHudElement_direct
	;;; has not been reached.
	LDA hudElementTilesFull
	SEC 
	SBC updateHUD_offset
	SEC
	SBC #$01
	TAY
	LDA value,y
	CLC 
	ADC #$10 ;; because numbers start at position 10
	JMP gotHudElementImage_direct
	
notVariableNumberValue:
	DEC hudElementTilesFull
	LDA hudElementTilesFull
	CLC 
	ADC #$01
	BEQ doneWithThisHudElement_direct
	;; not done with this element
	LDA hudElementTilesToLoad
	BEQ FinishWithBlankGraphics_direct
	DEC hudElementTilesToLoad
	LdA updateHUD_IMAGE
	JMP gotHudElementImage_direct
FinishWithBlankGraphics_direct:	
	LDA updateHUD_BLANK
gotHudElementImage_direct:
	CLC
	ADC #HUD_TILES_START
	STA updateHUD_fire_Tile
	INC updateHUD_offset

	LDA $2002
	LDA updateHUD_fire_Address_Hi
	STA $2006
	LDA updateHUD_fire_Address_Lo
	STA $2006
	LDA updateHUD_fire_Tile
	STA $2007
	JMP DoHandleHudDirect_Loop
doneWithThisHudElement_direct:



	LDA #$00
	STA updateHUD_offset
	
	STA value
	STA value+1
	STA value+2
	STA value+3
	STA value+4
	STA value+5
	STA value+6
	STA value+7
	
	RTS
	
	
	
	
	
	
	
	
GetHudDrawPositionAndOffset:
	LDA #BOX_0_ORIGIN_X
	STA tileX
	LDA #BOX_0_ORIGIN_Y
	STA tileY 
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	JSR coordinatesToMetaNametableValue
	;; establishes updateNT_pos and updateNT_pos+1
	;;; FIRST, IF this has been tripped, blank all of the values
	LDA updateHUD_ASSET_Y
	ASL
	ASL
	ASL
	ASL
	ASL
	STA temp
	ORA updateHUD_ASSET_X
	STA temp
	
	LDA updateHUD_ASSET_Y
	LSR 
	LSR
	;LSR
	
	STA temp1
	
	LDA updateNT_pos 
	CLC
	ADC temp
	CLC
	ADC updateHUD_offset
	STA updateHUD_fire_Address_Lo
	LDA updateNT_pos+1
	ADC temp1
;ADC #$01
	STA updateHUD_fire_Address_Hi
	RTS