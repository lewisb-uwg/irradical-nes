
    LDX player1_object
    GetCurrentActionType player1_object
    CMP #$02 ;; attack
    BEQ +
    ChangeObjectState #$01, #$10
 +
    RTS