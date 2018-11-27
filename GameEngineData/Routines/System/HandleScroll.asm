HandleScroll:
	LDA ScrollUpdateFlag
	BNE doScroll
	RTS ;; scroll update flag was unchecked, so ignore scroll
doScroll:
	
	
	
	LDA xScroll
	LSR
	LSR
	LSR
	STA temp
	
	CMP columnTracker
	BEQ dontIgnoreColumnUpdate
	;;; check left, which would be offset from columnTracker by exactly 32?
	LDA temp
	CLC 
	ADC #$20
	AND #%0001111
	CMP columnTracker
	BEQ dontIgnoreColumnUpdate
	JMP ignoreColumnUpdate
dontIgnoreColumnUpdate:
	
	LDA OverwriteNT_column
	BEQ dontIgnoreColumnUpdate2
	JMP ignoreColumnUpdate
dontIgnoreColumnUpdate2:
	
doUpdateColumnLoop:	
	JSR LoadNTColumn

ignoreColumnUpdate:
	RTS
	
	
	
	
	
	
	
	
	
	
LoadNTColumn:
	
	LDA showingNametable
	BNE updateFirstNametable
	LDA #$04
	JMP gotNtOffset
updateFirstNametable:
	LDA #$00
gotNtOffset:	
	STA nametableOffset


	LDA #$00
	STA rowTracker
	LDX #$00 
doUpdateColumnNTram:

	LDA currentBank
	STA prevBank
	LDY #$16
	JSR bankswitchY
	LDA ScrollUpdateFlag
	AND #%00000010 ;; 0 is left, 1 is right
	BNE isRightScrolling

	;; is left scrolling
	LDA currentNametable
	sec
	sbc #$01
	ASL
	TAY 
	JMP gotScrollingDirection
isRightScrolling:
	
	LDA currentNametable
	CLC
	ADC #$01
	ASL
	TAY 
gotScrollingDirection:
;;;; HAVE TO MAKE ALLOCATION IF UNDERGROUND
	LDA NameTablePointers_Map1,y
	STA temp16
	LDA	NameTablePointers_Map1+1,y
	STA temp16+1
;;;;;; JUMP TO BANK WHERE THIS DATA IS STORED
	LDY screenBank
	JSR bankswitchY
;;;; GET TILE VALUE TO DRAW	
	LDA columnTracker
	LSR
	STA temp
	LDA rowTracker
	ASL
	ASL
	ASL
	ASL
	CLC
	ADC temp

	TAY
;;;;;;;;;;;; THIS IS THE TILE TO DRAW
	LDA (temp16),y
	STA temp
	JSR GetSingleMetaTileValues ;; this will return updateTIle_00-03
	;;; It WILL observe paths, however since things are updating row by row,
	;;; paths will not behave as expected.  They'll all act as if they
	;;; have no surrounding paths.
	;;;;; Push updateTiles to ram variables.
	LDA columnToUpdate
	AND #%00000001 ;; is it an odd column
	BNE oddColumnToUpdate
	
	LDA updateTile_00
	
	STA updateColumnNT_fire_Tile,x
	INX
	LDA updateTile_02
	
	STA updateColumnNT_fire_Tile,x
	INX
	JMP gotUpdateColumnTiles
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
oddColumnToUpdate:
	LDA updateTile_01
	
	STA updateColumnNT_fire_Tile,x
	INX
	LDA updateTile_03

	STA updateColumnNT_fire_Tile,x
	INX
	;; now we have the meta tile loaded into x,x+1,x+2,x+3
gotUpdateColumnTiles:
	;INX
	CPX #$1e
	BEQ doneWithGettingColumnNT 
	inc rowTracker
	JMP doUpdateColumnNTram
doneWithGettingColumnNT:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	LDY prevBank
	JSR bankswitchY
;;;;; THIS IS WHERE TO PLACE THAT TILE

	
	LDA #$01
	STA OverwriteNT_column
	

	LDA #$01
	STA OverwriteNT

	RTS
	
	
	
	
	
	
	
	
	
	
	
