




	LDA #$00
	STA soft2001
	JSR WaitFrame
	
	LDA #BOSSES_DEFEATED
	STA weaponsUnlocked
	
	LDA #$FF
	STA currentSong ;; to trigger the right song
	
	.include "Routines\InitializationScripts\hudVarInits.asm"
	
	LDA #%00000000 ;;sets up next nametable to the right
	STA ScrollUpdateFlag
		
	LDA #$00
	STA ResetScrollVarsFlag
	;;; this will set the first column of the second nametable.
	LDA #$00
	STA columnToUpdate
	
	LDA #$FF
	STA columnTracker
	STA collisionColumnTracker
	
	;;; delete me

	LDA #$00
	STA testVar

	LDA #$0
	STA checkForSpriteZero
	

	LDA #$00
	STA gameTimerLo		
	STA gameTimerHi		
	LDA #DayNightSpeed ;; not working right now
	STA gameTimer 		
	
	
	
	LDA #%10000000
	STA HudHandler ; make bit 7 zero to hide hud
	
	
	.include "Routines\InitializationScripts\LoadFromConstants.asm"
	
	LDA #START_ON_SCREEN
	STA continueScreen
	STA currentNametable
	STA leftNametable
	CLC
	ADC #$01
	STA secondNametable
	STA rightNametable
	;SEC
	;SBC #$02
	;STA leftNametable
	
	LDA #START_POSITION_PIX_X
	STA continuePositionX
	LDA #START_POSITION_PIX_Y
	STA continuePositionY
	

	
	
	LDA #<playerCHR
	STA temp16
	LDA #>playerCHR
	STA temp16+1
	
	LoadChrData #BANK_PLAYER_CHR, #$0, #$0, #$80
	
	LDA #PAL_GO_1
	STA newGO1Pal
	LDA #PAL_GO_2 
	STA newGO2Pal
	LDA #$00
	STA newObj1Pal
	STA newObj2Pal
	
	LoadSpritePalette newGO1Pal, newGO2Pal, newObj1Pal, newObj2Pal
	
;;; Load Start Screen:	

	LDA #$00
	STA backgroundTilesToLoad
	

	LDA #<startScreenTiles
	STA temp16
	LDA #>startScreenTiles
	STA temp16+1
	
	LoadChrData #BANK_STARTSCREEN_CHR, #$10, #$0, #$0
	LoadNametableData #$1E, NT_StartScreen, #$00, #$00, #$00
	LoadAttributeData #$1E, ATT_StartScreen, #$0, #$00
	
	
	LDA #$00
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
	LoadBackgroundPalette ;Pal_StartScreen
	
	;; load hud
;;	LoadChrData #$1d, #$1c, #$00, #$40, textTiles
	LDA #START_SCREEN_SONG
	STA currentSong
	PlaySong #START_SCREEN_SONG
	
	LDA #%00011110 ;;
	STA soft2001
