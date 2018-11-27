;1. iNES header

	.include "Routines\System\Header.asm"

;2. Constants and variables
	;A. First, the constants
	.include "Sound/ggsound.inc"
	.include "Routines\System\Macros.asm"
	.include "ScreenData/init.ini"
	.include "GameData/Constants.asm"


SpriteRam	  = $0200
CollisionRam  = $0300
ObjectRam 	  = $0400

userVariableRam = $0600 ;; user defined, game specific variable space.  Currently, 256 bytes capable by default.

FlashRamPage = $0700 ;; also used for a second collision table?
	

	;B. Then, the variables

	
	.include "Routines\Variables\ZP_and_vars.asm"
	
	
	.include "Routines\Variables\ObjectBytesRam.asm"
	;C. then the BANK ASSIGNMENTS
	.include "Routines\System\AssignBanks.asm"
;________________________________________
;4 The Reset
	.include "Routines\System\Reset.asm"
	
	;; initialize 
	.include "Routines\InitializationScripts\InitLoads.asm"
_____________
;Things are initialized.  Jump to the main game loop
;____________________________________________________
	LDA #$00
	STA gameState

	LDY #BANK_MUSIC
	JSR bankswitchY

	
	lda #SOUND_REGION_NTSC ;or #SOUND_REGION_PAL, or #SOUND_REGION_DENDY
    sta sound_param_byte_0
    lda #<(song_list)
    sta sound_param_word_0
    lda #>(song_list)
    sta sound_param_word_0+1
    lda #<(sfx_list)
    sta sound_param_word_1
    lda #>(sfx_list)
    sta sound_param_word_1+1
    lda #<(instrument_list)
    sta sound_param_word_2
    lda #>(instrument_list)
    sta sound_param_word_2+1
    ;lda #<dpcm_list
    ;sta sound_param_word_3
    ;lda #>dpcm_list
    ;sta sound_param_word_3+1
    jsr sound_initialize


	LDY prevBank
	JSR bankswitchY
nevermindPlaySong:
	LDA #SKIP_START_SCREEN
	BEQ dontSkipStartScreen
	;;;;
;;============================================================
	;;SKIP START SCREEN!
	;;; COMMENT THIS ALL OUT TO OBSERVE START SCREEN AGAIN
	;;; this script does the same as our "press start" function does on start screen,
	;;; except here, it does it automatically on startup
	;LDA #SKIP_START_SCREEN
	;BEQ dontSkipStartScreen
	
	LDA #STATE_START_GAME
	STA change_state
	LDA #%10000000
	STA gameHandler ;; turn sprites on
	;;;;;;;;;
	;;;;END SKIP START SCREEN!
;;============================================================	
dontSkipStartScreen:
	;PlaySong #$00
	JMP MainGameLoop
	
WaitFrame:
	
	
	inc sleeping
	sleepLoop:
		lda sleeping
		BNE sleepLoop
	
	
	RTS
	
;9 NMI
NMI:
	;first push whatever is in the accumulator to the stack
	PHA
	TXA
	PHA
	TYA
	PHA
	PHP
	
	LDA temp
	STA NMItemp
	LDA temp1
	STA NMItemp1
	LDA temp2
	STA NMItemp2
	LDA temp3
	STA NMItemp3
	LDA tempx
	STA NMItempx
	LDA tempy
	STA NMItempy
	LDA tempz
	STA NMItempz
	
	LDA updateHUD_fire_Address_Lo
	STA NMI_updateHud_AddLo
	LDA updateHUD_fire_Address_Hi
	STA NMI_updateHud_AddHi
	LDA updateHUD_fire_Tile
	STA updateHud_tile
	
	LDA temp16
	STA NMItemp16
	LDA temp16+1
	STA NMItemp16_plus_1
	
	LDA currentBank
	STA NMIcurrentBank
	LDA prevBank
	STA NMIprevBank
	LDA tempBank
	STA nmiTempBank
	
	
	LDA chrRamBank
	STA nmiChrRamBank
	
	LDA skipNMI
	BEQ doNMI
	JMP skipNMUstuff
doNMI:
	
	
	JSR GamePadCheck
	
	LDA #$00
	STA $2000
	
	LDA soft2001
	STA $2001

	
	;;;Set OAL DMA
	LDA #$00
	STA $2003
	LDA #$02
	STA $4014
	;; Load the Palette
	LDA soft2001
	BNE doUpdatePalette
	JMP dontUpdatePalette

doUpdatePalette:
	;; do palette update stuff
	.include "Routines\DataLoadScripts\LoadPalettes.asm"
doUpdateNametable: ;; for nametable changes
	.include "Routines\DataLoadScripts\LoadTileUpdate.asm"
doUpdateHud:
	.include "Routines\DataLoadScripts\LoadHudData.asm"

skipNMIupdate:	
	
dontUpdatePalette:
	;; turn back on?
	;;; maybe not always?
	;; check if loading screen?
	JMP skipSprite0Check
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;CHECK FOR SCROLL HANDLING;
	LDA checkForSpriteZero
	BEQ skipSprite0Check

;;;;; RESET PPU REGISTERS IN CASE OF CORRUPTION	
	LDA #$00
  STA $2006        
  STA $2006
;;;;;; DEFAULT TO NO SCROLL  
  LDA #$00        
  STA $2005
  STA $2005
 ;;; SPRITES MUST BE ENABLED IN ORDER FOR SPRITE 0 TRICK TO WORK 
  LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  STA $2000        ; start with nametable = 0 for status bar

  LDA #%00011110   ; enable sprites, enable background, no clipping on left side
  STA $2001

;;;; MAKE SURE TO WAIT UNTIL SPRITE 0 IS NOT HIT 
WaitNotSprite0:
  lda $2002
  and #%01000000
  bne WaitNotSprite0   
;;;; THEN WAIT UNTIL IT IS HIT.
WaitSprite0:
  lda $2002
  and #%01000000
  beq WaitSprite0      
;;;;;;;;;;;;;;;;;;;;
;;; SET X TO A VALUE OF HOW LONG TO WAIT AFTER THE HIT
;;; TO COMPLETE THE SCAN LINE BEFORE THE SCREEN SPLIT
    ldx #$14  
WaitScanline:
	dex
	bne WaitScanline
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; UPDATE THE SCROLL

skipSprite0Check:
  
	;LDA xScroll
	;STA $2005	;reset scroll values to zero
	;LDA yScroll
	;STA $2005	;reset scroll values to zero
	

	;LDA #%10010000
	;ORA showingNametable
	;STA $2000
	
		LDA $2002
	LDA #%10010000
	STA $2000
	
	bit $2002
	LDA xScroll
	STA $2005	;reset scroll values to zero
	LDA yScroll
	STA $2005	;reset scroll values to zero
	
skipNMUstuff:
	;;; still have the music player play
	;; something above corrupts nametable loads
	;; if they use paths.
	;;; it could be that an NMI fires before the screen
	;;; is fully loaded, turning on drawing again, and corrupting the write.
	;;; since paths take longer to load this makes sense.
	LDA currentBank
	STA prevBank
	LDY #BANK_MUSIC  ;; switch to music bank
	JSR bankswitchY
	soundengine_update  
	LDY prevBank
	JSR bankswitchY	


	
	DEC vBlankTimer
	INC randomSeed1
	;;return from this interrupt
	;; music player things
	
	LDA #$0
	STA sleeping

	
	LDA NMItemp
	STA temp
	LDA NMItemp1
	STA temp1
	LDA NMItemp2
	STA temp2
	LDA NMItemp3
	STA temp3
	
	LDA NMItempx
	STA tempx
	LDA NMItempy
	STA tempy
	LDA NMItempz
	STA tempz
	
	
	LDA NMI_updateHud_AddLo
	STA updateHUD_fire_Address_Lo
	LDA NMI_updateHud_AddHi
	STA updateHUD_fire_Address_Hi
	LDA updateHud_tile
	STA updateHUD_fire_Tile
	
	
	LDA NMItemp16
	STA temp16
	LDA NMItemp16_plus_1
	STA temp16+1

	LDA NMIcurrentBank
	STA currentBank
	LDA NMIprevBank
	STA prevBank
	LDA nmiTempBank
	STA tempBank
	
	LDA nmiChrRamBank
	STA chrRamBank

	PLP
	PLA
	TAY
	PLA
	TAX
	PLA
	
	
	
	RTI
	
	
MainGameLoop:
;;;;;;;;=========HANDLE FRAME TIMING	

	LDA vBlankTimer
vBlankTimerLoop:
	CMP vBlankTimer
	BEQ vBlankTimerLoop
;;;;;;==========END HANDLE FRAME TIMING	

	;; always get input.
	
	JSR HandleStateChanges
	JSR HandleScreenLoads

	;JSR HandleFadeLevels
	;JSR HandleFades
	;JSR HandleUpdateNametable

	JSR HandleMusic
		JSR HandleInput
	JSR HandleUpdateObjects
	JSR HandleRandomizing
	JSR HandleHudData
	JSR HandleGameTimer
	;JSR HandleScroll
	
	
	JMP MainGameLoop
	
	RTS	
	
;;;;;;;;;;;;;;;;;;;;;
	.include "GameData\ScriptTables.asm"
	.include "Routines\System\IncludeSystemFunctions.asm"
	.include "GameData\HUD_DEFINES.dat"

	
	
	
columnTableLo:
	.db #$00, #$20, #$40, #$60, #$80, #$A0, #$c0, #$e0
	.db #$00, #$20, #$40, #$60, #$80, #$A0, #$c0, #$e0
	.db #$00, #$20, #$40, #$60, #$80, #$A0, #$c0, #$e0
	.db #$00, #$20, #$40, #$60, #$80, #$A0, #$c0, #$e0
	
columnTableHi:
	.db #$20, #$20, #$20, #$20, #$20, #$20, #$20, #$20
	.db #$21, #$21, #$21, #$21, #$21, #$21, #$21, #$21
	.db #$22, #$22, #$22, #$22, #$22, #$22, #$22, #$22
	.db #$23, #$23, #$23, #$23, #$23, #$23, #$23, #$23
	
	
	
bitwiseLut:
	.db #%10000000, #%01000000, #%00100000, #%00010000, #%00001000, #%00000100, #%00000010, #%00000001
	
bitwiseLut16:
	.db #%10000000, #%01000000, #%00100000, #%00010000, #%00001000, #%00000100, #%00000010, #%00000001
	
directionTable:
	.db #%00110000, #%11110000, #%11000000, #%11100000, #%00100000, #%10100000, #%10000000, #%10100000

;12. Vectors
	.include "Routines\System\Vectors.asm"



	
	
	