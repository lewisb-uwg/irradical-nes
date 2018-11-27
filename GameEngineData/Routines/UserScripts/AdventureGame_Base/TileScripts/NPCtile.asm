;;; NPC TILE
	LDA gamepad
	AND #%00000010
	BEQ +
	LDA textBoxFlag
	BNE +
	LDA #$00
	STA stringTemp
	LDA #$01
	STA textBoxFlag
+: