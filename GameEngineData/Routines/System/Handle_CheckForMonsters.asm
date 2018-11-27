;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;
;;;;;;;;ASSUMES MONSTER BLOCK TYPE IS #$06.
;;;;;;;;You can change this where it says "FIND MONSTER TYPE HERE" below
;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;To change collision type and graphic

	LDA #$00
	STA monsterCounter
	
	LDX #$00
countMonstersLoop_screenLoad:
	LDA Object_status,x
	BEQ skipThisMonsterForCounter_screenLoad
	LDy Object_type,x
	LDA ObjectFlags,y
	AND #%00001000 ;; is it a monster?  ignore mon projs?
	BEQ skipThisMonsterForCounter_screenLoad
	INC monsterCounter
skipThisMonsterForCounter_screenLoad:
	INX 
	CPX #TOTAL_MAX_OBJECTS
	BNE countMonstersLoop_screenLoad
	LDX tempx
;;;;; what to do if no more objects?
	LDA monsterCounter
	BEQ notstillMonstersOnScreen_onScreenload 
	JMP stillMonstersOnScreen_onScreenload
notstillMonstersOnScreen_onScreenload:
	
GetRidOfLocks:
	LDY #$00 ;; or, first room collision tile
FindLockedDoorTilesMonsters_onScreenLoad:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; FIND MONSTER BLOCK TYPE HERE
	LDA collisionTable,y
	CMP #$06 ;; compare to monster block door target type
			;; if your monster block door type is NOT type number 5
			;; then change this to the correct value.
	BEQ notnotALockedDoorMonsters_onScreenLoad
	JMP notALockedDoorMonsters_onScreenLoad
notnotALockedDoorMonsters_onScreenLoad:
	
	LDA update_screen
	BNE screenIsOff
	LDA #$00
	STA collisionTable,y ;; collision table is changed.
	ChangeTile #$00, underSlash
	TriggerScreen screenType
	PlaySound #SFX_MONSTER_LOCK
	JSR WaitFrame
	JMP notALockedDoorMonsters_onScreenLoad
screenIsOff:
	LDA mon1SpawnData
	ORA mon1SpawnData+1
	ORA mon1SpawnData+2
	ORA mon1SpawnData+3
	BNE notALockedDoorMonsters_onScreenLoad
	LDA #$00
	STA collisionTable,y ;; collision table is changed.
	JSR ConvertCollisionToNT
	LDA temp16
	STA $2006
	LDA temp16+1
	STA $2006
	LDA underSlash
	STA $2007
	

	LDA underSlash
	CLC
	ADC #$01
	STA $2007
	
	
	LDA temp16+1
	CLC
	ADC #$20
	STA temp16+1
	LDA temp16
	ADC #$00
	STA temp16
	
	LDA temp16
	CLC
	STA $2006
	LDA temp16+1
	STA $2006
	LDA underSlash
	CLC
	ADC #$10
	STA $2007
	
	LDA underSlash
	CLC
	ADC #$11
	STA $2007

notALockedDoorMonsters_onScreenLoad:
	INY
	CPY #$F0 ;; or last room collision tile - offset for hud?
	BEQ doneFindLockedDoorTilesMonsters_onScreenLoad
	JMP FindLockedDoorTilesMonsters_onScreenLoad
doneFindLockedDoorTilesMonsters_onScreenLoad:

	;;;;;===================
stillMonstersOnScreen_onScreenload:
;;;;  end what to do if no more objects