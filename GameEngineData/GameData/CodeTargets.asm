;; *************** CodeTargets.asm ***************
;; Code Target data export. Thursday, November 29, 2018 2:13:38 PM
SCR_PHYSICS EQU "Routines\UserScripts\AdventureGame_Base\MainScripts\Adventure_Physics.asm"
SCR_TILE_COLLISION EQU "Routines\UserScripts\AdventureGame_Base\MainScripts\Adventure_TileCollision.asm"
SCR_HANDLE_BOUNDS EQU "Routines\UserScripts\AdventureGame_Base\MainScripts\Adventure_Bounds.asm"
SCR_HANDLE_DRAWING_SPRITES EQU "Routines\UserScripts\AdventureGame_Base\MainScripts\Adventure_Drawing.asm"
SCR_SPRITE_PREDRAW EQU "Routines\UserScripts\AdventureGame_Base\MainScripts\Adventure_PreDraw.asm"
SCR_HANDLE_OBJECT_COL EQU "Routines\System\HandleObjectCollisions.asm"
SCR_HANDLE_PLAYER_WIN EQU "Routines\UserScripts\AdventureGame_Base\HurtWinLoseDeath\Adventure_HandlePlayerWin.asm"
SCR_HANDLE_PLAYER_DEATH EQU "Routines\UserScripts\AdventureGame_Base\HurtWinLoseDeath\Adventure_HandlePlayerDeath.asm"
SCR_LOSE_LIFE EQU "Routines\UserScripts\AdventureGame_Base\HurtWinLoseDeath\Adventure_PlayerLoseLife.asm"
SCR_HANDLE_LOAD_MONSTERS EQU "Routines\System\LoadMonsters.asm"
SCR_HANDLE_FADES EQU "Routines\UserScripts\AdventureGame_Base\BlankScript.asm"
SCR_HANDLE_SCROLL EQU "Routines\UserScripts\AdventureGame_Base\BlankScript.asm"
SCR_HANDLE_GAME_TIMER EQU "Routines\System\HandleGameTimer.asm"
SCR_CHECK_FOR_TRIGGERS EQU "Routines\System\Handle_CheckForTriggers.asm"
SCR_CHECK_FOR_MONSTER_LOCKS EQU "Routines\System\Handle_CheckForMonsters.asm"
SCR_PLAYER_HURT_SCRIPT EQU "Routines\UserScripts\AdventureGame_Base\HurtWinLoseDeath\Adventure_HandlePlayerHurt.asm"
SCR_HANDLE_HURT_MONSTER EQU "Routines\UserScripts\AdventureGame_Base\HurtWinLoseDeath\Adventure_HandleHurtMonster.asm"
SCR_HANDLE_DROPS EQU "Routines\UserScripts\AdventureGame_Base\HurtWinLoseDeath\Adventure_HandleDrops.asm"
SCR_GAMEPAD_READ EQU "Routines\System\GamePadCheck.asm"
Tile_00 EQU "Routines\UserScripts\AdventureGame_Base\TileScripts\NullTile_Walkable.asm"
Tile_01 EQU "Routines\UserScripts\AdventureGame_Base\TileScripts\SolidBehavior.asm"
Tile_02 EQU "Routines\UserScripts\AdventureGame_Base\TileScripts\WarpToScreen.asm"
Tile_03 EQU "Routines\UserScripts\AdventureGame_Base\TileScripts\LockedDoor.asm"
Tile_04 EQU "Routines\UserScripts\AdventureGame_Base\TileScripts\NPCtile.asm"
Tile_05 EQU "Routines\UserScripts\AdventureGame_Base\TileScripts\BreakableBlock.asm"
Tile_06 EQU "Routines\UserScripts\AdventureGame_Base\TileScripts\SolidBehavior.asm"
Tile_07 EQU "Routines\UserScripts\AdventureGame_Base\TileScripts\NullTile_Walkable.asm"
Tile_08 EQU "Routines\UserScripts\AdventureGame_Base\TileScripts\NullTile_Walkable.asm"
Tile_09 EQU "Routines\UserScripts\AdventureGame_Base\TileScripts\NullTile_Walkable.asm"
Tile_10 EQU "Routines\UserScripts\AdventureGame_Base\TileScripts\NullTile_Walkable.asm"
Tile_11 EQU "Routines\UserScripts\AdventureGame_Base\TileScripts\NullTile_Walkable.asm"
Tile_12 EQU "Routines\UserScripts\AdventureGame_Base\TileScripts\NullTile_Walkable.asm"
Tile_13 EQU "Routines\UserScripts\AdventureGame_Base\TileScripts\NullTile_Walkable.asm"
Tile_14 EQU "Routines\UserScripts\AdventureGame_Base\TileScripts\NullTile_Walkable.asm"
Tile_15 EQU "Routines\UserScripts\AdventureGame_Base\TileScripts\NullTile_Walkable.asm"
AI_00 EQU "Routines\UserScripts\AdventureGame_Base\AiScripts\Null_noAction.asm"
AI_01 EQU "Routines\UserScripts\AdventureGame_Base\AiScripts\RandomMovement_8.asm"
AI_02 EQU "Routines\UserScripts\AdventureGame_Base\AiScripts\RandomMovement_4.asm"
AI_03 EQU "Routines\UserScripts\AdventureGame_Base\AiScripts\RandomMovement_2_UD.asm"
AI_04 EQU "Routines\UserScripts\AdventureGame_Base\AiScripts\RandomMovement_2_LR.asm"
AI_05 EQU "Routines\UserScripts\AdventureGame_Base\AiScripts\StopMoving.asm"
AI_06 EQU "Routines\UserScripts\AdventureGame_Base\AiScripts\ShootStraight.asm"
AI_07 EQU "Routines\UserScripts\AdventureGame_Base\AiScripts\ShootTowardsPlayer.asm"
AI_08 EQU "Routines\UserScripts\AdventureGame_Base\AiScripts\Teleport.asm"
AI_09 EQU "Routines\UserScripts\AdventureGame_Base\AiScripts\Null_noAction.asm"
AI_10 EQU "Routines\UserScripts\AdventureGame_Base\AiScripts\Null_noAction.asm"
AI_11 EQU "Routines\UserScripts\AdventureGame_Base\AiScripts\Null_noAction.asm"
AI_12 EQU "Routines\UserScripts\AdventureGame_Base\AiScripts\Null_noAction.asm"
AI_13 EQU "Routines\UserScripts\AdventureGame_Base\AiScripts\Null_noAction.asm"
AI_14 EQU "Routines\UserScripts\AdventureGame_Base\AiScripts\Null_noAction.asm"
AI_15 EQU "Routines\UserScripts\AdventureGame_Base\AiScripts\Null_noAction.asm"
Power_Up_00 EQU "Routines\UserScripts\AdventureGame_Base\PowerUpCode\Powerup_IncreaseHealth.asm"
Power_Up_01 EQU "Routines\UserScripts\AdventureGame_Base\PowerUpCode\Powerup_UnlockProjectile.asm"
Power_Up_02 EQU "Routines\UserScripts\AdventureGame_Base\PowerUpCode\Powerup_Key.asm"
Power_Up_03 EQU "Routines\UserScripts\AdventureGame_Base\PowerUpCode\Powerup_IncreaseMoney.asm"

