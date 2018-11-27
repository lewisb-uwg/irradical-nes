LDX player1_object
LDA Object_v_speed_hi,x
BPL skipVarJump
LDA #$00
SEC
SBC #$03

STA Object_v_speed_hi,x
skipVarJump:
RTS