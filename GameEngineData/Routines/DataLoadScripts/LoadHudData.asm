
	LDA DrawHudBytes
	BEQ dontUpdateFirstHUDElement
	LDA ActivateHudUpdate
	BEQ dontUpdateFirstHUDElement
	LDA updateHUD_ASSET_TYPE
	CMP #$04
	BEQ dontUpdateFirstHUDElement ;; this is an update chr type, not update hud type
;	AND #%10000000 ;; first hud element.
;	BEQ dontUpdateFirstHUDElement
	;; updating the first element.
	;; the frames to update based on type will have already been figured out.
	;; all this will do is push address values and new tile value, and decrease
	;; the number or tiles to update remaining.
	LDA $2002
	LDA updateHUD_fire_Address_Hi
	STA $2006
	LDA updateHUD_fire_Address_Lo
	STA $2006
	LDA updateHUD_fire_Tile
	STA $2007
	JMP skipUpdateInNMI
	
dontUpdateFirstHUDElement;	
	
	LDA updateOneChrTile
	BEQ skipUpdatingOneChrTile
	

	JMP skipUpdateInNMI
skipUpdatingOneChrTile:
	
	LDA writingText
	BEQ skipUpdateInNMI

	;; draw one character.
	LDA $2002
	LDA updateHUD_fire_Address_Hi
	STA $2006
	LDA updateHUD_fire_Address_Lo
	STA $2006
	LDA updateHUD_fire_Tile
	STA $2007
	;; jmp skipUpdateInNMI
	;LDA #$00
	;STA writingText
skipUpdateInNMI:
