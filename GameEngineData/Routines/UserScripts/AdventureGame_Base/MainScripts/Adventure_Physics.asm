CalculateAccAndSpeed:
	LDA update_screen
	BEQ doPhysics
	RTS
doPhysics:
	LDA currentBank
	STA prevBank
	LDY #BANK_ANIMS
	JSR bankswitchY
;;;; first, let's just make it move based on selected speed.  Then we'll worry about acceleration.
	;; Load Y with object type for table reads
	;; current object is loaded in x
	
	LDA Object_status,x
	AND #%11111011
	STA Object_status,x ;; clear out on edge bit
	
	
	LDA Object_x_hi,x
	STA xPrev
	LDA Object_y_hi,x
	STA yPrev
	
	LDA Object_vulnerability,x
	AND #%00000001 ;; for now, this is set to ignoring the physics engine movement
				;; so it won't observe acc/dec, but will observe direct movement.
				;; good for objects that are 'moving towrds' other objects.
				;; will this ignore collisions?  hm.
	BNE ignoringPhysics
	JMP notIgnoringPhysics
ignoringPhysics:
	;;; ignore physics.
	;;; do simple movement.
	
	;;;;; maybe we have another that checks for projectile movement specifically?
	;; below handles projectile movement, for which there still needs to be directions
	;; defined to know whether to add or subtract from the values
	;; this is a way to give it different speeds?
	LDY Object_type,x
	LDA ObjectMaxSpeed,y
	LSR
	LSR
	LSR
	LSR
	LSR
	BNE gotNumberOfLoops
	;; if it was zero, make it at least 1
	LDA #$01
gotNumberOfLoops:
	STA temp3 ;; now use temp 3 to loop through to give faster and faster speed?
	;; this observes the *high speed* only

	LDA Object_h_speed_lo,x
	SEC
	SBC #$80
	STA temp
	BMI subFromXPos
	

	LDA Object_x_lo,x
	CLC
	ADC temp
	STA xHold_lo
	LDA Object_x_hi,x
	ADC #$00
	STA xHold_hi
	
	LDY #$00
hLoop0:		
	LDA xHold_lo
	CLC
	ADC temp
	STA xHold_lo
	LDA xHold_hi
	ADC #$00
	STA xHold_hi
	INY
	CPY temp3
	BNE hLoop0 ;; do this loop until max speed hi is reached.
				;; this should help it at least somewhat
				;; still observe speed
	
	LDY Object_type,x
	
	JSR JustDoHsolidAndBoundsCheck

	JMP doneWithHprojMovement
	
subFromXPos:
	LDA #$00
	SEC
	SBC temp
	STA temp

	LDA Object_x_lo,x
	sec
	sbc temp
	STA xHold_lo
	LDA Object_x_hi,x
	sbc #$00
	STA xHold_hi
	
	LDY #$00
hLoop1:
	LDA xHold_lo
	sec
	sbc temp
	STA xHold_lo
	LDA xHold_hi
	sbc #$00
	STA xHold_hi
	INY 
	CPY temp3
	BNE hLoop1
	
	LDY Object_type,x
	JSR JustDoHsolidAndBoundsCheck
doneWithHprojMovement:	
;;; do vertical chasing movement
	

	LDA Object_v_speed_lo,x
	SEC
	SBC #$80
	STA temp
	BMI subFromYPos


	LDA Object_y_lo,x
	sec
	sbc temp
	STA yHold_lo
	LDA Object_y_hi,x
	sbc #$00
	STA yHold_hi

	LDY #$00
vLoop0:
	LDA yHold_lo
	sec
	sbc temp
	STA yHold_lo
	LDA yHold_hi
	sbc #$00
	STA yHold_hi
	INY
	CPY temp3
	BNE vLoop0
	
	LDY Object_type,x
	JSR JustDoVsolidAndBoundsCheck


	JMP doneWithVprojMovement
	
subFromYPos:
	LDA #$00
	SEC
	SBC temp
	STA temp

	LDA Object_y_lo,x
	clc
	adc temp
	STA yHold_lo
	LDA Object_y_hi,x
	adc #$00
	STA yHold_hi
	
	LDY #$00
vLoop1:
	LDA yHold_lo
	clc
	adc temp
	STA yHold_lo
	LDA yHold_hi
	adc #$00
	STA yHold_hi
	INY 
	CPY temp3
	BNE vLoop1
	
	LDY Object_type,x
	
	JSR JustDoVsolidAndBoundsCheck

doneWithVprojMovement:

	JMP DoneWithAllMovement
	
	
	
notIgnoringPhysics:
	
	LDY Object_type,x

;;=======================
;; FIGURE OUT HORIZONTAL DIRECTION, L or R
	;; first we're going to unpack speed and acceleration into temp variables.
	;; at the end of the routine, we will pack speed back up appropriately
	;; CHECK OBJECT CONTROL (hurt)
	LDA Object_status,x
	AND #%00000001 ;; is it invincible AND out of control of movement?
	BEQ objectControlsOwnMovement
	;; object is out of control, probably because hurt.
	;; this means 'knock back speed' can exceed max speed, etc.
	JSR UpdateHorizontalPosition
	JSR UpdateVerticalPosition
	JMP DoneWithAllMovement
	
objectControlsOwnMovement:

	LDA ObjectMaxSpeed,y
	ASL
	ASL
	ASL
	STA temp2 ;; temp2 now equals acc lo
	LDA ObjectMaxSpeed,y
	LSR
	LSR
	LSR
	LSR
	LSR
	STA temp3 ;; temp3 now equals acc hi
	
	;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;
	;now we can proceed with 16 bit movement calculations
	;; and at the end, we can restore h speed

	
	LDA Object_movement,x
	AND #%10000000
	BEQ decH ;; it is not accelerating in the horizontal axis
				;; so check to see if it is still moving horizontally speed wise
				;; and if so, do decceleration.
	;;here, it IS accelerating horizontally, so check L or RTS
	LDA Object_movement,x
	AND #%01000000
	BEQ notMovingRight ;; bit 6 denotes whether horizontal movement is moving object
						;; left or right.
	;; if it was one, it is moving to the right.
	;;;; ============
	;; RIGHT MOVEMENT
	;;;; ============
	LDA Object_h_speed_lo,x
	CLC
	ADC ObjectAccAmount,y
	STA Object_h_speed_lo,x
	LDA Object_h_speed_hi,x
	ADC #$00
	STA Object_h_speed_hi,x
	;; max speed check
	LDA Object_h_speed_lo,x
	CMP temp2
	LDA Object_h_speed_hi,x
	SBC temp3
	BVC maxHspeedCheck
	EOR #$80
maxHspeedCheck:
	BPL maxHspeedReached
	JSR UpdateHorizontalPosition ;; max speed has not been reached, still accelerating
							;; so skip limiting to max speed
	JMP VerticalMovement
maxHspeedReached:
	;; force h speed to max speed.
	LDA temp2
	STA Object_h_speed_lo,x
	LDA temp3
	STA Object_h_speed_hi,x
	JSR UpdateHorizontalPosition
	JMP VerticalMovement
notMovingRight:



	;;;; moving left
	;;;; values are already exploded.
	LDA Object_h_speed_lo,x
	SEC
	SBC ObjectAccAmount,y
	STA Object_h_speed_lo,x
	LDA Object_h_speed_hi,x
	SBC #$00
	STA Object_h_speed_hi,x
	
	LDA Object_h_speed_lo,x
	CLC
	ADC temp2
	LDA Object_h_speed_hi,x
	ADC temp3
	
	BPL maxHspeedNotReachedL
	LDA #$00
	SEC 
	SBC temp2
	STA Object_h_speed_lo,x
	LDA #$00
	SBC temp3
	STA Object_h_speed_hi,x
	
maxHspeedNotReachedL:
	JSR UpdateHorizontalPosition
	JMP VerticalMovement
decH:	
	;;; horizontal deceleration 
		;;;; if either of the hspeeds are greater than zero
		;;; that means we should continue to decelerate.
	LDA Object_h_speed_lo,x
	BNE continueHdecel
	LDA Object_h_speed_hi,x
	BNE continueHdecel
	JMP noDecH
continueHdecel:
	;LDA Object_h_speed_lo,x
	;CLC
	;ADC #$00
	;LDA Object_h_speed_hi,x
	;BPL HisAboveZero ;; jump to calculate below zero decH

	LDA Object_movement,x
	AND #%01000000
	BNE HisAboveZero
	
	LDA Object_h_speed_lo,x
	CLC
	ADC ObjectAccAmount,y
	STA Object_h_speed_lo,x
	LDA Object_h_speed_hi,x
	ADC #$00
	STA Object_h_speed_hi,x
	;;; now check against zero
	LDA Object_h_speed_lo,x
	CLC
	ADC #$00
	LDA Object_h_speed_hi,x
	ADC #$00
	BMI noDecH

	LDA #$00
	STA Object_h_speed_lo,x
	STA Object_h_speed_hi,x
	JMP noDecH
HisAboveZero:
	
	LDA Object_h_speed_lo,x
	SEC
	SBC ObjectAccAmount,y
	STA temp
	LDA Object_h_speed_hi,x
	SBC #$00
	STA temp1
	;; check against zoer
	;LDA Object_h_speed_lo,x
	;CLC
	;ADC #$00
	;LDA Object_h_speed_hi,x
	;ADC #$00
	BMI stopHdec
	LDA temp
	STA Object_h_speed_lo,x
	LDA temp1
	STA Object_h_speed_hi,x
	JMP noDecH
stopHdec:
	LDA #$00
	STA Object_h_speed_lo,x
	STA Object_h_speed_lo,x
	
noDecH:
	
	JSR UpdateHorizontalPosition
	
;;;;;;;;;;;=======================
;;---VERTICAL MOVEMENT------------
;;;;;;;;;;========================
VerticalMovement:	
	;; y was corrupted for collision table lookup
	;; restore to object type here for acc read and such
	LDY Object_type,x
	
	LDA Object_movement,x
	AND #%00100000
	BEQ decV ;; it is not accelerating in the horizontal axis
				;; so check to see if it is still moving horizontally speed wise
				;; and if so, do decceleration.
	;;here, it IS accelerating horizontally, so check L or RTS

	LDA Object_movement,x
	AND #%00010000
	BEQ notMovingDown ;; bit 6 denotes whether horizontal movement is moving object
						;; left or right.
	;; if it was one, it is moving to the right.

	;;;; ============
	;; Down MOVEMENT
	;;;; ============

	LDA Object_v_speed_lo,x
	CLC
	ADC ObjectAccAmount,y
	STA Object_v_speed_lo,x
	LDA Object_v_speed_hi,x
	ADC #$00
	STA Object_v_speed_hi,x
	;; max speed check
	LDA Object_v_speed_lo,x
	CMP temp2
	LDA Object_v_speed_hi,x
	SBC temp3
	BVC maxVspeedCheck
	EOR #$80
maxVspeedCheck:
	BPL maxVspeedReached
	JMP UpdateVerticalPosition ;; max speed has not been reached, still accelerating
							;; so skip limiting to max speed
maxVspeedReached:
	;; force h speed to max speed.
	LDA temp2
	STA Object_v_speed_lo,x
	LDA temp3
	STA Object_v_speed_hi,x
	JMP UpdateVerticalPosition
	
notMovingDown:
	;;;; moving Up
	;;;; values are already exploded.
	LDA Object_v_speed_lo,x
	SEC
	SBC ObjectAccAmount,y
	STA Object_v_speed_lo,x
	LDA Object_v_speed_hi,x
	SBC #$00
	STA Object_v_speed_hi,x
	
	LDA Object_v_speed_lo,x
	CLC
	ADC temp2
	LDA Object_v_speed_hi,x
	ADC temp3
	
	BPL maxVspeedNotReachedL
	LDA #$00
	SEC 
	SBC temp2
	STA Object_v_speed_lo,x
	LDA #$00
	SBC temp3
	STA Object_v_speed_hi,x
	
maxVspeedNotReachedL:
	JMP UpdateVerticalPosition
	
decV:	
	;;; horizontal deceleration 
		;;;; if either of the hspeeds are greater than zero
		;;; that means we should continue to decelerate.
	LDA Object_v_speed_lo,x
	BNE continueVdecel
	LDA Object_v_speed_hi,x
	BNE continueVdecel
	JMP noDecV
continueVdecel:
	;LDA Object_h_speed_lo,x
	;CLC
	;ADC #$00
	;LDA Object_h_speed_hi,x
	;BPL HisAboveZero ;; jump to calculate below zero decH

	LDA Object_movement,x
	AND #%00010000
	BNE VisAboveZero
	
	LDA Object_v_speed_lo,x
	CLC
	ADC ObjectAccAmount,y
	STA Object_v_speed_lo,x
	LDA Object_v_speed_hi,x
	ADC #$00
	STA Object_v_speed_hi,x
	;;; now check against zero
	LDA Object_v_speed_lo,x
	CLC
	ADC #$00
	LDA Object_v_speed_hi,x
	ADC #$00
	BMI noDecV

	LDA #$00
	STA Object_v_speed_lo,x
	STA Object_v_speed_hi,x
	JMP noDecV
VisAboveZero:
	
	LDA Object_v_speed_lo,x
	SEC
	SBC ObjectAccAmount,y
	STA temp
	LDA Object_v_speed_hi,x
	SBC #$00
	STA temp1
	;; check against zoer
	;LDA Object_h_speed_lo,x
	;CLC
	;ADC #$00
	;LDA Object_h_speed_hi,x
	;ADC #$00
	BMI stopVdec
	LDA temp
	STA Object_v_speed_lo,x
	LDA temp1
	STA Object_v_speed_hi,x
	JMP noDecV
stopVdec:
	LDA #$00
	STA Object_v_speed_lo,x
	STA Object_v_speed_lo,x
	
noDecV:
	JSR UpdateVerticalPosition

DoneWithAllMovement:	

	LDY prevBank
	JSR bankswitchY
	
	RTS
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
handleSolidCollision:
	
	LDA Object_edge_action,x
	LSR
	LSR
	LSR
	LSR
	BEQ doNothingAtSolid
	STA temp
	LDA currentBank
	STA prevBank
	LDY #DATABANK1
	JSR bankswitchY
	
	LDY temp
	
	LDA AI_ReactionTable_Lo,y
	STA temp16
	LDA AI_ReactionTable_Hi,y
	STA temp16+1
	
	JSR doReactionTrampolineSolid
	JMP pastReactionTrampolineSolid
doReactionTrampolineSolid:
	JMP (temp16) ;;; this now does the action
			;; and when it hits the RTS in that action,
			;; it will jump back to the last JSR it saw,
			;; which was doNewActionTrampoline...which will immediately
			;; jump to pastDoNewActionTrampoline.
pastReactionTrampolineSolid:
	
	LDY prevBank
	JSR bankswitchY
doNothingAtSolid:
	
	RTS

	
	
UpdateHorizontalPosition:

	;;; do collision detection and handling first
	
	LDA Object_x_lo,x
	CLC
	ADC Object_h_speed_lo,x
	STA xHold_lo

;	STA Object_x_lo,x
	LDA Object_x_hi,x
	ADC Object_h_speed_hi,x
	STA xHold_hi
	STA tileX
	;STA Object_x_hi,x	
JustDoHsolidAndBoundsCheck: ;; use this for projectile / chase movement	 
	LDA Object_y_hi,x
	STA yHold_hi
	
	LDA #$00
	STA tile_solidity
	
	JSR HandleHorizontalBounds
	
	LDA tile_solidity

	BNE noCollisionHere_h

	;;; check for h collision
	JSR HandleTileCollision  ;; would be the same as collision, since metatables and collision table are the same size.
								;; corrupts temp.  Temp z is now the index.
	LDA tile_solidity
								
	;; ACCUM holds either 0 or 1, solid or not solid.
	BEQ noCollisionHere_h
stopMovingH
	LDA #$00
	STA Object_h_speed_hi,x
	STA Object_h_speed_lo,x
	
	JSR handleSolidCollision
	
	JMP doneWithHorizontalMovement
noCollisionHere_h:
	LDA xHold_lo
	STA Object_x_lo,x
	LDA xHold_hi
	STA Object_x_hi,x

doneWithHorizontalMovement:
	RTS
	
	
	
	

UpdateVerticalPosition:
	;;; do collision detection and handling first
	
	LDA Object_y_lo,x
	CLC
	ADC Object_v_speed_lo,x
	STA yHold_lo
	LDA Object_y_hi,x
	ADC Object_v_speed_hi,x
	STA yHold_hi
	STA tileY

JustDoVsolidAndBoundsCheck
	
	LDA Object_x_hi,x
	STA xHold_hi
	
	LDA #$00
	STA tile_solidity ;; default
	
	JSR HandleVerticalBounds

	
	LDA tile_solidity
	BNE noCollisionHere_v
	
	
	
	JSR HandleTileCollision  ;; would be the same as collision, since metatables and collision table are the same size.
								;; corrupts temp.  Temp z is now the index.
	;; accum holds either 0 or 1, solid or not solid
	LDA tile_solidity
	BEQ noCollisionHere_v
stopMovingV:
	LDA #$00
	STA Object_v_speed_hi,x
	STA Object_v_speed_lo,x
	
	JSR handleSolidCollision
	
	JMP doneWithVerticalMovement
noCollisionHere_v:

	LDA yHold_lo
	STA Object_y_lo,x
	LDA yHold_hi
	STA Object_y_hi,x


doneWithVerticalMovement:
	RTS