package Definitions;

    typedef enum logic[4:0] {
        ADD = 5'b00000,
        SUB = 5'b00001,
        AND = 5'b00010,
        XOR = 5'b00011,
        OR  = 5'b00100,
        NOT = 5'b00101,
        RXOR = 5'b00110,
        LSL = 5'b00111,
        LSR = 5'b01000,
        INC = 5'b01001
    } op_code;

endpackage