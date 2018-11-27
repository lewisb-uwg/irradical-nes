    LDX player1_object
    
    LDA gamepad
    AND #%11110000
    BNE skipChangeToidle
    ;LDA onGround
   
    LDA Object_status,x
    AND #%00000100 ;; not on ground
    BEQ skipChangeToidle
    
    
        ChangeObjectState #$00, #$02

skipChangeToidle:
    RTS