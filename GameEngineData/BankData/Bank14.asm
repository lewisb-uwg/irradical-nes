.include "GameData\DataBank01_Includes.asm"

.include "GameData\TileTypes.asm"

.include "ScreenData\SpecialTiles.dat"

UnderTilesLookup:
	.db #$00, #$18, #$30

LoadUnderTiles:
	LDA graphicsBank
	SEC
	SBC #$10
	TAY
	LDA UnderTilesLookup,y
	STA temp
	LDA backgroundTilesToLoad
	ASL
	ASL
	CLC
	ADC temp
	;;;; now have the tileset+bank offset
		
	TAY
	LDA Special_Tiles,y
	STA underSlash
	INY
	LDA Special_Tiles,y
	STA underStomp
	INY
	LDA Special_Tiles,y
	STA underSecret
	INY
	LDA Special_Tiles,y
	STA underBoss
	RTS

CheckForTriggers:
	.include SCR_CHECK_FOR_TRIGGERS
	RTS
	
CheckForMonsters:
	;.include SCR_CHECK_FOR_MONSTER_LOCKS
	RTS

HandlePickupPowerup:
;;; other is loaded into x
;;; index of other for table reads loade into y
	LDA Object_type,x 
	CMP #$04
	BNE not4typePowerup
	;; is 4 type powerup

	.include Power_Up_00
	JMP doneWithPowerups
not4typePowerup:
	CMP #$05
	BNE not5typePowerup
	;; is 5 type powerup
	.include Power_Up_01
	JMP doneWithPowerups
not5typePowerup:
	CMP #$06
	BNE not6typePowerup
	;; is 6 type powerup
	.include Power_Up_02
	JMP doneWithPowerups
not6typePowerup:
	CMP #$07
	BNE not7typePowerup
	;; is 7 type powerup
	.include Power_Up_03
	JMP doneWithPowerups
not7typePowerup:
doneWithPowerups:
	RTS

AI_ActionTable_Lo:
	.db <AI_Action_00, <AI_Action_01, <AI_Action_02, <AI_Action_03
	.db <AI_Action_04, <AI_Action_05, <AI_Action_06, <AI_Action_07
	.db <AI_Action_08, <AI_Action_09, <AI_Action_10, <AI_Action_11
	.db <AI_Action_12, <AI_Action_13, <AI_Action_14, <AI_Action_15
	
AI_ActionTable_Hi:
	.db >AI_Action_00, >AI_Action_01, >AI_Action_02, >AI_Action_03
	.db >AI_Action_04, >AI_Action_05, >AI_Action_06, >AI_Action_07
	.db >AI_Action_08, >AI_Action_09, >AI_Action_10, >AI_Action_11
	.db >AI_Action_12, >AI_Action_13, >AI_Action_14, >AI_Action_15



AI_Action_00
	.include "Routines\System\AI_ActionRoutines\AI_Action_00.asm"
	RTS
AI_Action_01:
.include "Routines\System\AI_ActionRoutines\AI_Action_01.asm"
	RTS
AI_Action_02
	.include "Routines\System\AI_ActionRoutines\AI_Action_02.asm"
	RTS
AI_Action_03:
	.include "Routines\System\AI_ActionRoutines\AI_Action_03.asm"
	RTS
AI_Action_04:	
	.include "Routines\System\AI_ActionRoutines\AI_Action_04.asm"
	RTS
AI_Action_05
	.include "Routines\System\AI_ActionRoutines\AI_Action_05.asm"
	RTS
AI_Action_06
	.include "Routines\System\AI_ActionRoutines\AI_Action_06.asm"
	RTS
AI_Action_07
	.include "Routines\System\AI_ActionRoutines\AI_Action_07.asm"
	RTS
AI_Action_08
	.include "Routines\System\AI_ActionRoutines\AI_Action_08.asm"
	RTS
AI_Action_09
	.include "Routines\System\AI_ActionRoutines\AI_Action_09.asm"
	RTS
AI_Action_10
	.include "Routines\System\AI_ActionRoutines\AI_Action_10.asm"
	RTS
AI_Action_11
	.include "Routines\System\AI_ActionRoutines\AI_Action_11.asm"
	RTS
AI_Action_12
	.include "Routines\System\AI_ActionRoutines\AI_Action_12.asm"
	RTS
AI_Action_13
	.include "Routines\System\AI_ActionRoutines\AI_Action_13.asm"
	RTS
AI_Action_14
	.include "Routines\System\AI_ActionRoutines\AI_Action_14.asm"
	RTS
AI_Action_15
	.include "Routines\System\AI_ActionRoutines\AI_Action_15.asm"
	RTS
	
	
	
AI_ReactionTable_Lo:
	.db #<Reaction_00, #<Reaction_01, #<Reaction_02, #<Reaction_03
	.db #<Reaction_04, #<Reaction_05, #<Reaction_06, #<Reaction_07
	
AI_ReactionTable_Hi:
	.db #>Reaction_00, #>Reaction_01, #>Reaction_02, #>Reaction_03
	.db #>Reaction_04, #>Reaction_05, #>Reaction_06, #>Reaction_07
	
Reaction_00:
	.include "Routines\System\AI_Reactions\Reaction_00.asm"
	RTS
Reaction_01:
	.include "Routines\System\AI_Reactions\Reaction_01.asm"
	RTS
Reaction_02:
	.include "Routines\System\AI_Reactions\Reaction_02.asm"
	RTS
Reaction_03:
	.include "Routines\System\AI_Reactions\Reaction_03.asm"
	RTS
Reaction_04:
	.include "Routines\System\AI_Reactions\Reaction_04.asm"
	RTS
Reaction_05:
	.include "Routines\System\AI_Reactions\Reaction_05.asm"
	RTS
Reaction_06:
	.include "Routines\System\AI_Reactions\Reaction_06.asm"
	RTS
Reaction_07:
	.include "Routines\System\AI_Reactions\Reaction_07.asm"
	RTS