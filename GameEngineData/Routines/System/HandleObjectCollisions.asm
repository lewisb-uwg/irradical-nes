;; LOAD OBJECT 00
;; OUTER LOOP
;; CHECK IF ACTIVE, IF NOT, SKIP OBJECT
;; LOAD self-collision-box
;; START OBJECT COLLISION LOOP
	;; LDA ONE MORE THAN CURRENT OBJECT
	;; CHECK IF ACTIVE.  IF NOT, SKIP THIS other
	;; IF IT IS ACTIVE, then we have to play them against each other.
		;; IS self object hurt by monsters?  If so, and other object is a monster, respond.
		;; IS self object hurt by weapons?  If so, and other object is a weapon, respond.
		;; at this point, we can still gauge whether or not it's affected by player, like with powerups.
		;; ADD one to the object being checked, loop through other objects.
;; increase object, return to outer loop.  Repeat thorugh all self objects.

;; ObjectFlags:
;; 7 - 6 - 5 - 4 - 3 - 2 - 1 - 0
;  |   |   |   |   |   |   |   + -- PERSISTENT (especially good for player!)
;  |   |   |   |   |   |   +------- player type
;  |   |   |   |   |   + ---------- player weapon/projectile type
;  |   |   |   |   +--------------- monster type
;  |   |   |   +------------------- monster weapon/projectile type
;  |   |   +----------------------- pickup / power up
;  |   + -------------------------- target type 
;  +------------------------------- Ignore all object collisions (great for effects)

;; player type checks monster, mosnter weapon, and pickup.
;; player weapon checks monster and target.
;; nothing else needs checking, as it would all be handled by those two steps.
;; so if it's a monster, do nothing.  if it's a monster projectile, do nothing. 
;; if it's a pickup, or a target, or it ignores all collisions, do nothing.
;; only if it's #%00000110, do something.



HandleObjectCollisions:
	LDA update_screen
	BEQ notChangingScreens
	rts
notChangingScreens:


	LDA currentBank
	STA prevBank
	LDY #BANK_ANIMS
	JSR bankswitchY
	
	LDX #$00
CollisionOuterLoop:
	TXA
	STA tempx
	LDA Object_status,x
	AND #%10000000
	BNE continueObjectCollisions_objectIsActive
	JMP doneWithThisObjectCollision
continueObjectCollisions_objectIsActive:
	LDA Object_status,x
	AND #%00000011
	BEQ continueObjectCollisions_objectIsNotHurtOrInvincible
	JMP doneWithThisObjectCollision
continueObjectCollisions_objectIsNotHurtOrInvincible
	LDY Object_type,x
	LDA ObjectFlags,y
	AND #%00000110
	BNE continueObjectCollisions_onlyPlayerTypesCheck
	JMP doneWithThisObjectCollision
continueObjectCollisions_onlyPlayerTypesCheck:
	;; this is either a player or player projectile type of object.
	;; all other types will be taken care of by iterating through these two types.
	;; first, check if it's player type.
	LdA ObjectFlags,y
	AND #%00000010
	BNE isPlayerTypeForCollision
	JMP notPlayerType_forObjectCollision
isPlayerTypeForCollision:
	LDA player1_object
	STA colX
	;; is player type for object collision
	;; player's index is loaded into tempx
	JSR GetSelfCollisionBox
	;; now we have the collision box for self object
	;; next we loop through objects.
	LDX #$00
LoopThroughOtherObjects_player:
	CPX tempx
	BNE dontSkipThisOtherObject
	JMP skipThisOtherObject ;; other object IS the player, the one doing the counting..
dontSkipThisOtherObject:
	JSR GetOtherCollisionBox
	
	;; now we can do all the compares
	LDA selfLeft
	CMP otherRight
	BCC keepCheckingPlayerObjectCollision 
	JMP noPlayerObjectCollision ;; it is off to the right.
keepCheckingPlayerObjectCollision:
	LDA selfRight
	CMP otherLeft
	BCS keepCheckingPlayerObjectCollision2 
	JMP noPlayerObjectCollision ;; it is off to the left.
keepCheckingPlayerObjectCollision2:
	LDA selfTop
	CMP otherBottom 
	BCC keepCheckingPlayerObjectCollision3
	JMP noPlayerObjectCollision ;; it is below
keepCheckingPlayerObjectCollision3:
	LDA selfBottom
	CMP otherTop
	BCS keepCheckingPlayerObjectCollision4
	JMP noPlayerObjectCollision ;; it is above
keepCheckingPlayerObjectCollision4:
	;;; there was a player collision
	;; go through the different types of collision possible.
	;; first, check monster OR monser projectile, as that should lead to hurt/death
	LDY Object_type,x
	LDA ObjectFlags,y
	AND #%10000000 ;; is it an NPC
	BNE isAnNPC
	;; is not an NPC
	JMP isNotAnNPCcollision
isAnNPC:
	;;;; do npc stuff.
	
	LDA gamepad
	AND #%00000010 ;; is b button pressed?
	BEQ skipShowingText
	
	LDA Object_ID,x
	STA stringTemp ;;  3 will be passed on to text routine
	;;;; it holds the number within the group to draw.
	
	;;; set a flag to handle this next frame
	LDA #$01
	STA textBoxFlag
	
	
skipShowingText:
	JMP skipThisOtherObject
	
isNotAnNPCcollision:	
	LDA ObjectFlags,y
	AND #%00011000 ;; is it a monster type?
	BNE otherIsAMonsterTypeCollision
	JMP otherIsNotAMonsterTypeCollision
otherIsAMonsterTypeCollision:
	LDA Object_status,x
	AND #HURT_STATUS_MASK ;; if the monster is hurt, it can't hurt us
	BEQ yesPlayerObjectCollision
	JMP noPlayerObjectCollision
yesPlayerObjectCollision:
	LDA Object_vulnerability,x
	AND #%00000010 ;; in this module, this is ignore player collision
	BEQ doPlayerHurt
	JMP	noPlayerObjectCollision
doPlayerHurt:
	;;;observe health
	TXA
	STA tempx
	LDX player1_object
	LDA Object_status,x
	AND #HURT_STATUS_MASK
	BEQ playerWasNotHurtDuringCollision
	JMP playerWasHurtDuringCollision
playerWasNotHurtDuringCollision:	
	
	;;;;;;;;;;;;;;;;;
	;;;;;;;;; WHAT HAPPENS WHEN PLAYER IS HURT
	.include SCR_PLAYER_HURT_SCRIPT
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
playerWasHurtDuringCollision:	
	LDX tempx
	JMP skipThisOtherObject
otherIsNotAMonsterTypeCollision:
	LDA ObjectFlags,y
	AND #%00100000 ;; is it a 'collectable'?
	BEQ otherIsNotAcollectable
	;;;; IS A pickup / power up
	DeactivateCurrentObject ;; makes the other object go away
							;; since other object is loaded in X
							
;;=========== WHAT DO YOU WANT TO HAVE HAPPEN WHEN YOU COLLECT THIS ITEM?
	TYA
	STA tempy
	LDA currentBank
	STA prevBank
	LDY #$14
	JSR bankswitchY
	LDY tempy
	JSR HandlePickupPowerup
	LDY prevBank
	JSR bankswitchY
	LDY tempy
	
otherIsNotAcollectable:
noPlayerObjectCollision:	
skipThisOtherObject:
	INX
	CPX #TOTAL_MAX_OBJECTS
	BEQ doneLoopThroughOtherObjects_player
	JMP LoopThroughOtherObjects_player
doneLoopThroughOtherObjects_player:
	;; end of player collision
	LDX tempx ;; restore x
	JMP doneWithThisObjectCollision
	
	
	
notPlayerType_forObjectCollision:
	;; is of player weapon type.
	JSR GetSelfCollisionBox
	;; now we have the collision box for self object
	;; next we loop through objects.
	LDX #$00
LoopThroughOtherObjects_weapon:

	CPX tempx
	BNE dontskipThisOtherObject_weapon
	JMP skipThisOtherObject_weapon
dontskipThisOtherObject_weapon
	JSR GetOtherCollisionBox
	
	;; now we can do all the compares
	LDA selfLeft
	CMP otherRight
	BCC keepCheckingWeaponObjectCollision
	JMP noWeaponObjectCollision ;; it is off to the right.
keepCheckingWeaponObjectCollision:
	LDA selfRight
	CMP otherLeft
	BCS keepCheckingWeaponObjectCollision2
	JMP noWeaponObjectCollision ;; it is off to the left.
keepCheckingWeaponObjectCollision2:
	LDA selfTop
	CMP otherBottom 
	BCC keepCheckingWeaponObjectCollision3
	JMP noWeaponObjectCollision ;; it is below
keepCheckingWeaponObjectCollision3:
	LDA selfBottom
	CMP otherTop
	BCS keepCheckingWeaponObjectCollsion4
	JMP noWeaponObjectCollision ;; it is above
keepCheckingWeaponObjectCollsion4:
	;;; there was a player collision
	;; go through the different types of collision possible.
	;; first, check monster OR monser projectile, as that should lead to hurt/death
	LDY Object_type,x
	LDA ObjectFlags,y
	AND #%00001000 ;; is it a monster type?
	;;; if you'd like the player weapon to ALSO destroy projectiles
	;;; use #%00011000 here
	BNE otherIsMonsterTypeCollision_weapon
	JMP otherIsNotAMonsterTypeCollision_weapon
otherIsMonsterTypeCollision_weapon:
;;;;;;;;;;;;;;;;;;;;;;;;
	TXA
	PHA
	.include SCR_HANDLE_HURT_MONSTER
	PLA
	TAX
	;;; if monster dies, count monsters
	;; right now, he always dies, so count the monsters.
	JSR countAllMonsters	
	

	
otherIsNotAMonsterTypeCollision_weapon:
	
noWeaponObjectCollision:	
skipThisOtherObject_weapon:
	INX
	CPX #TOTAL_MAX_OBJECTS
	BEQ doneWithLoopingThroughWeaponObjects
	JMP LoopThroughOtherObjects_weapon
doneWithLoopingThroughWeaponObjects:
	
	
	
	;; end of player collision
	LDX tempx ;; restore x
	JMP doneWithThisObjectCollision
	
	
	
	
doneWithThisObjectCollision:
	LDX tempx
	INX
	CPX #TOTAL_MAX_OBJECTS
	BEQ doneWithAllObjects
	JMP CollisionOuterLoop
doneWithAllObjects:
	
	
	LDY prevBank
	JSR bankswitchY
	RTS
	
	
	
	
	
	
GetSelfCollisionBox:	
	LDY Object_type,x
	LDA Object_x_hi,x
	sec
	sbc Object_scroll,x
	CLC
	ADC ObjectBboxLeft,y
	STA selfLeft
	clc
	ADC ObjectWidth,y
	STA selfRight
	LDA ObjectWidth,y
	LSR
	STA temp
	LDA selfRight
	SEC
	SBC temp
	STA selfCenterX
	
	LDA Object_y_hi,x
	CLC
	ADC ObjectBboxTop,y
	STA selfTop
	CLC
	ADC ObjectHeight,y
	STA selfBottom
	LDA ObjectHeight,y
	LSR
	STA temp
	LDA selfBottom
	SEC
	SBC temp
	STA selfCenterY
	RTS
	
GetOtherCollisionBox:
	LDY Object_type,x
	LDA Object_x_hi,x
	sec
	sbc Object_scroll,x
	CLC
	ADC ObjectBboxLeft,y
	STA otherLeft
	clc
	ADC ObjectWidth,y
	STA otherRight
	LDA ObjectWidth,y
	LSR
	STA temp
	LDA otherRight
	SEC
	SBC temp
	STA otherCenterX
	
	LDA Object_y_hi,x
	CLC
	ADC ObjectBboxTop,y
	STA otherTop
	CLC
	ADC ObjectHeight,y
	STA otherBottom
	LDA ObjectHeight,y
	LSR
	STA temp
	LDA otherBottom
	SEC
	SBC temp
	STA otherCenterY
	RTS
	
	
	
	
	
	
	
DetermineRecoilDirection:

	;;;RECOIL
	;;First check for the abs x value
	LDA recoil_selfX
	SEC
	SBC recoil_otherX
	BCS absCheckDone
	EOR #$FF
	CLC
	ADC #$01
absCheckDone:
	STA temp
	LDA recoil_selfY
	SEC
	SBC recoil_otherY
	BCS absCheckDone2
	EOR #$FF
	CLC
	ADC #$01
absCheckDone2:
	CMP temp
	BCS vCol
	LDA recoil_selfX
	CMP recoil_otherX
	BCS recoilRight
	;; recoil left
	;LDX #$01
	LDA #RECOIL_SPEED_LO
	STA Object_h_speed_lo,x
	LDA #$00
	SEC
	SBC	#RECOIL_SPEED_HI
	STA Object_h_speed_hi,x
	LDA #$00
	STA Object_v_speed_hi,x
	STA Object_v_speed_lo,x
	LDA #%10000000
	STA temp1
	LDA Object_movement,x
	AND #%00000111
	ORA temp1
	STA Object_movement,x
	
	RTS
	
recoilRight:
	;LDX #$01
	LDA #RECOIL_SPEED_LO
	STA Object_h_speed_lo,x
	LDA	#RECOIL_SPEED_HI
	STA Object_h_speed_hi,x
	LDA #$00
	STA Object_v_speed_hi,x
	STA Object_v_speed_lo,x
	LDA #%11000000
	STA temp1
	LDA Object_movement,x
	AND #%00000111
	ORA temp1
	STA Object_movement,x
	
	RTS
	
vCol:
	LDA recoil_selfY
	CMP recoil_otherY
	BCS recoilDown
	;LDX #$01
	LDA #RECOIL_SPEED_LO
	STA Object_v_speed_lo,x
	LDA #$00
	SEC
	SBC	#RECOIL_SPEED_HI
	STA Object_v_speed_hi,x
	LDA #%00100000
	STA temp1
	LDA #$00
	STA Object_h_speed_hi,x
	STA Object_h_speed_lo,x
	LDA Object_movement,x
	AND #%00000111
	ORA temp1
	STA Object_movement,x

	RTS
	
recoilDown:
	;LDX #$01
	LDA #RECOIL_SPEED_LO
	STA Object_v_speed_lo,x
	LDA #RECOIL_SPEED_HI
	STA Object_v_speed_hi,x
	LDA #%00110000
	STA temp1
	LDA #$00
	STA Object_h_speed_hi,x
	STA Object_h_speed_lo,x
	LDA Object_movement,x
	AND #%00000111
	ORA temp1
	STA Object_movement,x
	
	RTS
	