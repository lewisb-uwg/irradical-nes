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
	CLC
	ADC ObjectBboxLeft,y ;; y is still loaded with object type, so this reads from lut table.
	STA tileX
	LDA yHold_hi
	CLC
	ADC ObjectBboxTop,y
	STA tileY
	JSR GetTileAtPosition
	LDA collisionTable,y
	;; y is now loaded with tile type
	STA collisionPoint0
	
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
	
	LDY Object_type,x ;; final restoring corrupted y value
	
	;;;; now we can check all collision points
	
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
	
	PLA ;; pull collusion tile type form the stack
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