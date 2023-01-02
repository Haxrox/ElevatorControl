`timescale 1ns / 1ps
`include "types.sv"

module tb_hax_elevator_top();
    logic [3:0] KEY;
    logic [9:0] SW;
    logic [9:0] LEDR;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic CLOCK_50 = 0;

    hax_elevator_top #(.DELAY_THRESHOLD(5)) hax_elevator_top_inst(.*);

    always #1 CLOCK_50 = ~CLOCK_50;

    function floor_t value(logic [6:0] hex); 
    begin
        case (hex)
            7'b100_0000: value = 0;
            7'b111_1001: value = 1;
            7'b010_0100: value = 2;
            7'b011_0000: value = 3;
            7'b001_1001: value = 4;
            7'b001_0010: value = 5;
            7'b000_0010: value = 6;
            7'b111_1000: value = 7;
            7'b000_0000: value = 8;
            7'b001_0000: value = 9;
            default: value = 0;
        endcase
    end
    endfunction

    function logic [6:0] hex(floor_t floor); 
    begin
        case (floor)
            0: hex = 7'b100_0000;
            1: hex = 7'b111_1001;
            2: hex = 7'b010_0100;
            3: hex = 7'b011_0000;
            4: hex = 7'b001_1001;
            5: hex = 7'b001_0010;
            6: hex = 7'b000_0010;
            7: hex = 7'b111_1000;
            8: hex = 7'b000_0000;
            9: hex = 7'b001_0000;
            default: hex = 7'b111_1111;
        endcase
    end
    endfunction

    task select_floor;
        input floor_t floor;
    begin
        SW = floor;
        KEY[3] = 0;
        @(posedge CLOCK_50); @(negedge CLOCK_50);
        KEY[3] = 1;

        @(posedge CLOCK_50); @(negedge CLOCK_50);
        assert(LEDR[0]);
        assert(HEX2 === hex(floor));
        assert(LEDR[1] === floor > value(HEX1));
        assert(LEDR[2] === floor < value(HEX1));

        wait(~LEDR[0]);

        assert(~LEDR[0]);
        assert(value(HEX1) === floor);
    end
    endtask

    initial begin
        KEY[0] = 0;
        @(posedge CLOCK_50);
        KEY[0] = 1;

        @(negedge CLOCK_50);

        select_floor(7);
        select_floor(4);
        select_floor(5);
        select_floor(0);
        select_floor(7);
        select_floor(0);

        @(posedge CLOCK_50);
        @(posedge CLOCK_50);

        $display("tb_hax_elevator_top: PASSED");
        $stop;
    end
endmodule : tb_hax_elevator_top