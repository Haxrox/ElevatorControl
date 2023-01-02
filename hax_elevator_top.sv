`include "types.sv"

module hax_elevator_top (
    input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
    output logic [9:0] LEDR,
    output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2, 
    output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5
);

    parameter DELAY_THRESHOLD = 26'd50000000;

    direction_t direction, elevator_direction;
    door_t door_state;
    floor_t current_floor, destination, target;
    logic pressed;

    hax_elevator #(.DELAY_THRESHOLD(DELAY_THRESHOLD)) elevator(
        .clk(CLOCK_50), .rst_n(KEY[0]), .*
    );

    hex_display target_display(
        .value(target), .hex(HEX0)
    );

    hex_display current_display(
        .value(current_floor), .hex(HEX1)
    );

    hex_display destination_display(
        .value(destination), .hex(HEX2)
    );

    assign LEDR[0] = door_state === CLOSE;
    assign LEDR[1] = elevator_direction === UP;
    assign LEDR[2] = elevator_direction === DOWN;

    assign LEDR[9:3] = 7'd0;
    assign HEX3 = 7'b1111111;
    assign HEX4 = 7'b1111111;
    assign HEX5 = 7'b1111111;

    assign target = SW[floor_width-1: 0];

    always_ff @(posedge CLOCK_50) begin
        if (door_state === OPEN) begin
            if (~KEY[3]) begin
                pressed <= 1;
            end
        end else begin
            pressed <= 0;
        end
    end
endmodule : hax_elevator_top