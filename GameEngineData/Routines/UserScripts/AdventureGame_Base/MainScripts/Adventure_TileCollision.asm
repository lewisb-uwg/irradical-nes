HandleTileCollision:
;; uses collisionPoint0,1,2,and 3
	;; makes use of left+bbox_left, top+bbox_top, width and height of an object to form bounding box.
	;; gets collision data for each point.
	
	LDA ObjectFlags,y
	BNE dontIgnoreBackgroundCollisions
	RTS 
dontIgnoreBackgroundCollisions:
	LDA Object_vulnerability,x
	AND #%00010000
	BEQ dontIgnoreBackgroundCollisions2
	RTS
dontIgnoreBackgroundCollisions2:
	
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
	;BNE collisionHappened
	
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
	;BNE collisionHappened
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
;	BNE collisionHappened
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
	;BNE collisionHappened
	LDY Object_type,x ;; final restoring corrupted y value
	
	;;;; now we can check all collision points
	

	LDA collisionPoint0
	ORA collisionPoint1
	ORA collisionPoint2
	ORA collisionPoint3
;	;;; all collision points were zero.
	BEQ noCollisionHappened
	
	JMP collisionHappened

noCollisionHappened:	
	RTS ;; no collision happened.
	
collisionHappened:
	;; if a collision happened, we'll want to go through all of the points to see what they're colliding with.
	
	;LDY Object_type,x ;; final restoring corrupted y value
	
	;PHA ;; put the collision to the stack
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
	
	LDA #$00
	STA tempCol
	
DoCheckPointsLoop:
	LDY tempCol
	LDA collisionPoint0,y
	BEQ DontCheckTileType0
	TAY
	LDA tileTypeBehaviorLo,y
	STA temp16
	LDA tileTypeBehaviorHi,y
	STA temp16+1
	JSR UseTileTypeTrampoline
	JMP pastTileTypeTrampoline
UseTileTypeTrampoline:
	JMP (temp16)
pastTileTypeTrampoline
	
DontCheckTileType0:
	INC tempCol
	LDA tempCol
	CMP #$04 ;; max number of collision points.  
	BNE DoCheckPointsLoop

	
	LDY prevBank
	JSR bankswitchY
	;; in case we WANT to use x, we should probably store x and restore it into current object, too.
	LDX currentObject
	LDY Object_type,x ;; restore corrupted y value
	RTS