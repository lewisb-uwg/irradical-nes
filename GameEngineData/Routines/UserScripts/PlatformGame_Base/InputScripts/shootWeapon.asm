LDX player1_object

	LDA Object_movement,x
    AND #%00000111
    STA temp3
	CMP #%000000010
	BNE notRightForProjShoot
	LDA Object_x_hi,x
	CLC
	ADC #$18
	STA temp
	JMP gotDirForShoot
notRightForProjShoot:
	LDA Object_x_hi,x
	sec
	sbc #$18
	STA temp
gotDirForShoot:
	LDA temp3
	TAY
    LDA DirectionMovementTable,y
    ORA temp3
	STA temp3
	

LDA Object_y_hi,x
STA temp1
LDA preventShooting
BNE +
ChangeObjectState #$03, #$08

CreateObject temp,temp1,#$01, #$00
	LDA temp3
    STA Object_movement,x

LDA #$01
STA preventShooting
+
RTS