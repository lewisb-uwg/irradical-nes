    LDA gamepad
    AND #%11110000
    BNE +
    ChangeObjectState #$00, #$02
+
    RTS