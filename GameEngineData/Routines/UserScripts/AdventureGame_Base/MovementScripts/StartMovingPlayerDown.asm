    LDX player1_object
    GetCurrentActionType player1_object
    CMP #$02 ;; attack
    BEQ ++
    CMP #$01
    BEQ +
    ChangeObjectState #$01, #$04
 +
    StartMoving player1_object, MOVE_DOWN
 ++
     FaceDirection player1_object, FACE_DOWN
    RTS