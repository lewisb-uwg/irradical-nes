
;;;;;;;;;;;;;;;;;;  MACROS
MACRO CallWriteVerify
	ENDM
	
MACRO CallEraseSector
	JSR (FlashRamPage+(EraseSector-WriteVerify))
	ENDM
	
MACRO CallWriteByte
	JSR (FlashRamPage+(WriteByte-WriteVerify))
	ENDM
	
MACRO JmpExitBank
	JMP (FlashRamPage+(ReturnToBank-WriteVerify))
	ENDM

MACRO ChangeBank arg1
	LDA currentBank
	STA prevBank
	LDY arg1
	JSR bankswitchY
	ENDM
	
MACRO ReturnToPrevBank
	LDY prevBank
	JSR bankswitchY
	ENDM

MACRO ChangeTile arg0, arg1
	;; arg0 - new collion type
	;; arg1 - starting tile number of new metatile
	LDA arg0
	STA collisionTable,y
	JSR ConvertCollisionToNT
	LDA arg1
	STA updateTile_00
	LDA arg1
	CLC
	ADC #$01
	STA updateTile_01
	LDA arg1
	CLC
	ADC #$10
	STA updateTile_02
	LDA arg1
	CLC
	ADC #$11
	STA updateTile_03
	JSR HandleUpdateNametable
	ENDM
	
MACRO ChangeTileAtCollision arg0, arg1
	;; arg0 - new collision type
	;; arg1 - starting tile number of new metatile.
	
	JSR GetTileAtPosition
	TAY
	LDA arg0
	STA collisionTable,y
	;;;;; this will change the graphics
	
	JSR ConvertCollisionToNT
	LDA arg1
	STA updateTile_00
	LDA arg1
	CLC
	ADC #$01
	STA updateTile_01
	LDA arg1
	CLC
	ADC #$10
	STA updateTile_02
	LDA arg1
	CLC
	ADC #$11
	STA updateTile_03
	JSR HandleUpdateNametable

	ENDM
	

	
MACRO LoadChrData arg0, arg1, arg2, arg3, arg4
	;;arg 0 is what bank to draw from
	 ;; arg1 feeds what 'row' the pattern table will load to
	;; arg2 feeds what 'column'.  it must end in zero (be a multiple of 16)
	;; arg3 feeds how many tiles load.
	;; arg4 tiles to load - from table.
	
	LDA arg0
	STA tempBank
	LDA arg1
	STA temp
	LDA arg2
	STA temp3
	LDA arg3
	STA TilesToLoad
	
	;LDA #$00
	;STA temp3
	
	;LDA #<arg4
	;STA temp16
	;LDA #>arg4
	;STA temp16+1
	JSR LoadChrRam
	ENDM

	
MACRO StartMoving arg0, arg1
	; arg0 object to move
	; arg1 direction
	
	;; This macro uses the built in physics found in default physics scripts.
	;; Which observes acceleratoin and deceleration as long as bounds and tile collision.
	;; It is not a direct movement, but rather turns on a check for whether or not
	;; the object should move.
	
	;; Keep in mind, this does not alter the facing-direction of the object, just
	;; the actual motion.
	
	;constant definitions for direction are:
		;MOVE_RIGHT	= #%11000000
		;MOVE_LEFT 	= #%10000000
		;MOVE_DOWN	= #%00110000
		;MOVE_UP	= #%00100000
		;               +--------Bit 7 is yes or no to h movement
		;				 +----------- if 1, bit 6 is L (0) or R (1)
		;                 +------Bit 5 is yes or no to v movement
		;                  +--------- if 1, bit 4 is U (0) or D (1)
		;DIAGONALS:
		;MOVE_RIGHT_DOWN = #%11110000
		;MOVE_LEFT_DOWN  = #%10110000
		;MOVE_RIGHT_UP	 = #%11100000
		;MOVE_LEFT_UP	 = #%10100000
		
	
	LDX arg0 ;; get the index for the desired object.
				; Most likely, this will be represented by
				; the variable player1_object.
	LDA #arg1 ;; Load the intended direction for this to move.
	STA Object_movement,x  ;; store the new movement direction to the object's
							;; movement variable.
	ENDM

	
MACRO FaceDirection arg0, arg1
	; arg0 - object to change
	; arg1 - dirction to face
	; constant definitions for facing directions are:
	;FACE_DOWN      = #%00000000
	;FACE_DOWN_RIGHT = #%00000001
	;FACE_RIGHT		= #%00000010
	;FACE_UP_RIGHT	= #%00000011
	;FACE_UP		= #%00000100
	;FACE_UP_LEFT	= #%00000101
	;FACE_LEFT		= #%00000110
	;FACE_DOWN_LEFT	= #%00000111
	LDX arg0
	LDA Object_movement,x
	AND #%11111000
	ORA #arg1
	STA Object_movement,x
	
	ENDM	
	
MACRO StopMoving arg0, arg1
	;arg 0 object to stop moving
	; arg1 stop moving which direction?
	LDX arg0
	LDA Object_movement,x
	AND #arg1
	STA Object_movement,x
	ENDM
	


MACRO ChangeToAction arg1
	LDA arg1 ; action type
	AND #%00000111
        STA ObjectActionStep,x
	ENDM
	
MACRO GetCurrentActionType arg0
	;arg1 = monster
	LDX arg0
	LDA Object_action_step,x
	AND #%00000111
	;; top 5 bits of action step are actually behavior type.
	;;; now, A holds type of action.
	
	ENDM
	
MACRO LoadBackgroundPalette arg1
	;; arg 1 = label of palette to load
	
	LDA currentBank
	STA prevBank
	LDY #BANK_PALETTES
	JSR bankswitchY
	
	;LDA #<arg1
	;STA temp16
	;LDA #>arg1
	;STA temp16+1
	
	
	LDy #$00
doLoadBckPalLoop:
	LDA (temp16),y
	STA bckPal,y
	STA bckPalFade,y
	INY
	CPY #$10
	BNE doLoadBckPalLoop
	
	LDY prevBank
	JSR bankswitchY
	
	LDA #$01
	STA updatePalettes
	ENDM 
	
	
MACRO LoadSpritePalette arg1, arg2, arg3, arg4
	;; arg 1 = low byte of address of palette to load
	;; arg 2 = high byte of address of palette to load
	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
		LDY arg1
		LDA ObjectPaletteDataLo,y
		STA temp16
		LDA ObjectPaletteDataHi,y
		STA temp16+1
	
	LDY #BANK_PALETTES
	JSR bankswitchY
	;; load the first sub palette.
	LDy #$01
	LDX #$01
doLoadSpr0PalLoop:
	LDA (temp16),y
	STA spriteSubPal_0,y
	STA spritePalFade,x
	INX
	INY
	CPY #$4
	BNE doLoadSpr0PalLoop
	
	
	LDY #$16
	JSR bankswitchY
		LDY arg2
		LDA ObjectPaletteDataLo,y
		STA temp16
		LDA ObjectPaletteDataHi,y
		STA temp16+1
	
	LDY #BANK_PALETTES
	JSR bankswitchY
	
	;INY
	INX
	LDY #$01
doLoadSprite1PalLoop:
	LDA (temp16),y
	STA spriteSubPal_1,y
	STA spritePalFade,x
	INX
	INY
	CPY #$4
	BNE doLoadSprite1PalLoop
	
	
	LDY #$16
	JSR bankswitchY
		LDY arg3
		LDA ObjectPaletteDataLo,y
		STA temp16
		LDA ObjectPaletteDataHi,y
		STA temp16+1
	
	LDY #BANK_PALETTES
	JSR bankswitchY
	;INY
	INX
	LDY #$01
doLoadSprite2PalLoop:
	LDA (temp16),y
	STA spriteSubPal_2,y
	STA spritePalFade,x
	INX
	INY
	CPY #$4
	BNE doLoadSprite2PalLoop
		
	LDY #$16
	JSR bankswitchY
		LDY arg4
		LDA ObjectPaletteDataLo,y
		STA temp16
		LDA ObjectPaletteDataHi,y
		STA temp16+1
	
	LDY #BANK_PALETTES
	JSR bankswitchY
	;INY
	INX
	LDY #$01
doLoadSprite3PalLoop:
	LDA (temp16),y
	STA spriteSubPal_3,y
	STA spritePalFade,x
	INX
	INY
	CPY #$4
	BNE doLoadSprite3PalLoop
		
	
	
donWIthSpritePal
	LDY prevBank
	JSR bankswitchY
	ENDM 
	
	
	

	
	
	
MACRO LoadNametableData arg0, arg1, arg2, arg3, arg4

;	LDA #$00
;	STA soft2001	
;	JSR WaitFrame
	;; arg0 = bank
	;; arg1 = nametable label
	;; arg2 = 8x8 or 16x16 metatiles
	;; arg3 = hud offset. 0 means no hud.
	;; arg4 = type of screen 0 = special, 1 = map1, 2= map2
	
	LDA arg1
	STA currentNameTable

	;;;;; testing a full nametable
	
	LDA #$10
	STA updateNT_columns
	STA updateNT_columnCounter
	
	LDA #$00
	STA updateNT_rowCounter
	LDA #$10
	STA updateNT_rows

	
	ChangeBank arg0   ;; go to proper bank

;;; here we look at the type, then pull from the proper table.
	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	LDA newScreen
	ASL
	TAY
	LDA arg4
	BNE notSpecialScreenNT
	;; is special screen nt.
	LDA NameTablePointers,y
	STA temp16
	LDA NameTablePointers+1,y
	STA temp16+1
	JMP GotNTIndex
notSpecialScreenNT:
	CMP #$01
	BNE notMap1NT
	LDA NameTablePointers_Map1,y
	STA temp16
	LDA NameTablePointers_Map1+1,y
	STA temp16+1
	JMP GotNTIndex
notMap1NT:
	;; is map2 nt
	LDA NameTablePointers_Map2,y
	STA temp16
	LDA NameTablePointers_Map2+1,y
	STA temp16+1
	JMP GotNTIndex
	
GotNTIndex:	
	
	
	LDY prevBank
	JSR bankswitchY
	
	

	
	
	LDA arg2
	BNE LoadingMeatiles 
	JMP Loading8x8NT
LoadingMeatiles:
	;; we're going to evalute metaTile by metaTile
	;; this doesn't need an outer and inner loop, because there will only be 
	;; (less than) 256 values.
	;; first, let's get passed the hud*****, starting at value #$40 (64)
	LDA #$20
	STA updateNT_pointer+1
	LDA arg3
	
	STA updateNT_pointer
	
	
	JSR LoadMetaTilesWithPaths
	
	
	
	JMP doneWithNametableLoad
	
	;;;; END loading meta tiles
Loading8x8NT
	LDA $2002	
	LDA #$20
	STA $2006
	LDA arg3
	STA $2006

;;;;Load nametable loop
	LDX #$04
	LDY #$00
LoadNametableLoop:
	LDA (temp16),y
	STA $2007
	INY
	BNE LoadNametableLoop
	INC temp16+1
	DEX
	BNE LoadNametableLoop
	
	
	;; handle attributes
doneWithNametableLoad:	
	;LDA #%00011110
	;STA soft2001
	ENDM

	
MACRO LoadCollisionData arg0, arg1, arg2, arg3, arg4
	
	;; arg0 = bank
	;; arg1 = address
	;; arg2 = offset.
	;; arg3 = screen type 00 = special, 01 = map1, 02 = map2
			;; generally, we would assume 'special screens' don't update collision table.
			;; this will allow us to preserve things like destuctable terrain despite
			;; jumping to, say, menu screens or shop screens or whatever.
	;; arg4 ;; collisionTable or collisionTable2
;	LDA #$00
;	STA soft2001	
;	JSR WaitFrame
	
	LDA #$F0 ;; total number of 'collision bytes possible' per screen
	SEC
	SBC arg2 ;; which should be the offset number, for mystic searches, is 20
	STA temp ;; this is the total number of collision bytes to load.  Here it would be D0.
	
	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	LDY arg1
	
	LDA arg3
	BNE notSpecialScreenCol
	;; is special screen nt.
	LDA CollisionTablesSpecialLo,y
	STA temp16
	LDA CollisionTablesSpecialHi,y
	STA temp16+1
	JMP GotCTIndex
notSpecialScreenCol:
	CMP #$01
	BNE notMap1Col
	LDA CollisionTables_Map1_Lo,y
	STA temp16
	LDA CollisionTables_Map1_Hi,y
	STA temp16+1
	JMP GotCTIndex
notMap1Col:
	;; is map2 nt
	LDA CollisionTables_Map2_Lo,y
	STA temp16
	LDA CollisionTables_Map2_Hi,y
	STA temp16+1
;	JMP GotCTIndex
	
GotCTIndex:	
	
	
	LDY prevBank
	JSR bankswitchY
	ChangeBank arg0 

	;LDA arg4
	;BNE doSecondCollisionTableLoad
	
	LDY #$00
	LDX #$00
LoadCollisionTableLoop:
	LDA (temp16),y
	LSR
	LSR
	LSR
	LSR
	STA collisionTable,x ;; the collision table in RAM
	INX
	LDA (temp16),y
	AND #%00001111
	STA collisionTable,x
	INX
	INY
	CPY #SCREEN_DATA_OFFSET
	BNE LoadCollisionTableLoop
	JMP SkipLoadingCollisionTest
	
	
;doSecondCollisionTableLoad:
;	LDY #$00
;	LDX #$00
;LoadCollisionTableLoop2:
;	LDA (temp16),y
;	LSR
;	LSR
;	LSR
;	LSR
;	STA collisionTable2,x ;; the collision table in RAM
;	INX
;	LDA (temp16),y
;	AND #%00001111
;	STA collisionTable2,x
;	INX
;	INY
;	CPY #SCREEN_DATA_OFFSET
;	BNE LoadCollisionTableLoop2
SkipLoadingCollisionTest:
.include "Routines\System\LoadScreenData.asm"
	
	;JSR updateNametable_checkForMonsters
	TXA
	PHA
	TYA
	PHA
	
	JSR DrawAllSpritesOffScreen
	JSR ResetMonsters
	JSR LoadMonsters

	PLA
	TAY
	PLA
	TAX
;	LDA #%00011110
;	STA soft2001
	
	ENDM
	
MACRO LoadAttributeData arg0, arg1, arg3, arg4
	;arg0 = bank
	;arg1 = address
	;;arg 2 - unused
	;; arg 3 = offset.  40-offset gives number of values to draw.
	;; arg 4 = screen type 00 = special screen, 01 = map 1, 02 = map2
	
	;LDA arg0
	;STA updateNT_bank
	
	LDA #$40
	sec
	sbc arg3
	STA temp
	
	
	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	LDY newScreen
	LDA arg4
	BNE notSpecialScreenAT
	;; is special screen nt.
	LDA AttributeTablesSpecialLo,y
	STA temp16
	LDA AttributeTablesSpecialHi,y
	STA temp16+1
	JMP GotATIndex
notSpecialScreenAT:
	CMP #$01
	BNE notMap1AT
	LDA AttributeTablesMainGameAboveLo,y
	STA temp16
	LDA AttributeTablesMainGameAboveHi,y
	STA temp16+1
	JMP GotATIndex
notMap1AT:
	;; is map2 nt
	LDA AttributeTablesMainGameBelowLo,y
	STA temp16
	LDA AttributeTablesMainGameBelowHi,y
	STA temp16+1
	JMP GotATIndex
	
GotATIndex:	
	
	
	LDY prevBank
	JSR bankswitchY
	
	ChangeBank arg0 
	
	LDA temp16
	STA currentAttributeTablePointer
	LDA temp16+1
	STA currentAttributeTablePointer+1
	
	;LDA #$00
	;STA soft2001
	;JSR WaitFrame
	
	
	LDA #$23
	STA $2006
	LDA #$C0
	CLC
	ADC arg3 
	STA $2006
	
	LDY #$00
LoadAttributeLoop:
	LDA (temp16),y
	STA $2007
	INY
	CPY temp 
	BNE LoadAttributeLoop
	
	;LDA #%00011110
	;STA soft2001
	
	ENDM

	
	
MACRO BeginFade arg0,arg1,arg2,arg3,arg4,arg5,arg6,arg7
	;arg0 = FADE_DARKEN or FADE_LIGHTEN
	;arg1 = fadeSpeed
	;arg2 = steps to fade out of 4
	;arg3 = loads new data 0=no, 1=yes
	;arg4 = reverse fade at end FADE_AND_HOLD = no, FADE_AND_RETURN = yes
	;arg5 = loop? FADE_ONCE = no, FADE_LOOP = yes
	;arg6 = values to fade, first set of 8
	;arg7 = values to fade, second set of 8
	

	LDA arg2
	AND #%00000011 ;; force to 4 steps, even if they accidentally put a different number
	ORA #arg0
	ORA #arg5
	ORA #%10000000
	STA fadeByte

	
	LDA arg3
	LSR
	BCC noDataLoad
	;; yes data load
	ORA #%10000000
noDataLoad:
	STA temp
	LDA arg1
	AND #%00011111 ;; force to 5 values for speed
	ORA #arg4
	ORA temp
	STA fadeSpeed
	
	LDA fadeSpeed
	AND #%00011111
	ASL
	ASL
	STA fadeTimer
	
	LDA arg6
	STA fadeSelect_bck
	LDA arg7
	STA fadeSelect_bck+1
	
	


	ENDM
	
MACRO RefreshBox

	ENDM
	
MACRO DrawBox arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8
	;arg 0 = box x origin
	;arg 1 = box y origin
	;arg 2 = box width
	;arg 3 = box height
	;arg 4 = box att width
	;arg 5 = box att height
	;arg 6 = 0= show sprites, 1 = hide sprites
	;arg 7 = just refresh the box
	;arg 8 = use textbox or just use blackout and attribute?


	
	LDA arg2
	STA updateNT_columns
	LDA arg3
	STA updateNT_rows
	LDA arg0
	STA tileX
	LDA arg1
	STA tileY
	JSR coordinatesToMetaNametableValue ;; this should be good for the rest of these routines.
	LDA arg7
	BEQ doFullBoxLoad
	JMP JustRefreshBoxArea
doFullBoxLoad:
	JSR BlackoutBoxArea
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	LDA arg4
	STA updateNT_attWidth
	LDA arg5
	STA updateNT_attHeight

	JSR UpdateAttributeTable
	LDA arg8
	BNE doFillTextBoxArea
	;; don't fill text box area, just use black
	JMP doneWithBox
JustRefreshBoxArea:
	LDA arg8
	BNE doFillTextBoxArea
	JSR BlackoutBoxArea
	JMP doneWithBox
doFillTextBoxArea:
	JSR FillBoxArea
doneWithBox:
	ENDM
	
	
MACRO HideBox arg0, arg1, arg2, arg3, arg4, arg5

;arg 0 = box x origin
	;arg 1 = box y origin
	;arg 2 = box width
	;arg 3 = box height
	;arg 4 = box att width
	;arg 5 = box att height
	LDA arg4
	STA updateNT_attWidth
	LDA arg5
	STA updateNT_attHeight
	
	LDA arg2
	STA updateNT_columns
	LDA arg3
	STA updateNT_rows
	LDA arg0
	STA tileX
	LDA arg1
	STA tileY
	JSR coordinatesToMetaNametableValue ;; this should be good for the rest of these routines.

	JSR BlackoutBoxArea
	JSR ResetAttributeTable
	JSR RestoreBoxArea
	;; turn back on sprites
	LDA gameHandler
	ORA #%10000000
	STA gameHandler
	ENDM
	

MACRO ContinueText arg0, arg1
	;; arg0 = x (in tiles)
	;; arg1 = y (in tiles)
	inc updateHUD_offset
	inc updateHUD_offset ;; one to get off the more value, one to get passed the skip line.
	LDA updateHUD_offset
	STA hudTileCounter
	
	LDA #$01
	STA writingText
	
	LDA arg0
	STA tileX
	LDA arg1
	STA tileY 
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	JSR coordinatesToNametableValue
ENDM 
	
MACRO DrawText arg0, arg1
	;; arg0 = x (in tiles)
	;; arg1 = y (in tiles)

	LDA #$00
	STA stringEnd;; sets more or whatever else might be needed at the end of the text string

	LDA #$00
	STA hudTileCounter
	STA updateHUD_offset
	LDA #$01
	STA writingText

	
	LDA arg0
	STA tileX
	LDA arg1
	STA tileY 
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	JSR coordinatesToNametableValue
	;; establishes updateNT_pos and updateNT_pos+1
	;;; FIRST, IF this has been tripped, blank all of the values
	


	ENDM
	
MACRO HideSprites
	LDA gameHandler
	AND #%01111111
	STA gameHandler
	ENDM
	
MACRO ShowSprites
	LDA gameHandler
	ORA #%10000000
	STA gameHandler
	ENDM
	
MACRO CreateObject arg0, arg1, arg2, arg3  ;; arg 3 = action step?
	
	;arg0 x value
	;arg1 y value
	;arg2 object type
	;arg3 action step - great for creating a 'spawning' effect that is non-zero
						;; or even for creating projectiles that may behave differently, where
						;; a single projectile could have 8 action types that are different, and 
						;; could load that particular action step, which could show a unique animation
						;; with specialized behaviors?  Just a thought.
						
	;; first, find a free space

	JSR FindEmptyObjectSlot
	CPX #$FF
	BEQ noFreeSlotsForNewObject
	;; we will do things like create object indirectly
	;; because they may be called from a routine that is not in the static bank
	;; which will make jumping to the animation bank and back unreliable.
	;; we will give the object it's potential X,Y, and type
	;; and give it a cued status
	LDA arg0
	STA Object_x_hi,x
	LDA arg1
	STA Object_y_hi,x
	LDA arg2
	STA Object_type,x
	;; if type = 0, set this to player
;	BNE isNotPlayerObjectType
	;; if it IS the player, we're going to set 	player1_object thi this slot (which is now x).
;	TXA
;	STA player1_object ;; now for routines involving the player
						;; there is an easy reference, to see if x = player1_object
;isNotPlayerObjectType:
	
	
	LDA #$00
	STA Object_v_speed_lo,x
	STA Object_v_speed_hi,x
	STA Object_h_speed_lo,x
	STA Object_h_speed_hi,x
	STA Object_movement,x
	
	LDA arg3
	STA Object_action_step,x	

	LDA #OBJECT_ACTIVATE
	STA Object_status,x

noFreeSlotsForNewObject:

	ENDM
	
	
MACRO DrawSprite arg0, arg1, arg2, arg3, arg4
	;arg0 = x
	;arg1 = y
	;arg2 = chr table value
	;arg3 = attribute data
	;arg3 = starting ram position
	LDA arg4
	STA temp16
	LDA #$02
	STA temp16+1
	
	LDY #$00
	
	LDA arg1
	STA (temp16),y
	INY
	LDA arg2
	STA (temp16),y
	INY 
	LDA arg3
	STA (temp16),y
	INY
	LDA arg0
	STA (temp16),y
	ENDM
	
	
MACRO GoToScreen arg0, arg1
	;; arg0 = screen number 
	;; arg1 = screen level

			LDA #%11000000
				;7 = active
				;6 = 8 or 16 px tiles
			ORA #GS_MainGame
			ORA #%01000000
			STA update_screen
			LDA arg1
			;LDA warpMap
			
			STA update_screen_details ;; load from map 1
			LDA arg0
			STA newScreen
			STA currentScreen
			LSR
			LSR
			LSR
			LSR
			LSR
			STA screenBank
			LDA #$02
			STA screen_transition_type

	LDA #$00
	STA gameHandler
		
	
	ENDM
	
	
MACRO PlaySong arg0
	;;arg0 = song index
	LDA arg0
	STA songToPlay
	LDA fireSoundByte
	ORA #%00000100
	STA fireSoundByte
	ENDM
	
MACRO PlaySound arg0
	;;arg0 = song index
	;;arg1 = priority
	LDA arg0
	STA sfxToPlay
	LDA fireSoundByte
	ORA #%00000010
	STA fireSoundByte
	ENDM
	
	
MACRO StopSound
	LDA fireSoundByte
	ORA #%00000001
	STA fireSoundByte
	ENDM
	
	
MACRO BlackOutArea arg0, arg1, arg2
	;LDA #$00
	;STA soft2001	
	;JSR WaitFrame
	;arg 0 - start hi
	;arg 1 - start lo
	;arg 2 - number of 8x8 tiles to black out
	LDA arg0
	STA $2006
	LDA arg1
	STA $2006
	LDA #BLANK_TILE
	LDY arg2
LoopBlackoutArea:
	STA $2007
	DEY
	BNE LoopBlackoutArea 
	;LDA #%00011110
	;STA soft2001
	ENDM
	

	
	
MACRO DeactivateCurrentObject
	;; will deactivate object in X
	;LDA #$FE;
	;STA Object_y_hi,x
	;LDA #$00
	;STA Object_y_lo,x
	LDA #$00
	STA Object_status,x

	STA Object_h_speed_hi,x
	STA Object_h_speed_lo,x
	STA Object_v_speed_hi,x
	STA Object_v_speed_lo,x

	ENDM
	
MACRO ChangeObjectState arg0, arg1

	;;arg1 what state to change the object to
	;;arg2 initial animation timer
	LDA Object_action_step,x
	AND #%11111000
	ora arg0

	STA Object_action_step,x
	LDA arg1
	STA Object_animation_timer,x
	LDA #$00
	STA Object_animation_frame,x
	ENDM
	
	
MACRO MoveTowardsPoint arg0, arg1, arg2, arg3, arg4
	;; arg0 = point of origin, x
	;; arg1 = poinrt of origin y
	;; arg2 = point to move towards x
	;; arg3 = point to move towards y
	
GetAngle:
	Atan2:
		LDA arg0
		SBC arg1
		bcs noEor
		eor #$ff
	noEor:
		TAX 
		rol octant

		lda arg2
		SBC arg3
		bcs noEor2
		eor #$ff
	noEor2:
		TAY 
		rol octant

		lda log2_tab,x
		sbc log2_tab,y
		bcc noEor3
		eor #$ff
	noEor3:
		tax	
		lda octant
		rol
		and #%111
		tay
		lda atan_tab,x
		eor octant_adjust,y
		;; now, loaded into a should be a value between 0 and 255
		;; this is the 'angle' towards the player from the object calling it
	
		TAY
		LDA AngleToHVelLo,y
		STA myHvel
		LDA AngleToVVelLo,y
		STA myVvel
		
	
	

	ENDM 
	
MACRO GetTrigger
		;; arg0 = screen to change, usually held in variable screenType
	TXA
	STA tempx
	TYA
	STA tempy
	
	lda screenType ;; this is the value of the screen to change.
		AND #%00000111 ;; look at last bits to know what bit to check, 0-7
		TAX
		LDA ValToBitTable_inverse,x
		STA temp
	lda screenType
	
		LSR
		LSR
		LSR 
		;;; now we have the right *byte* out of the 32 needed for 256 screen bytes
		TAY
		LDA screenTriggers,y ;; now the rigth bit is loaded into the accum
		AND temp
		
	
		
	LDX tempx
	LDY tempy
	ENDM
	
MACRO TriggerScreen arg0
	;; arg0 = screen to change, usually held in variable screenType
	TXA
	STA tempx
	TYA
	STA tempy
	
	lda arg0 ;; this is the value of the screen to change.
		AND #%00000111 ;; look at last bits to know what bit to check, 0-7
		TAX
		LDA ValToBitTable_inverse,x
		STA temp2
	lda arg0 ;; this is the value of the screen to change
	
		LSR
		LSR
		LSR 
		;;; now we have the right *byte* out of the 32 needed for 256 screen bytes
		TAY
		LDA screenTriggers,y ;; now the rigth bit is loaded into the accum
		ORA temp2
		
		STA screenTriggers,y
		
	LDX tempx
	LDY tempy
	ENDM
	
	
	
MACRO RestoreNametableAfterBox
	JSR RestoreBoxArea
	
	ENDM
	
MACRO FillBoxNametable
	JSR FillBoxArea
	ENDM
	
	
MACRO SetAttributes
	;; maybe with an attribute value?  And another being 'current att table'?
	JSR UpdateAttributeTable
	ENDM
	
MACRO RestoreAttributes
	JSR ResetAttributeTable
	ENDM
	

	
MACRO AddValue arg0, arg1, arg2, arg3
	TXA
	PHA
	;arg0 = how many places this value has.
	;arg1 = home variable
	;arg2 = amount to add 
	;arg3 = to what place?
	LDX arg0
	--:
		LDA arg1,x ;; the variable that you want to push
		STA value,x
		dex
		BPL --
	LDX arg3 ; sets the place to push.  
	LDA arg2
	JSR valueAddLoop ;value_add1 ;; will add what is in accumulator.
	;;; now value nees to be unpacked back into the variable.
	

		LDX arg0
	-:
		LDA value,x ;; the variable that you want to push
		STA arg1,x
		dex
		BPL -
	PLA
	TAX
	ENDM
	
MACRO SubtractValue arg0, arg1, arg2
	TXA
	PHA
	;arg0 = how many places this value has.
	;arg1 = home variable
	;arg2 = amount to subtract ... places?
	LDX arg0
	--:
		LDA arg1,x ;; the variable that you want to push
		STA value,x
		dex
		BPL --
	LDA arg2
	JSR value_sub1 ;; will add what is in accumulator.
	;;; now value nees to be unpacked back into the variable.
	

		LDX arg0
	-:
		LDA value,x ;; the variable that you want to push
		STA arg1,x
		dex
		BPL -
	PLA 
	TAX
	ENDM
	
MACRO LoadHudElement arg0 
	; arg 0 = which box
	; arg 1 = which element
	; arg 2 = what to feed hudElementsTileToLoad
	; arg 3 = pointer lo
	; arg 4 = pointer hi
	ENDM
	
MACRO AssignHudVariable arg0, arg1
	;arg 0 = hud variable
	;arg 1 = object index
	LDA arg1
	TAX
	LDA arg0,x
	ENDM
	
MACRO AssignHudLabel arg0
	LDA #<arg0
	STA updateHUD_POINTER
	LDA #>arg0
	STA updateHUD_POINTER+1
	ENDM
	
MACRO AssignHudVariableImage arg0, arg1
	;; arg 0 is the table
	;; arg 1 is the offset
	AssignHudLabel arg0
	
	LDA arg1
	ASL
	TAX ;; because we're using a dw word, not a db byte
	LDA arg0,x
	STA temp16
	LDA arg0+1,x
	STA temp16+1
	ENDM
	
MACRO PushVariableToValue arg0
	; arg0 = variable you want to draw the value of
	PushToValLoop:
		LDA arg0,x ;; the variable that you want to push
		STA value,x
		dex
		BPL PushToValLoop
	ENDM
	
MACRO HudUpdateForNumericDisplay arg0	
		LDA updateHUD_ASSET_TYPE
		CMP #$03
		BEQ isNumericAssetType
		JMP skipNumericAssetType

	isNumericAssetType:	
	;; this sets the update to the right variable
	LDA #<arg0
	STA temp16
	LDA #>arg0
	STA temp16+1

	skipNumericAssetType:
	ENDM	

MACRO UpdateCollisionScrollColumn arg0, arg1, arg2
	;arg0 - screen to pull from
	;arg1 - column to pull from
	;arg2 - column to update
:	
	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	LDY arg0 ;; screen to fetch
	JSR getCollisionTypeForScroll
	LDY screenBank
	JSR bankswitchY
;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;
	;;; collision table WRITES go up by 16
	;;; collision table READS only go up by 8
	;;; because collision data uses nibbles
	LDA collisionColumnTracker
	LSR ;; because y is what we'll use for reads
	TAY
	LDX collisionColumnTracker
	LDA #$0f
	STA temp
GetScrolledCollisionValueToDraw:
	LDA collisionColumnTracker
	AND #%00000001
	BNE isAnOddColumnForScrollUpdate
	;;; is an eve column for scroll update
	LDA (temp16),y
	LSR
	LSR
	LSR
	LSR
	
	STA collisionTable,x ;; the collision table in RAM
	JMP newCollisionByteIsLoaded
isAnOddColumnForScrollUpdate
	LDA (temp16),y

	AND #%00001111
	STA collisionTable,x
newCollisionByteIsLoaded:
	TXA
	CLC
	ADC #$10
	TAX
	TYA
	CLC
	ADC #$08
	TAY
	DEC temp
	LDA temp
	BEQ doneWithThisCollisionColumn
	JMP GetScrolledCollisionValueToDraw
doneWithThisCollisionColumn:
	LDY prevBank
	JSR bankswitchY
	
	

	

	
	ENDM
	
	
MACRO UpdateScrollColumn arg0, arg1, arg2
	;arg0 - screen to pull from
	;arg1 - columnToPull (what to pull from nametable)
	;arg2 - columnToUpdate (push)
			;; could be 0-63. 32-63 would be in second nametable.
			;; this probbaly doesn't even need to be determined here.
			;; it needs to be determined in/for LoadTileUpdate.asm.
	;; SET UP COLUMN LOOP

	LDA #$00
	STA rowTracker
	LDX #$00
SetScrollColumnLoop:
	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	LDA arg0
	ASL
	
	TAY ;; screen to fetch
	JSR getMapTypeForScroll
	LDY screenBank
	JSR bankswitchY
;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;
GetScrolledTileValueToDraw:
	LDA arg1
	AND #%00011111
	LSR ;; because we're using metatiles
	STA temp
	LDA rowTracker
	ASL
	ASL
	ASL
	ASL
	CLC
	ADC temp
	TAY
	LDA (temp16),y
	STA temp ;; needed for GetSingleMetaTileValues scrit
	JSR GetSingleMetaTileValues
	;; this will return updateTIle_00-03
	;;; It WILL observe paths, however since things are updating row by row,
	;;; paths will not behave as expected.  They'll all act as if they
	;;; have no surrounding paths.
	;;;;; Push updateTiles to ram variable
	LDA columnToPull
	AND #%00000001 ;; is it an odd column?
	BNE oddColumnScrollUpdate
	;; even column scroll update
	LDA updateTile_00
	STA updateColumnNT_fire_Tile,x
	INX
	LDA updateTile_02
	STA updateColumnNT_fire_Tile,x
	INX
	JMP gotUpdateColumnTiles
oddColumnScrollUpdate:
	LDA updateTile_01
	
	STA updateColumnNT_fire_Tile,x
	INX
	LDA updateTile_03
	STA updateColumnNT_fire_Tile,x
	INX
gotUpdateColumnTiles:	

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;
	CPX #$1E
	BEQ doneWithGettingColumnNT
	inc rowTracker
	JMP SetScrollColumnLoop
doneWithGettingColumnNT:
	LDY prevBank
	JSR bankswitchY
	
	LDA arg2
	STA columnToUpdate
	
	LDA #$01
	STA OverwriteNT_column
	
	
	ENDM
	
	
MACRO UpdateAttributeColumn arg0, arg1, arg2
	;arg0= screen to pull from
	;arg1= column to pull from
	;arg2 = column to write to
	LDA #$00
SetScrollColumnLoop:
	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	LDY arg0
	;; we can use columnToUpdate, divided by 4.
	JSR getAttributeTypeForScroll
	LDY screenBank
	JSR bankswitchY
	LDA columnTracker
	LSR
	LSR
	CLC
	ADC #$08
	STA temp
	LDX #$01
GetAttributeValueToDraw:
	;;TEST
	;LDA #%11111111
	;STA temp
	LDA #$00
	;LSR
	;LSR
	;CLC
	ADC temp
	TAY
	LDA (temp16),y
	STA attributeRam,x
	LDA temp
	CLC
	ADC #$08
	STA temp
	INX
	CPX #$08
	BNE GetAttributeValueToDraw
	
	LDA #$01
	STA overwriteAtt_column
	
	
	ENDM