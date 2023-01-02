
`ifndef TYPES_SV
    `define TYPES_SV

    package types;
        parameter floor_width = 3;
        typedef enum {IDLE_S, UP_S, DOWN_S} state_t;
        typedef logic [floor_width-1:0] floor_t;
        typedef enum {UP, DOWN, IDLE} direction_t;
        typedef enum {OPEN, CLOSE} door_t;
    endpackage : types

    import types::*;
`endif