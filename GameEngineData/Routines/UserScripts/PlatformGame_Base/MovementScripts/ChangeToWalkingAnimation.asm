   
    LDX player1_object
    LDA Object_status,x
    AND #%00000100
    BEQ +
    ChangeObjectState #$01, #$02
    +
  
    RTS