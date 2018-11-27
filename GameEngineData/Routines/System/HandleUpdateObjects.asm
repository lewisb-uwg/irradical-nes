HandleUpdateObjects:	

	JSR DrawAllSpritesOffScreen
	;; load the animation bank, as it has the lut tables in it, etc.
	;; at the beginning of the handle objects loop, we want to reset the counter to $0200
	;; (maybe, unless it's going *backwards* to allow for native flicker).
	;; since the high byte of this will always be #$02, we really only need to worry about one byte.
	;; this is spriteOffset.  A value of #$00 will result in writing to 0200.  A value of
	;; 05 will result in writing ot 0205.  a value of 80 will result in writing to 0280.

;;////////////////////////////////
	;;;; IF YOUR GAME DOES NOT REQUIRE DEPTH, COMMENT OUT THIS LINE TO MAKE IT PERFORM A BIT FASTER
	JSR UpdateDrawOrder
;;////////////////////////////////////
;;;;; IF YOUR SPRITE USES SPRITE ZERO HIT DETECTION 
;;;;; PUT THAT SPRITE ZERO DATA HERE
	;LDA #$18 ;; SPRITE 0 Y
	;STA $0200
	;LDA #$0f ;; SPRITE ZERO TILE
	;STA $0201
	;LDA #%001000011 ;; SPRITE ZERO ATTRIBUTE (uneccesary)
				;++-- sup pal to use
		;;;;+-------- use a 1 in bit 6 to put sprite in front of or behind background (hud)
;	STA $0202
	;LDA #$F8 ;; SPRITE ZERO X ;; make higher than #$07, lower than #$ff
	;STA $0203
	
	LDA #$00 ;; this is 4 if we need to use sprite 0 hit
	STA spriteOffset
	
	.include SCR_SPRITE_PREDRAW
	
	
	

	
	;; any sprites that are not part of the object draws, or that should have specific priority,
	;; should be handled here.
	;========================
	; handle anomalous sprites that need higher priority, and possibly sprite 0 if 
	; you need sprite zero hit check.  When finished, set spriteOffset to the next free value.
	
	;;=======================
	
	
	LDA currentBank
	STA prevBank
	LDY #BANK_ANIMATIONS
	JSR bankswitchY

;;; here, we need to make x the value of
;; the first value in the Draw Order array.	
;; if you do not use draw order,just load X with zero here, and comment out storing it to DrawOrderTemp.
	LDX #$00
	TXA 
	STA DrawOrderTemp
UpdateObjectsLoop:
;;;;;;; ////////
;;COMMENT THESE NEXT TWO LINES OUT IF NOT USING DRAW ORDER
	LDA drawOrder,x
	TAX 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




	LDA Object_status,x
	AND #OBJECT_IS_ACTIVE
	BEQ thisObjectIsInactive
	JMP thisObjectIsActive
thisObjectIsInactive:
	;; it is not active, but are we about to turn it on?
	LDA Object_status,x
	AND #OBJECT_ACTIVATE
	;; if this bit if slipped, that means we need to activate this object in this frame.
	;; which means any data the object needs to gather, it can do so here.
	BNE thisObjectNeedsToBeActivated
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	LDA #$00
	STA Object_x_hi,x
	STA Object_y_hi,x
	;;; it does not need to be activated.
	;; check to see if it needs to be deactivated?
	JMP doneUpdatingThisObject
thisObjectNeedsToBeActivated:


	;;; do the loads for this object.  All we know right now are x,y,and type
	LDA #OBJECT_IS_ACTIVE
	STA Object_status,x
	;;;; done with the loads for this object.  Now, it is active, and can flow right
	;; into what happens to the object if it's active (maybe skip beyond update movement?)
	;; WHICH WILL STILL BE IN ANIMATION BANK, so no need to change back now.
	;; do we even need to populate bytes?  Some.  Ones like health and timers and such.
		
		;;; load action timer
		;;; load animation speed
		;;; load vulnerability for action 1

		
			LDA VulnerabilityTableLo,y
			STA temp16
			LDA VulnerabilityTableHi,y
			STA temp16+1
			LDA Object_action_step,x
			AND #%00000111
			TAY
			LDA (temp16),y
			STA Object_vulnerability,x
			
			LDY Object_type,x
			LDA ObjectFlags,y
			STA Object_flags,x
		;;; read a status bit (do this above) to get direction, spawn action, etc?
		;;;;;====================
		;; Storing these values prevent us from having to do 
		;; a double lookup every frame

		LDY #$16
		JSR bankswitchY
		
		LDY Object_type,x
		LDA ObjectLoSpriteAddressLo,y
		STA Object_table_lo_lo,x
		LDA ObjectLoSpriteAddressHi,y
		STA Object_table_lo_hi,x
		
		LDA ObjectHiSpriteAddressLo,y
		STA Object_table_hi_lo,x
		LDA ObjectHiSpriteAddressHi,y
		STA Object_table_hi_hi,x
		
		LDY #BANK_ANIMATIONS
		JSR bankswitchY
		LDY Object_type,x
			;; things to happen BEFORE activating and zeroing out the rest of status.
		LDA Object_total_sprites,y ;; y represents the type of object.
									;; Object_total_sprites is a table in ObjectInfo that declares
									;; how many sprites total that an object has.
		STA Object_total_tiles 

		
		

		;;;; set animation frame to zero
		LDA #$00
		STA Object_animation_frame,x
		JSR setActionTimer
		
		JSR getNewEndType
		
		
		;; must be in anim bank
		JSR getAnimationSpeedAndOffset
	

		LDY Object_type,x ;; restore y
		;;///////////////////// Load other pertinent details for object here
		
		LDA ObjectHealth,y
		STA Object_health,x
		CPY #$00
		BNE notPlayerSoDontChangeGlobalHealth
		;STA GLOBAL_Player1_Health
		;; AND TO REFLECT THIS CHANGE:
		;; we'll need to update the hud.
		;STA hudElementTilesToLoad
		;LDA #$00
		;STA hudElementTilesMax
		;	LDA DrawHudBytes
		;	ORA HUD_updateHealth		
			;ORA HUD_updateLives			
			;ORA HUD_updateScore	
			;LDA #$00
		;	STA DrawHudBytes
notPlayerSoDontChangeGlobalHealth:		
		
		CPY #$00
		BNE nevermindDoPlayerSpecificLoads
		;; do player specific loads.
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;DOES GAME PLAYER HAVE HEALTH?
		
			LDA Object_health,x
			STA hudElementTilesToLoad
				
			;;Load hud stuff
			;LDA #%10000000
			;STA DrawHudBytes
			;; TURN ON handling the hud
			
			LDA #BOX_0_ASSET_0_MAX_VALUE
			STA hudElementTilesFull
			
			LDA #$00
			STA updateHUD_offset	
				
				
		nevermindDoPlayerSpecificLoads:
		;;;;;;;;////////////////////////////////////
	
		LDA ObjectReaction,y
		STA Object_edge_action,x
		;;;============================================
		JSR DoNewAction	
	
		;;etc
		;;; load 
	;; do the initial first action.	
	JMP doneUpdatingThisObject ;; this object just came into being.  it will ignore animation / update
						;;otherwise it will be beyond frame 0 and into frame 1 before we even see it.
		
thisObjectIsActive:
	;; if it's active, we need to do two things.  One, update it's movement, animation, etc, which we would do first.
UpdateObjectMovement:
	;;;;;; DO WE UPDATE OBJECTS, OR ARE GAME OBJECTS FROZEN?
;;;; 
	LDA gameHandler
	AND #%00100000 ;; objects bit
	BEQ doHandleObjects
	JMP UpdateDrawObject
doHandleObjects:


	JSR CalculateAccAndSpeed
	;;
	
	
	JSR HandleActionTimerUpdate
	JSR HandleObjectTimers

UpdateDrawObject:

	JSR getAnimOffset
	JSR HandleDrawingSprites


	
	
doneUpdatingThisObject
;;; REMOVE THIS if not using draw order
	INC DrawOrderTemp
	LDA DrawOrderTemp
	TAX 
;;;;;;;Uncomment below if not using draw order.
	;INX
	CPX #TOTAL_MAX_OBJECTS 
	BEQ doneUpdatingObjects
	JMP UpdateObjectsLoop
	
doneUpdatingObjects:	
	
UpdateObjectCollisions:
	JSR HandleObjectCollisions
	JSR countAllMonsters
	
	LDY prevBank
	JSR bankswitchY
	
	LDA #$01
	STA checkForSpriteZero
	RTS
	
	
	
	
	
	
HandleActionTimerUpdate:
	DEC Object_action_timer,x
	BEQ actionTimerStillGoing
	JMP actionTimerFinished ;; done with this
actionTimerStillGoing:

	;;; action timer is finished.
	;;; we COULD set up a trampoline here, but instead, let's just 
	;;; have these built in for now.
		;0 = LOOP
		;1 = ADVANCE
		;2 = Repeat (reactivates action)
		;3 = Go to first (0)
		;4 = Go to last (7)
		;5 = Go to previous
		;6 = Destroy me
		;7 = END GAME (for now, reset)
	;; at the end, we also have to reset end action part of end action byte
	LDA Object_end_action,x
	AND #%00001111
	;;; this is the end action.
	BNE doMoreThanResetTimer
	JSR setActionTimer
	JMP actionTimerFinished
doMoreThanResetTimer:
	CMP #$01
	BNE notAdvanceAction
	;; is advance action
	LDA Object_action_step,x
	AND #%00000111
	CLC
	ADC #$01
	CMP #$08
	BCC isAGoodActionStepValue
	;; is over 8, so go back to 1

	ChangeObjectState #$00,#$02
	JSR DoNewAction
	JMP actionTimerFinished
isAGoodActionStepValue:
	STA temp
	ChangeObjectState temp,#$02
	JSR DoNewAction
	JMP actionTimerFinished
notAdvanceAction:
	CMP #$02
	BNE notRepeatAction

	;; is repeat action.
	;; which is just fire the action again.
	JSR DoNewAction
	JMP actionTimerFinished
notRepeatAction:
	CMP #$03
	BNE dontGoToFirstAction
	;;go to first action
	ChangeObjectState #$00,#$02
	JSR DoNewAction
	JMP actionTimerFinished
dontGoToFirstAction:
	CMP #$04
	BNE dontGoToLastAction
	;;; go to last action
	ChangeObjectState #$07,#$02
	JSR DoNewAction
	JMP actionTimerFinished
dontGoToLastAction:
	CMP #$05
	BNE dontGoToPrevAction
	;; go to prev action
	LDA Object_action_step,x
	AND #%00000111
	BEQ cycleToActionStep7
	SEC
	SBC #$01
	STA temp
	ChangeObjectState temp,#$02
	JSR DoNewAction
	JMP actionTimerFinished
cycleToActionStep7:
	ChangeObjectState #$07,#$02
	JSR DoNewAction
	JMP actionTimerFinished
dontGoToPrevAction:
	CMP #$06
	BNE dontDestroyMe
	;; destroy me
	DeactivateCurrentObject
	JMP actionTimerFinished
dontDestroyMe:
	CMP #$07
	BNE dontResetGame
	;;;; Handle loss of a life versus actual RESET death, simple.
	JSR LoseLife
	JMP actionTimerFinished
dontResetGame:
	CMP #$08
	BNE dontWinGame
	 	LDA #STATE_WIN_GAME
	STA change_state
	LDA #$01
	STA newScreen
	
skipWin:
	LDA #TILE_SOLID
	STA tile_solidity
	JMP actionTimerFinished
dontWinGame:
actionTimerFinished:
	
	RTS
	
	
HandleObjectTimers:
;;; handle object timers, tool
	LDA Object_timer_0,x
	BEQ ObjectTimer0Finished
	DEC Object_timer_0,x
	LDA Object_timer_0,x
	BNE ObjectTimer0Finished ;; timer is still going.
	;;;;; object timer 0 has cycled and is finished.
	;;;;; right now, we'll use this to flip hurt/invincible to just invincible, to normal.
	LDA Object_status,x
	AND #%00000001 ;; is it hurt and invincible?
	BEQ notHurtAndInvincible
	;; hurt and invincible
	LDA Object_status,x
	AND #%11111110
	ORA #%00000010
	STA Object_status,x
	LDA #INVINCIBILITY_TIMER
	STA Object_timer_0,x
	LDA Object_movement,x
	AND #%00001111
	STA Object_movement,x
	LDA #$00
	STA Object_h_speed_hi,x
	STA Object_h_speed_lo,x
	STA Object_v_speed_hi,x
	STA Object_v_speed_lo,x
	
	
	
	
	JMP ObjectTimer0Finished
notHurtAndInvincible:
	LDA Object_status,x
	AND #%00000010
	BEQ ObjectTimer0Finished ;; no longer invincible...not sure what this timer would be doing at this point.
	;;; it IS still invincible, need to change it back to normal.
	LDA Object_status,x
	AND #%11111100
	STA Object_status,x
	;;; activate state 0
	ChangeObjectState #$00,#$02
	JSR DoNewAction
	
ObjectTimer0Finished:
	RTS
	
	
	
	
	
DoNewAction:
	LDY Object_type,x
	LDA VulnerabilityTableLo,y
	STA temp16
	LDA VulnerabilityTableHi,y
	STA temp16+1
	LDA Object_action_step,x
	AND #%00000111
	TAY
	LDA (temp16),y
	STA Object_vulnerability,x


	LDY Object_type,x
	LDA ObjectBehaviorTableLo,y
	STA temp16
	LDA ObjectBehaviorTableHi,y
	STA temp16+1
	
	LDA Object_action_step,x
	AND #%00000111
	TAY 
	LDA (temp16),y
	AND #%00001111
	;;;;;; this is the value of the current object's action.
	STA temp ;; to hold this value
	LDA (temp16),y
	LSR
	LSR
	LSR
	LSR
	STA temp1 ;; temp 1 is now the base value for the animation timer.
	
	;; we'll do the thing, then jump back to the anim bank
	;; this works so long as this function stays in the static bank
	LDY #DATABANK1
	JSR bankswitchY
	LDY temp
	LDA AI_ActionTable_Lo,y
	STA temp16
	LDA AI_ActionTable_Hi,y
	STA temp16+1
	
	JSR doNewActionTrampoline
	JMP pastDoNewActionTrampoline
doNewActionTrampoline:
	JMP (temp16) ;;; this now does the action
			;; and when it hits the RTS in that action,
			;; it will jump back to the last JSR it saw,
			;; which was doNewActionTrampoline...which will immediately
			;; jump to pastDoNewActionTrampoline.
pastDoNewActionTrampoline:
	

	
	
	LDY #BANK_ANIMATIONS
	JSR bankswitchY
	
	;; set new animation timer
	JSR setActionTimer
	JSR getAnimationSpeedAndOffset
	JSR getNewEndType
	

	RTS
	
	
	
	
	
setActionTimer:

	LDY Object_type,x
	LDA ObjectBehaviorTableLo,y
	STA temp16
	LDA ObjectBehaviorTableHi,y
	STA temp16+1
	
	LDA Object_action_step,x
	AND #%00000111
	TAY
	LDA (temp16),y
	LSR
	LSR
	LSR
	LSR
	BNE timerIsNotRandom
	;; timer is random.
	JSR GetRandomNumber
	AND #%01111111
	;CLC
	;ADC #%00100000
	JMP gotNewActionTimerValue
timerIsNotRandom:
	;;temp1 is loaded
	;ASL
	;ASL
	ASL
	ASL
	ASL
	ASL

gotNewActionTimerValue:
	
	STA Object_action_timer,x

	RTS
	
	
	
getAnimationSpeedAndOffset:
		JSR getAnimOffset
getAnimSpeed:
	;;; assumes Object_animation_offset_speed,x is in A
		;;; set the initial animation timer
		AND #%00001111 ;; now we have the animation speed value displayed in the tool
						;; are 16 values enough for the slowest?  Or do we want to have multiples?  Or maybe a table read?	
		ASL
		STA Object_animation_timer,x
	RTS
	
	
getNewEndType:

		;; must be in anim bank
		LDY Object_type,x
		LDA EndActionAnimationTableLo,y
		STA temp16
		LDA EndActionAnimationTableHi,y
		STA temp16+1
		LDA Object_action_step,x
		AND #%00000111
		TAY
		LDA (temp16),y
		STA Object_end_action,x ;; both action and animation
	RTS
	
	
	
	
getAnimOffset:
		LDY Object_type,x
		;; now we have to get animation offset and speed based on the animation associated with this action.
		;; we need to do a double look up - get the address from the lut, and then action-steps indexed from there.
		LDA ObjectAnimationSpeedTableLo,y ;; again, y is the type of object
		STA temp16
		LDA ObjectAnimationSpeedTableHi,y 
		STA temp16+1
		LDA Object_action_step,x
		AND #%00000111
		TAY
		LDA (temp16),y
		;AND #%11110000
		STA Object_animation_offset_speed,x
	RTS
	
	
	
countAllMonsters:
	
	TXA
	STA tempx
	.include SCR_CHECK_FOR_MONSTER_LOCKS
	
	LDX tempx
	RTS
	
countAllTargets:
	TXA
	STA tempx
	LDA #$00
	STA targetCounter
	LDX #$00
countTargetsLoop:
	LDA Object_status,x
	BEQ skipThisTargetForCounter
	LDy Object_type,x
	LDA ObjectFlags,y
	AND #%00100000 ;; is it a target?  
	BEQ skipThisTargetForCounter
	INC targetCounter
skipThisTargetForCounter:
	INX 
	CPX #TOTAL_MAX_OBJECTS
	BNE countTargetsLoop
	LDX tempx
;;;;; what to do if no more objects?
	LDA targetCounter
	
	BNE stillTargetsOnScreen

	;;;;;;==================There are no more objects
	;;;;;;we would like to turn tile x (door = solid) into tile 0 (walkable)
	;;;;;; how can we check the whole screen for this without changing game states?
	;;;;;; if we put this into a wait frame, what happens?
	;;;;;;;CHECK A SCREEN FLAG to know if we should flip this trigger when triggers are gone
	TriggerScreen screenType
	;;;;;;;;;
	
	
	LDY #$00 ;; or, first room collision tile
FindLockedDoorTilesTarget:
	
	LDA collisionTable,y
	CMP #$06 ;; compare to locked door target type
	BNE notALockedDoorTarget
	LDA #$00
	STA collisionTable,y ;; collision table is changed.
						;; graphics are a little trickier

	TYA
	STA tempy
	JSR ConvertCollisionToNT
	
	;;; SELECT TILES TO UPDATED UNDERNEATH
	LDA #$00
	STA updateTile_00
	LDA #$01
	STA updateTile_01
	LDA #$10
	STA updateTile_02
	LDA #$11
	STA updateTile_03
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	JSR HandleUpdateNametable		
	JSR WaitFrame
	LDY tempy
	

notALockedDoorTarget:
	INY
	CPY #$F0 ;; or last room collision tile - offset for hud?
	BNE FindLockedDoorTilesTarget

	;;;;;===================
stillTargetsOnScreen:
;;;;  end what to do if no more objects	
	
	LDX tempx
	RTS
	
	
UpdateDrawOrder:
	LDX #$1
OrderLoop:

	LDY drawOrder,x
	LDA Object_y_hi,y
	STA temp
	;;;; what would drawOrder-1 be?  if it is 0, would would have to become 0f.
	
	LDY drawOrder-1,x
	LDA Object_y_hi,y
	CMP temp
	BCS doneWithSwapItem
	LDA drawOrder,x
	STA drawOrder-1,x
	TYA
	STA drawOrder,x
doneWithSwapItem:
	INX
	CPX #TOTAL_MAX_OBJECTS
	BNE OrderLoop
	RTS
	

	
.include SCR_HANDLE_OBJECT_COL