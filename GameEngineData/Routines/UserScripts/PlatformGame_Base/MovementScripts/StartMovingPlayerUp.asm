    StartMoving player1_object, MOVE_UP
    LDX player1_object
    LDA Object_movement,x
    ORA #%00000100
    STA Object_movement,x
    ;;;        000 down
    ;;;        001 down right
    ;;;        010 right
    ;;;        011 up right
    ;;;        100 up
    ;;;        101 up left
    ;;;        110 left
    ;;;        111 down left
    
    
    RTS