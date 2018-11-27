HandleScroll:

	LDA ScrollUpdateFlag
	BNE doScroll
	RTS
	
doScroll:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; HANDLE COLLISION PART OF SCROLL:
	LDA collisionColumnTracker
	CMP #$FF ;; we will use ff to denote that the first column needs to be changed.
	;;; since right now there is a 16 column cycle, that will mean this will overwrite column 0
	;;; this needs an update - as simple as making it a 32 column cycle. 
	BNE nevermindSetFirstColumn
	LDA #$00
	STA collisionColumnTracker
	LDA rightNametable
	STA temp3
	JMP doUpdateCollisionScrollColumn
nevermindSetFirstColumn:

	LDA xScroll
	LSR
	LSR
	LSR
	LSR
	CMP collisionColumnTracker
	BNE doCollisionScrollUpdate
	JMP noCollisionScrollUpdate
doCollisionScrollUpdate:
	LDA scrollDirection
	BNE collisionScrollIsRight
	;; collision scroll is left
	DEC collisionColumnTracker
	LDA collisionColumnTracker
	AND #%00001111
	STA collisionColumnTracker
	LDA leftNametable
	STA temp3
	JMP doUpdateCollisionScrollColumn
	
	
collisionScrollIsRight:
	;;; if moving right
	INC collisionColumnTracker
	LDA collisionColumnTracker
	AND #%00001111
	STA collisionColumnTracker
	
	LDA rightNametable
	STA temp3
doUpdateCollisionScrollColumn:	
	UpdateCollisionScrollColumn temp3, collisionColumnTracker, collisionColumnTracker
	JSR CheckScrollColumnForNewMonsters
	
	
	;; this also means we need to update attributes.
	


noCollisionScrollUpdate:
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;HANDLE GRAPHIC PART OF SCROLL:
	LDA OverwriteNT_column
	BEQ dontIgnoreColumnUpdateb
	RTS
dontIgnoreColumnUpdateb:
	LDA columnTracker
	CMP #$FF
	BNE columnTrackerIsNotFF
	;; this is used on a screen start up to make sure to update the 
	;; first column in the second nametable, rather than having to load
	;; the entire second nametable at the start.
	LDA #$00
	STA columnToPull
	LDA #$00
	STA temp2
	LDA rightNametable
	STA temp3
	LDA #$04
	STA nametableOffset
	LDA #$00
	STA columnTracker
	JMP DoUpdateColumn
	
columnTrackerIsNotFF:

	LDA xScroll
	LSR
	LSR
	LSR ;; this is now the current *column*
		;; if the current column has advanced beyond an
		;; 8 px boundary right or left, we need to update
		;; the next column.
		;; so maybe what needs to be done is to start the game
		;; columnToUpdate is set to #$FF or something,
		;; and then when it has a read of zero, it will
		;; automatically update the column.
		;; and maybe #$ff is a special case, where it updates
		;; both left and right columns.
		
		;; so if the current column does not match the
		;; columnToUpdate, that's when we see an action.
		
	CMP columnTracker
	BNE doScrollUpdate
	RTS
doScrollUpdate:


	LDA scrollDirection
	BNE doRightScrollColumnUpdate
	;;do left scroll column update
	;;;; if scrolling left:
	LDA showingNametable
	BNE notShowingFirstNametable
	;; is showing first nametable
	;; so should be updating the second.
	LDA #$00
	JMP gotNametableOffset
notShowingFirstNametable:
	LDA #$04
gotNametableOffset:
	STA nametableOffset
	
	LDA #$01
    STA ScrollUpdateFlag
    dec columnToPull
    LDA columnToPull
    AND #%00111111
    STA columnToPull
	;;;;;;;;;;;;;;;;;;;
	dec columnTracker
	LDA columnTracker
	AND #%00011111
	STA columnTracker
	;;;;;;;;;;;;;

	LDA columnToPull
	;CLC
	;ADC #$1f
	AND #%00011111
	;LDA #$1e
	STA temp2
	
	LDA leftNametable
	STA temp3
	JMP DoUpdateColumn
	
	
doRightScrollColumnUpdate:
	LDA showingNametable
	BNE notShowingFirstNametable2
	;; is showing first nametable
	;; so should be updating the second.
	LDA #$04
	JMP gotNametableOffset2
notShowingFirstNametable2:
	LDA #$00
gotNametableOffset2:
	STA nametableOffset
	;;;; if scrolling right:
	
	
	LDA #$01
    STA ScrollUpdateFlag
    inc columnToPull
    LDA columnToPull
    AND #%00111111
    STA columnToPull
	;;;;;;;;;;;;;;;;;;;
	inc columnTracker
	LDA columnTracker
	AND #%00011111
	STA columnTracker
	;;;;;;;;;;;;;

	LDA columnToPull
	AND #%00011111
	STA temp2
	
	LDA rightNametable
	STA temp3
	;;;;;;;;;;;;;;;;;;;; set column to update based on direction
	;;;;;;;;;;;;;;;;;;;; if right, columnToPull also gets put into arg2.
	;;;;;;;;;;;;;;;;;;;; if left, it has to be the other side of the screen.
	
DoUpdateColumn:	
	UpdateScrollColumn temp3, columnToPull, temp2
	UpdateAttributeColumn temp3, columnToPull, temp2
	
	LDA #$00
	STA ScrollUpdateFlag
	
	RTS

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	LDA OverwriteNT_column
	BEQ dontIgnoreColumnUpdate
	RTS
dontIgnoreColumnUpdate:
	
	LDA xScroll
	LSR
	LSR
	LSR ;; this is now the current *column*
		;; if the current column has advanced beyond an
		;; 8 px boundary right or left, we need to update
		;; the next column.
		;; so maybe what needs to be done is to start the game
		;; columnToUpdate is set to #$FF or something,
		;; and then when it has a read of zero, it will
		;; automatically update the column.
		;; and maybe #$ff is a special case, where it updates
		;; both left and right columns.
		
		;; so if the current column does not match the
		;; columnToUpdate, that's when we see an action.
		
;	CMP columnTracker
;	BNE doScrollUpdate
;	RTS
;doScrollUpdate:
	;;; so at the beginning of the game, columnTracker is zero.
	;;; if it is no longer zero, that means it has moved beyond 8px grid.
	;;; if it is forward, it would increase the columnTracker.
	;;; column to update would be beyond the right side of the screen,
	;;; which would be the current column plus 32, anded with 0-31.
	;INC columnTracker
	;LDA columnTracker
	;AND #%00111111
	;;STA columnTracker
	;CLC
	;ADC #$20
	;AND #%00111111
	;STA columnToUpdate
	LDA currentScreen
	CLC
	ADC #$01
	STA temp ;; screen to pull from in temp
	;LDA columnToUpdate
	;AND #%00011111
	LDA #$08
	STA columnToUpdate
	STA columnTracker
	;STA temp1 ;; which column to update is now in temp1
	
	UpdateScrollColumn temp, #$08, #$00



endScroll:
	RTS
	
	
	
	
	
	
	
	
getCollisionTypeForScroll:
	LDA CollisionTables_Map1_Lo,y
	STA temp16
	LDA	CollisionTables_Map1_Hi,y
	STA temp16+1
	JMP gotCollisionTypeForScroll
mapTwoCollisionForScroll:

	LDA CollisionTables_Map2_Lo,y
	STA temp16
	LDA	CollisionTables_Map2_Hi,y
	STA temp16+1
gotCollisionTypeForScroll:
	
	RTS	
	
	

getAttributeTypeForScroll:
	LDA AttributeTablesMainGameAboveLo,y
	STA temp16
	LDA	AttributeTablesMainGameAboveHi,y
	STA temp16+1
	JMP gotAttributeTypeForScroll
mapTwoAttributesForScroll:

	LDA AttributeTablesMainGameBelowLo,y
	STA temp16
	LDA	AttributeTablesMainGameBelowLo,y
	STA temp16+1
gotAttributeTypeForScroll:
	
	RTS	
	
	
getMapTypeForScroll:

	LDA NameTablePointers_Map1,y
	STA temp16
	LDA	NameTablePointers_Map1+1,y
	STA temp16+1
	JMP gotMapTypeForScroll
mapTwoForScroll:

	LDA NameTablePointers_Map2,y
	STA temp16
	LDA	NameTablePointers_Map2+1,y
	STA temp16+1
gotMapTypeForScroll:
	RTS
	
	
	
CheckScrollColumnForNewMonsters
	;;; this routine will check to see if there are any monsters that need to be loaded.
	;;; it needs to check the *right collision table*, then points 12, 13 and 14 (for day/normal...+ more when more monster bytes are added, beyond SCREEN_DATA_OFFSET)
	;; already should have collision map loaded into temp16, actually, so long as this routine happens just after the updated col column stuff
	;;;; check the normalized-to-column x of the first monster.
	
	LDA currentBank
	STA prevBank
	;LDY #$16
	;JSR bankswitchY
	;LDY rightNametable
	;JSR getCollisionTypeForScroll
	LDY screenBank
	JSR bankswitchY
	
	LDA #$0b ;; this is where monsters start.  hex 0b, dec 12
	CLC 
	ADC #SCREEN_DATA_OFFSET
	TAY
	LDA (temp16),y
	AND #%11110000
	BEQ dontLoadMonster1Here ;; there is no monster in this slot.
	LDA (temp16),y
	AND #%00001111
	CMP collisionColumnTracker
	BNE dontLoadMonster1Here
	;;;;; LOAD A MONSTER TO THIS SPOT:
	JSR LoadMonsterAtColumn
dontLoadMonster1Here:
	INY
	LDA (temp16),y
	AND #%11110000
	BEQ dontLoadMonster2Here ;; there is no monster in this slot.
	LDA (temp16),y
	AND #%00001111
	CMP collisionColumnTracker
	BNE dontLoadMonster2Here
	;;;;; LOAD A MONSTER TO THIS SPOT:
	JSR LoadMonsterAtColumn
dontLoadMonster2Here:
	INY 
	LDA (temp16),y
	AND #%11110000
	BEQ dontLoadMonster3Here ;; there is no monster in this slot.
	LDA (temp16),y
	AND #%00001111
	CMP collisionColumnTracker
	BNE dontLoadMonster3Here
	;;;;; LOAD A MONSTER TO THIS SPOT:

	JSR LoadMonsterAtColumn
dontLoadMonster3Here:
	

	LDY prevBank
	JSR bankswitchY
	RTS
	
LoadMonsterAtColumn:
	TYA
	STA tempy

	LDA (temp16),y
	AND #%11110000
	STA tileY
	LDA (temp16),y
	ASL
	ASL
	ASL
	ASL
	STA tileX
	;;;; get monster;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; daytime only.
	LDA #$17 ;; this is where monsters start.  hex 0b, dec 12
	CLC 
	ADC #SCREEN_DATA_OFFSET
	TAY
	LDA (temp16),y
	LSR
	LSR ;;; this byte is aaaaaabb...move it right twice to get the *day normal* group.
	;;;;; now we have the day normal group.
	ASL
	ASL
	;;; since each group is 4 monsters, now we have 
	;; since this is the first monster, that should do it.
	;; are we in the right bank?
	STA temp
	LDY #$16
	JSR bankswitchY
	LDY temp
	LDA MonsterGroups,y
	CLC
	ADC #$10;; first 16 objects are game objects.  This references "0" as the first "monster"
	STA temp3
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	LDY tempy
	CreateObject tileX,tileY,temp3,#$00 ;; third argument = monster type
	RTS