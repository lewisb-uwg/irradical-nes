DrawAllSpritesOffScreen:
	LDA #$FE
	LDY #$00
LoopDrawAllSpritesOffScreen:
	STA $0200,y
	INY
	INY
	INY
	INY
	BNE LoopDrawAllSpritesOffScreen
	RTS
	
	
DeactivateAllObjects:
	LDA #$00
	LDY #$0
LoopDeactivateAllObjects:
	STA Object_status,y
	INY
	CPY #TOTAL_MAX_OBJECTS
	BNE LoopDeactivateAllObjects
	RTS
	
	
MoveTowardsPlayer:
	MoveTowardsPoint temp, temp1, temp2, temp3, #$01
	RTS	

ValMonsterCompare:
	.db #%00001000, #%00000100, #%00000010, #%00000001
	
ValToBitTable:
	.db #%10000000, #%01000000, #%00100000, #%00010000, #%00001000, #%00000100, #%00000010, #%00000001
	
ValToBitTable_inverse:
	.db #%00000001, #%00000010, #%000000100, #%00001000, #%00010000, #%00100000, #%01000000, #%10000000
	
DirectionMovementTable:
	
	.db #%00110000, #%11110000, #%11000000, #%11100000, #%00100000, #%10100000, #%10000000, #%10110000

HexShiftTable:
	.db #$00, #$10, #$20, #$30, #$40, #$50, #$60, #$70, #$80, #$90, #$a0, #$b0, #$c0, #$d0, #$e0, #$f0
	
	
.include "ScreenData\WeaponOffset.dat"

