;;;; Choose out of 8 directions.
    JSR GetRandomDirection
    TAY
    LDA DirectionMovementTable,y
    STA temp
    TYA ;; the 0-7 value for direction
    ORA temp
    STA Object_movement,x