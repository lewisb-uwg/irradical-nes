
	
GamePadCheck:
	LDA #$01
	STA $4016
	LDA #$00
	STA $4016
	LDA #$80
	STA gamepad
	
ReadControllerBytesLoop:
	LDA $4016
	AND #%00000011
	CMP #%00000001
	ROR gamepad
	BCC ReadControllerBytesLoop
	
	LDA gamepad
	AND #%11000000 ; isolates lr
	CMP #%11000000 ; if both aren't pressed, don't worry about filtering
	BNE ReadLR_NoFilter
	;;; in this instance, both left and right are pressed at the same time.
	EOR gamepad  ;; clears both bits
	STA gamepad
ReadLR_NoFilter:
	LDA gamepad
	AND #%00110000
	CMP #%00110000 ;; if both up and down are not pressed, don't worry about filtering
	BNE ReadUD_NoFilter
	;; up and down are simultaeneously pressed
	EOR gamepad ;; clears both bits
	STA gamepad
ReadUD_NoFilter:
	RTS