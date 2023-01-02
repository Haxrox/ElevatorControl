`timescale 1ns / 1ps
`include "types.sv"

module tb_hax_elevator();
    logic clk = 0;
    logic rst_n, pressed;
    direction_t direction;

    floor_t target, current_floor, destination;

    door_t door_state;
    direction_t elevator_direction;

    hax_elevator #(.DELAY_THRESHOLD(5)) hax_elevator_inst(.*);

    always #1 clk = ~clk;

    task select_floor;
        input floor_t floor;
    begin
        target = floor;
        pressed = 1;
        @(posedge clk); @(negedge clk);
        pressed = 0;

        assert(door_state === CLOSE);
        assert(destination === floor);
        assert(elevator_direction === (floor > current_floor ? UP : DOWN));

        wait(door_state === OPEN);

        assert(door_state === OPEN);
        assert(current_floor === floor);
    end
    endtask

    initial begin
        rst_n = 0;
        @(posedge clk);
        rst_n = 1;

        @(negedge clk);

        select_floor(7);
        select_floor(4);
        select_floor(5);
        select_floor(0);
        select_floor(7);
        select_floor(0);

        @(posedge clk);
        @(posedge clk);

        $display("tb_hax_elevator: PASSED");
        $stop;
    end
endmodule : tb_hax_elevator