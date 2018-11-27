;;blank
	CPX player1_object
	BEQ pickUpShrub
	JMP dontPickUpShrub
pickUpShrub:
	;;; add this redundancy because all six collisionPoints will be checked
	;;; before this routine is called.  It would run this multiple times (up to 6)
	;;; but if this routine has run once, then the collisionTable value here
	;;; will be zero, meaning don't do it anymore.
	JSR GetTileAtPosition
	LDA collisionTable,y
	BNE keepCheckingToSeeIfWeCanPickUp
	JMP dontPickUpShrub
keepCheckingToSeeIfWeCanPickUp:
	;; this may have anomalous results if your player's bbox width is wider that 16
	
	TXA
	STA tempx
	;; y should still hold collision type, I think?
	LDA gamepad
	AND #%00000010
	BNE pickUpShrub2
	JMP dontPickUpShrub
pickUpShrub2:

	;; we'll check points two and three, which are the bottom (whereas one and two are the top, and
	;; five and size are the vertical middle).  If they're the same we want to continue, as it means
	;; they both saw the collision.
	LDA collisionPoint2
	CMP collisionPoint3
	BEQ twoThreeSame
	JMP dontPickUpShrub
twoThreeSame:
	;;; lastly, are we on the ground?  We can't check this if we're in the air.
	;LDA Object_status,x
	;AND #%00000100 ;; is it 'in air', that's what this status bit means.
	;BEQ notInAirForThisTileType
	;JMP dontPickUpShrub
notInAirForThisTileType:

	ChangeTileAtCollision #$00, #$00
	

	LDX tempx
	JSR LaunchPowerup
	
	AddValue #$06, myScore, #$01, #$00
	
	

	;;; we also need to set up the routine to update the HUD
	;; for this to work right, health must be a "blank-then-draw" type element.
	;STA hudElementTilesToLoad
	;	LDA #$00
	;	STA hudElementTilesMax
		LDA DrawHudBytes
		ora #HUD_myScore
		STA DrawHudBytes
		
	PlaySound #SFX_GET_COIN
	LDX tempx

dontPickUpShrub:
	