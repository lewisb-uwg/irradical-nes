HandleScreenLoads:
	LDA update_screen
	AND #%10000000 ;; are we cued to update screen?
	BNE screenIsCued 
	JMP noNewScreen
screenIsCued:
	LDA #$00
	STA soft2001	
	JSR WaitFrame
	LDA #$01
	STA dummyVar
	

	LDA newScreen
	STA currentScreen
	
	;;; information that must be accumulated:
	;;; newGameState will become game state - it is stored in 3210 of update_screen
	;;; screen to go to is loaded into newScreen
	;;; bank is loaded into newBank
	;;; hud space is loaded into hudSpace
	;;;;;;;;;;
	
	LDA update_screen
	AND #%00001111
	STA gameState
	

	
	
	LDA update_screen_details
	BNE dontChangeScreenBank ;; keeps screen bank based on new screen.
	;; special screens use special banks.
	LDA #$1E
	STA screenBank

	JMP gotScreenBank
dontChangeScreenBank: 
	CMP #$02
	BNE gotScreenBank
	LDA screenBank
	CLC 
	ADC #$08
	STA screenBank ;; is map 2, which is just 8 banks offset from map1
gotScreenBank:

	LDA update_screen
	AND #%01000000
	BEQ isZeroTypeNametableLoad
	;; is one type nametable load
	LDA #$01
	STA nt_var
	LDA #$00
	STA update_screen_hud_offset
	JMP gotNametableLoadType
isZeroTypeNametableLoad:
	LDA #$00
	STA nt_var
	LDA #$00
	STA update_screen_hud_offset
	JMP skipLoadingCollisionTable
gotNametableLoadType:
	;; LoadScreenData
	LoadCollisionData screenBank, newScreen, update_screen_col_offset, update_screen_details, #$00
	;LDA newScreen
	;CLC
	;ADC #$01
	;STA temp2
	;LoadCollisionData screenBank, temp2, update_screen_col_offset, update_screen_details, #$01
		;; bank, screen number, where to start, screen type
		;; always loaded first, because this also loads the screen data!
skipLoadingCollisionTable:
	JSR WaitFrame
	LoadNametableData screenBank, newScreen, nt_var, update_screen_hud_offset, update_screen_details
		; bank, screen number, 8 or 16, offset, screen type (read from which table)
		JSR WaitFrame
	LoadAttributeData screenBank, newScreen, update_screen_att_offset, update_screen_details
		;; bank, screen number, how many to load, offset start, type
	
	
;;===========================
;; now load graphics and palettes
;;===========================
	LDA update_screen_details
	BNE loadMainGameplayGraphics
	;;; load special screen type graphics.
	LDA newScreen
	STA backgroundTilesToLoad
	
	LDA #$1d
	STA update_screen_bck_graphics_bank
	
	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	LDX backgroundTilesToLoad
	LDA CHRAddressLo,x
	STA temp16
	LDA CHRAddressHi,x
	STA temp16+1
	LDY prevBank
	JSR bankswitchY

	LoadChrData update_screen_bck_graphics_bank, #$10, #$0, #$0
	
	LDA newScreen
	STA newPal
	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	LDX newPal
	LDA SpecialBackPalLo,x
	STA temp16
	LDA SpecialBackPalHi,x
	STA temp16+1
	LDY prevBank
	JSR bankswitchY
	LoadBackgroundPalette 

	JMP DoneWithThisScreenLoad
	
;;=============================================
;===========MAIN GAME SCREEN LOAD
loadMainGameplayGraphics:
	;;;; let's set up the under tiles.
	LDA currentBank
	STA prevBank
	LDY #$14
	JSR bankswitchY
	JSR LoadUnderTiles
	LDY prevBank
	JSR bankswitchY
			
 
    ;;; this gives us the "number" of tiles to update.
    ;; it will update one per frame, and
    ;; should not collide with updating tiles.
	;;;;;;;;;;;;;;;;
	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	LDX newPal
	LDA GameBckPalLo,x
	STA temp16
	LDA GameBckPalHi,x
	STA temp16+1
	LDY prevBank
	JSR bankswitchY
	
	LoadBackgroundPalette ;BckPal00 ;; we need to get this from screen info



	LDA graphicsBank
	STA update_screen_bck_graphics_bank

	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	LDX backgroundTilesToLoad   ;; we get background tiles to load from screen info. 
	LDA #BckCHRAddLo,x
	STA temp16
	LDA #BckCHRAddHi,x
	STA temp16+1
	LDY prevBank
	JSR bankswitchY	
	;;; load graphics for new screen

	LoadChrData update_screen_bck_graphics_bank, #$10, #$00, #$60
	

	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	
	LDX screenSpecificTilesToLoad   ;; we get background tiles to load from screen info. 
	;LDX #$00
	LDA #BckSSChrAddLo,x
	STA temp16
	LDA #BckSSChrAddHi,x
	STA temp16+1
	LDY prevBank
	JSR bankswitchY
	
	;;; load graphics for new screen

	LoadChrData update_screen_bck_graphics_bank, #$16, #$00, #$20
	
	
	;;=====================NOW LOAD THE PATHS
	; path 0 gets loaded into row 18
	; path 1 gets laoded into row 19
	; path 2 gets loaded into row 1a
	; path 3 gets loaded into row 1b
	
	
	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	
	LDX pathTile00   ;; we get background tiles to load from screen info. 
	;LDX #$00
	LDA #PathCHRAddLo,x
	STA temp16
	LDA #PathCHRAddHi,x
	STA temp16+1
	LDY prevBank
	JSR bankswitchY
	
	;;; load graphics for new screen

	LoadChrData update_screen_bck_graphics_bank, #$18, #$00, #$10
	
	
	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	
	LDX pathTile01   ;; we get background tiles to load from screen info. 
	;LDX #$00
	LDA #PathCHRAddLo,x
	STA temp16
	LDA #PathCHRAddHi,x
	STA temp16+1
	LDY prevBank
	JSR bankswitchY
	
	;;; load graphics for new screen

	LoadChrData update_screen_bck_graphics_bank, #$19, #$00, #$10
	
	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	
	LDX pathTile02   ;; we get background tiles to load from screen info. 
	;LDX #$00
	LDA #PathCHRAddLo,x
	STA temp16
	LDA #PathCHRAddHi,x
	STA temp16+1
	LDY prevBank
	JSR bankswitchY
	
	;;; load graphics for new screen

	LoadChrData update_screen_bck_graphics_bank, #$1A, #$00, #$10
	
		LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	
	LDX pathTile03   ;; we get background tiles to load from screen info. 
	;LDX #$00
	LDA #PathCHRAddLo,x
	STA temp16
	LDA #PathCHRAddHi,x
	STA temp16+1
	LDY prevBank
	JSR bankswitchY
	
	;;; load graphics for new screen

	LoadChrData update_screen_bck_graphics_bank, #$1b, #$00, #$10
	
	;;=====================END LOAD PATHS 
	

;;===============LOAD OBJECT GRAPHICS
;;=========================================
	LDA objGraphicsBank
	STA update_screen_bck_graphics_bank
;
	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	LDX objectTilesToLoad   ;; we get background tiles to load from screen info. 
	LDA #MonsterAddressLo,x
	STA temp16
	LDA #MonsterAddressHi,x
	STA temp16+1
	LDY prevBank
	JSR bankswitchY
;	
;;; load graphics for new screen
	

	LoadChrData update_screen_bck_graphics_bank, #$08, #$00, #$80

;;==================================================================
;;=================================================================
	
	;;; load palette for new screen
	
	LoadSpritePalette newGO1Pal, newGO2Pal, newObj1Pal, newObj2Pal

	;;; load hud tiles?
	LDA #$02 
	STA backgroundTilesToLoad ;; yikes, we probably want to do something different here.
	
	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	LDX backgroundTilesToLoad
	LDA #CHRAddressLo,x
	STA temp16
	LDA #CHRAddressHi,x
	STA temp16+1
	LDY prevBank
	JSR bankswitchY
	
	LoadChrData #$1d, #$1c, #$00, #$40
	;;; black out hud space?
;	BlackOutArea #$20, #$00, #$80
;
	LDA HudHandler
	AND #%10000000
	BNE drawHud_GameHandler
	JMP skipDrawingHud_GameHandler
drawHud_GameHandler:
;; check to see if hud is shown.
	;; if hud is hidden, skip
	;; otherwise...
	;;; prep hud area load
	JSR WaitFrame
	
	LDA #BOX_0_WIDTH 
	STA updateNT_columns
	LDA #BOX_0_HEIGHT
	STA updateNT_rows
	LDA #BOX_0_ORIGIN_X
	STA tileX
	LDA #BOX_0_ORIGIN_Y
	STA tileY
	JSR FillBoxArea
	JSR WaitFrame
	;;;;;;;;;;;;;;;;
	;; set up attribute routine needs
	LDA #BOX_0_ORIGIN_X
	STA tileX
	LDA #BOX_0_ORIGIN_Y
	STA tileY 
	LDA #BOX_0_ATT_WIDTH
	STA updateNT_attWidth
	LDA #BOX_0_ATT_HEIGHT
	STA updateNT_attHeight
	;;;;;;;;;;;;;;;
	JSR UpdateAttributeTable
	;; first turn off drawing sprites.
	;JSR WaitFrame
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.include "Routines\System\HandleLoadHud.asm"
	.include "Routines\System\HandleScreenLoadHudDraw.asm"
skipDrawingHud_GameHandler:
	;;====================================
	LDA SongToPlay
	STA temp
	
	CMP currentSong ;; the song for this screen is same as last
	BEQ DoneWithThisScreenLoad
	; the song is different

	PlaySong temp
	LDA temp
	STA currentSong
	

	
DoneWithThisScreenLoad:	
	;; if you do not want triggers to go away
	;;; comment out this sub routine.
	;;; make this a screen bit.
	JSR updateNametable_checkForTriggers
	JSR countAllMonsters

	LDA #$00
	STA update_screen
	
	;;;
	;; if we are starting game
	;; we use the player position
	;; in the constants as the starting position.

	LDA screen_transition_type
	BNE notStartingGameTransitionType

	;; set newX and newY to the game start positions
	LDA #START_POSITION_PIX_X 
	STA newX
	LDA #START_POSITION_PIX_Y
	STA newY
	JMP doneWithScreenTransition
notStartingGameTransitionType:
	CMP #$01
	BNE notNormalScreenToScreenUpdate
	;; normal screen to screen update. 
	;; this just skips observing newX and newY load
	JMP doneWithScreenTransition
notNormalScreenToScreenUpdate:
	CMP #$02
	BNE notWarpTypeTransition
	LDX player1_object
	LDA newX
	STA Object_x_hi,x
	LDA newY
	STA Object_y_hi,x
notWarpTypeTransition:
doneWithScreenTransition:


	


	LDA gameHandler
	ORA #%10000000
	STA gameHandler
	LDA #$00 
	STA dummyVar
	LDA #%00011110
	STA soft2001
	
	
noNewScreen:
	RTS
	
	
	
	
	
	
	
updateNametable_checkForTriggers:
	TYA
	STA tempz ;; tempy is needed for the routine.
	TXA 
	STA tempx
	LDA currentBank
	LDY prevBank
	LDY #$14
	JSR bankswitchY
	
	JSR CheckForTriggers
	
	LDY tempz
	LDX tempx	
	RTS
	
updateNametable_checkForMonsters:

	TXA
	STA tempx
	TYA 
	STA tempz
	LDA currentBank
	LDY prevBank
	LDY #$14
	JSR bankswitchY
	
	JSR CheckForMonsters
	LDY tempz
	LDX tempx
	RTS	
	