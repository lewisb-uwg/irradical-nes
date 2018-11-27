;; uses collisionPoint0,1,2,and 3
	;; makes use of left+bbox_left, top+bbox_top, width and height of an object to form bounding box.
	;; gets collision data for each point.
	
	LDA ObjectFlags,y
	AND #%10000000 ;; ignore background collisions?
	BEQ dontIgnoreBackgroundCollisions
	RTS 
dontIgnoreBackgroundCollisions:

	
	;;;=== HANDLES TOP LEFT CORNER
	LDA xHold_hi
	SEC
	SBC Object_scroll,x
	CLC
	ADC ObjectBboxLeft,y ;; y is still loaded with object type, so this reads from lut table.
	clc
	adc xScroll
	STA tileX
	LDA yHold_hi
	CLC
	ADC ObjectBboxTop,y
	STA tileY
	JSR GetTileAtPosition
	LDA collisionTable,y
	;; y is now loaded with tile type
	STA collisionPoint0
	;;; if it is solid, disregard the other collisions, this should *stop us*.
	CMP #$01 ;; solid tile
	BNE notSolid_0
	JMP collisionHappened
notSolid_0:
	LDY Object_type,x
	
	;;; === handles top right corner
	LDA tileX
	CLC
	ADC ObjectWidth,y
	STA tileX
	JSR GetTileAtPosition
	;; y is now loaded with tile type
	LDA collisionTable,y
	STA collisionPoint1
	CMP #$01 ;; solid tile
	BNE notSolid_1
	JMP collisionHappened
notSolid_1:
	LDY Object_type,x
	
	;;; === handles bottom right corner
	LDA tileY
	CLC
	ADC ObjectHeight,y
	STA tileY
	JSR GetTileAtPosition
	LDA collisionTable,y
	;; y is now loaded with tile type
	STA collisionPoint2
	CMP #$01 ;; solid tile
	BNE notSolid_2
	JMP collisionHappened
notSolid_2:
	LDY Object_type,x
	
	;;; === handles bottom left corner
	LDA tileX
	SEC
	SBC ObjectWidth,y
	STA tileX
	JSR GetTileAtPosition
	LDA collisionTable,y
	;; y is now loaded with tile type
	STA collisionPoint3
	CMP #$01 ;; solid tile
	BNE notSolid_3
	JMP collisionHappened
notSolid_3:
	LDY Object_type,x ;; final restoring corrupted y value
	
	;;;; now we can check all collision points
	;; check if player is on a ladder
	CPX player1_object
	BNE notPlayerToCheckForLadder
	LDA collisionPoint0
	CMP #$0a ;; ladder
	BEQ dontResetLadder
	CMP #$0b ;; ladder top
	BEQ dontResetLadder
	JMP resetLadder
dontResetLadder:
	LDA collisionPoint1
	CMP #$0a
	BEQ dontResetLadder2
	CMP #$0b ;; ladder top
	BEQ dontResetLadder2
	JMP resetLadder
dontResetLadder2:
	LDA collisionPoint2
	CMP #$0a
	BEQ dontResetLadder3
	CMP #$0b ;; ladder top
	BEQ dontResetLadder3
	JMP resetLadder
dontResetLadder3
	LDA collisionPoint3
	CMP #$0a
	BEQ dontResetLadder_done
	CMP #$0b ;; ladder top
	BEQ dontResetLadder_done
resetLadder:
	LDA #$00
	STA onLadder;; no collision points were ladder.  Maybe that means we climbed above it or off it somehow.

dontResetLadder_done:
notPlayerToCheckForLadder:
	
	
	LDA collisionPoint0
	BNE collisionHappened
	LDA collisionPoint1
	BNE collisionHappened
	LDA collisionPoint2
	BNE collisionHappened
	LDA collisionPoint3
	BNE collisionHappened
	
	;LDA #TILE_NOT_SOLID ;; now #$00 is loaded into the accum - to be handled inside tile type
	
	RTS ;; no collision happened.
	
collisionHappened:
	
	PHA ;; put the collision to the stack
	;;==============================================
	;; do a trampoline to collision type.
	;; the collision type seen should still be in accum
	;;==============================================-
	
	LDA currentBank
	STA prevBank
	LDY #DATABANK1
	JSR bankswitchY
	
	TXA
	STA currentObject
	
	PLA ;; pull collision tile type form the stack
	TAY ;; use it as an index to determine which tile type we should follow
	
	
	LDA tileTypeBehaviorLo,y
	STA temp16
	LDA tileTypeBehaviorHi,y
	STA temp16+1
	JSR UseTileTypeTrampoline
	JMP pastTileTypeTrampoline
UseTileTypeTrampoline:
	JMP (temp16)
pastTileTypeTrampoline
	
	LDY prevBank
	JSR bankswitchY
	
	;; in case we WANT to use x, we should probably store x and restore it into current object, too.
	LDX currentObject
	LDY Object_type,x ;; restore corrupted y value