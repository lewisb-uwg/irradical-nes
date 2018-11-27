HandleHorizontalBounds:
	LDY Object_type,x
	
	;; check, are we moving right or left?
	LDA Object_movement,x
	AND #%01000000
	BEQ checkLeftPosition
	;; check right position

	LDA xHold_hi
	
	STA temp
	LDA #BOUNDS_RIGHT
	SEC
	SBC ObjectBboxLeft,y
	SEC
	SBC ObjectWidth,y
	CMP temp
	BCc RightBoundsReached
	JMP noBoundsReached
	
checkLeftPosition:
	;;;;
	LDA xHold_hi
	CLC
	ADC ObjectBboxLeft,y
	CLC
	ADC ObjectWidth,y
	STA temp
	LDA #BOUNDS_LEFT
	ADC ObjectBboxLeft,y
	CLC
	ADC ObjectWidth,y
	
	CMP temp
	BCS LeftBoundsReached
	JMP noBoundsReached
	;;;;;
gotHposition_BoundsCheck:
	
RightBoundsReached:
	
	CPX player1_object
	BEQ doScreenRightUpdate
	;; do screen edge action for monster
	JSR doMonsterAtEdge
	JMP noBoundsReached
doScreenRightUpdate:	
	LDA Object_status,x
	AND #%00000001 ;; is it hurt?
	BEQ playerIsNotHurtForRightUpdate
	JSR StopAtEdge
	JMP noBoundsReached
playerIsNotHurtForRightUpdate:
	JSR updateScreenRight
	JMP noBoundsReached
	
LeftBoundsReached:
	
	CPX player1_object
	BEQ doScreenLeftUpdate
	;; do screen edge action for monster
	JSR doMonsterAtEdge
	;JSR doMonsterAtEdge
	JMP noBoundsReached
doScreenLeftUpdate:
LDA Object_status,x
	AND #%00000001 ;; is it hurt?
	BEQ playerIsNotHurtForLeftUpdate
	JSR StopAtEdge
	JMP noBoundsReached
playerIsNotHurtForLeftUpdate:
	JSR StopAtEdge
	;JSR updateScreenLeft
	JMP noBoundsReached
noBoundsReached:


	RTS
	

	
HandleVerticalBounds:
	LDY Object_type,x
	
	;; check, are we moving up or down?
	;LDA Object_movement,x
	;AND #%00110000
	;CMP #%00100000
;; WHERE A TOP DOWN GAME CHECKS MOVEMENT BITS TO SEE WHAT IT SHOULD DO AT THE V EDGE
;;;A PLATFORM GAME CHECKS THE VSPEED
	LDA Object_v_speed_hi,x
	BMI checkTopPosition
	;; check bottom position
	LDA yHold_hi
	
	STA temp
	LDA #BOUNDS_BOTTOM
	SEC
	SBC ObjectBboxTop,y
	SEC
	SBC ObjectHeight,y
	CMP temp
	BCc BottomBoundsReached
	JMP noBoundsReachedv
	
checkTopPosition:
	;;;;
	LDA yHold_hi
	CLC
	ADC ObjectBboxTop,y
	CLC
	ADC ObjectHeight,y
	STA temp
	LDA #BOUNDS_TOP
	ADC ObjectBboxTop,y
	CLC
	ADC ObjectHeight,y
	CLC
	CMP temp
	BCS TopBoundsReached
	LDA #$00
	STA temp
	JMP noBoundsReachedv
	;;;;;
	
BottomBoundsReached:
	CPX player1_object
	BEQ doScreenBottomUpdate
	;; do screen edge action for monster
	JSR doMonsterAtEdge
	JMP noBoundsReachedv
doScreenBottomUpdate:	
	;;;;;;;;;;;;;;; THIS IS A PLAYER
	;;;;;;;;;;;;;;; AT THE BOTTOM OF THE SCREEN.
	;;;;;;;;;;;;;;; IF YOU WANT HIM TO GO TO THE NEXT SCREEN DOWN, LIKE MEGAMAN
	;;;;;;;;;;;;;;; COMMENT OUT EVERYTHING UNTIL changeMapScreenDown
	;;;;;;;;;;;;;;; THIS CODE WILL CAUSE PLAYER DEATH AT BOTTOM OF SCREEN
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		JSR HandlePlayerDeath
		RTS
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;; IF YOU WANT BOTTOM OF THE SCREEN TO BE DEATH, ALL BELOW CODE WILL NEVER BE REACHED
	;;;;; IF YOU WANT BELOW CODE TO BE REACHED, COMMENT OUT THE ABOVE LINES
changeMapScreenDown:
	LDA Object_status,x
	AND #%00000001 ;; is it hurt?
	BEQ playerIsNotHurtForBottomUpdate
	JSR StopAtEdge
	JMP noBoundsReachedv
playerIsNotHurtForBottomUpdate:
	JSR updateScreenBottom
	JMP noBoundsReachedv
	
TopBoundsReached:
	CPX player1_object
	;BEQ doScreenTopUpdate
	;; do screen edge action for monster
	JSR doMonsterAtEdge
	;JSR doMonsterAtEdge
	JMP noBoundsReachedv
doScreenTopUpdate:
	LDA Object_status,x
	AND #%00000001 ;; is it hurt?
	BEQ playerIsNotHurtForTopUpdate
	JSR StopAtEdge
	JMP noBoundsReachedv
playerIsNotHurtForTopUpdate:
	
	;;;; TO USE TOP AS A BOUNDARY, UNCOMMENT THESE LINES
	;;; == TOP IS A BOUNDARY
	;LDA #$00
	;STA Object_v_speed_hi,x
	;STA Object_v_speed_lo,x
	;LDA #$02
	;STA temp
	;RTS
	;;;;=======END TOP IS A BOUNDARY
	;;;;; TO USE TOP BOUNDS TO GO TO ABOVE MAP SCREEN, COMMENT OUT ABOVE AND UNCOMMENT THESE LINES
	;;;== TOP LEADS TO ABOVE MAP SCREEN
	JSR updateScreenTop
	LDA #$01
	STA temp
	rts
	;;;;====== END TOP LEADS TO ABOVE MAP SCREEN.
noBoundsReachedv:
	LDA #$00
	STA temp
	RTS
	
	
	
	
	
	
	
	
	
	
	
doMonsterAtEdge:
	LDA Object_status,x
	ORA #%00000100 ;; on edge.
	STA Object_status,x
	LDA Object_status,x
	AND #%00000001
	BEQ doNormalMonsterEdgeSolidAction
	JSR StopAtEdge
	rts
doNormalMonsterEdgeSolidAction:
	
	JSR StopAtEdge
	LDA Object_edge_action,x
	AND #%00001111
	BEQ doNothingAtEdge
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
	

	
	JSR doReactionTrampoline
	JMP pastReactionTrampoline
doReactionTrampoline:
	JMP (temp16) ;;; this now does the action
			;; and when it hits the RTS in that action,
			;; it will jump back to the last JSR it saw,
			;; which was doNewActionTrampoline...which will immediately
			;; jump to pastDoNewActionTrampoline.
pastReactionTrampoline:
	
	LDY prevBank
	JSR bankswitchY
doNothingAtEdge:
	RTS
	

StopAtEdge:
	;LDA yPrev
	;STA Object_y_hi,x
	;STA yHold_hi
	;LDA #$00
	;STA Object_y_lo,x
	;STA yHold_lo
	
	LDA xPrev
	STA Object_x_hi,x
	STA xHold_hi
	LDA #$00
	STA Object_x_lo,x
	STA xHold_lo
	
	STA Object_h_speed_hi,x
	STA Object_h_speed_lo,x
	;STA Object_v_speed_hi,x
	;STA Object_v_speed_lo,x
	
	LDA Object_movement,x
	AND #%00001111
	STA Object_movement,x
	RTS
	
	
	
	
	
	
updateScreenRight
	
	;;; check if side triggers change screen...for instance, if hurt, wouldn't, and would instead return *solid*
	LDA #BOUNDS_LEFT
	CLC
	ADC #$2
	STA xHold_hi
	STA newX
	LDA #$00
	STA xHold_lo
	
	LDA Object_y_hi,x
	STA newY
	LDA #$00
	STA Object_y_lo,x
	
	LDA #%11000000
				;7 = active
				;6 = 8 or 16 px tiles
			ORA #GS_MainGame
			ORA #%01000000
			STA update_screen
			LDA #%00000001
			STA update_screen_details ;; load from map 1
			LDA currentScreen
			ADC #$01
			STA newScreen
			STA currentScreen
			LSR
			LSR
			LSR
			LSR
			LSR
			STA screenBank
			LDA #$01
			STA screen_transition_type
	LDA #$01
	STA tile_solidity
	LDA #$00
	STA gameHandler
doneWithUpdateRightScreen:
	rts
	
	
updateScreenLeft:	

	LDA #BOUNDS_RIGHT
	SEC
	SBC ObjectWidth,y
	SEC
	SBC ObjectBboxLeft,y
	SEC 
	SBC #$2
	STA xHold_hi
	STA newX
	LDA #$00
	STA xHold_lo
	
	LDA Object_y_hi,x
	STA newY
	LDA #$00
	STA Object_y_lo,x
	
	LDA #%11000000
				;7 = active
				;6 = 8 or 16 px tiles
			ORA #GS_MainGame
			ORA #%01000000
			STA update_screen
			LDA #%00000001
			STA update_screen_details ;; load from map 1
			LDA currentScreen
		
			SEC
			SBC #$01
			STA newScreen
			STA currentScreen
			LSR
			LSR
			LSR
			LSR
			LSR
			STA screenBank
			LDA #$01
			STA screen_transition_type
	LDA #$01
	STA tile_solidity
		LDA #$00
	STA gameHandler
	RTS
	

updateScreenBottom:
	
	LDA #BOUNDS_TOP
	STA yHold_hi
	STA newY
	LDA #$00
	STA yHold_lo
	
	LDA Object_x_hi,x
	STA newX
	
	LDA #%11000000
				;7 = active
				;6 = 8 or 16 px tiles
			ORA #GS_MainGame
			ORA #%01000000
			STA update_screen
			LDA #%00000001
			STA update_screen_details ;; load from map 1
			LDA currentScreen
			ADC #$0F
			STA newScreen
			STA currentScreen
			LSR
			LSR
			LSR
			LSR
			LSR
			STA screenBank
			LDA #$01
			STA screen_transition_type
	LDA #$01
	STA tile_solidity		
	LDA #$00
	STA gameHandler
	rts

updateScreenTop:
	
	LDA #BOUNDS_BOTTOM
	SEC
	SBC ObjectHeight,y
	SEC
	SBC ObjectBboxTop,y
	SEC 
	SBC #$08
	
	STA yHold_hi
	STA newY
	;;; probably because of the jump speed, we need to force the y to be this as well
	;; for platforming.
	STA Object_y_hi,x
	LDA #$00
	STA yHold_lo
	
	LDA Object_x_hi,x
	STA newX
	
	
	LDA #%11000000
				;7 = active
				;6 = 8 or 16 px tiles
			ORA #GS_MainGame
			ORA #%01000000
			STA update_screen
			LDA #%00000001
			STA update_screen_details ;; load from map 1
			LDA currentScreen
			SEC
			SBC #$10
			STA newScreen
			STA currentScreen
			LSR
			LSR
			LSR
			LSR
			LSR
			STA screenBank
			LDA #$01
			STA screen_transition_type
	;LDA #$00
	;STA tile_solidity
	LDA #$00
	STA gameHandler
	RTS
topBoundsNotReached:
	RTS
	