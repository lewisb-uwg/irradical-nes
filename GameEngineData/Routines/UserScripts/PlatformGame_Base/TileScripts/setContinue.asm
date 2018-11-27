	CPX player1_object
	BNE nevermindSettingContinue
	JSR GetTileAtPosition
	LDA collisionTable,y
	BEQ nevermindSettingContinue ;; already tripped this, other points don't need to check.
	LDA currentScreen
	STA continueScreen
	LDA Object_x_hi,x
	STA continuePositionX
	LDA Object_y_hi,x
	STA continuePositionY
	ChangeTileAtCollision #$00, underStomp

nevermindSettingContinue:
	