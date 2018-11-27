

	
	LDA OverwriteNT
	BEQ dontUpdateNT_toPPU
	
	LDX #$00
	
;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;
;;JUST UPDATE A TILE
;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;
doUpdateNT_toPPU_loop:
	
;;;;;;;;;DO A LOOP HERE THORUGH ALL 4 possibilities.
	LDA $2002
	LDA updateNT_fire_Address_Hi,x
	STA $2006
	LDA updateNT_fire_Address_Lo,x
	STA $2006
	LDA updateNT_fire_Tile,x
	STA $2007
	INX
	CPX #$04
	BNE doUpdateNT_toPPU_loop
	LDA #$00
	STA OverwriteNT
dontUpdateNT_toPPU:

	LDA UpdateAtt
	BEQ dontUpdateAtt
	
	;;;; UPDATE ATTRIBUTE FOR THIS
	;;; will have to or in the proper values, since only doing 1/4 of an att byte at a time.
	LDA updateNT_fire_att_hi
	STA $2006
	LDA updateNT_fire_att_lo
	STA $2006
	LDA $2007
	LDA $2007 ;; double read necessary to get this value.
	STA temp
	LDA updateNT_fire_att_hi
	STA $2006
	LDA updateNT_fire_att_lo
	STA $2006
	LDA temp
	AND updateNT_attMask
	ORA updateNT_att
	STA $2007
	LDA #$00
	STA UpdateAtt
dontUpdateAtt:

noUpdatesToScreen:
	;JMP skipNMIupdate