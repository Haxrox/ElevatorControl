`include "types.sv"

module hax_elevator(
    input logic clk, input logic rst_n, 
    input direction_t direction, input floor_t target, input logic pressed,
    output floor_t current_floor, output floor_t destination, 
    output door_t door_state, output direction_t elevator_direction);

    parameter DELAY_THRESHOLD = 26'd50000000;
    state_t state;
    logic [25:0] delay;

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            current_floor <= 0;
            door_state <= OPEN;
            delay <= 0;
            state <= IDLE_S;
        end else begin
            case (state)
                IDLE_S: begin
                    door_state <= OPEN;
                    elevator_direction <= IDLE;
                    if (pressed) begin
                        if (target > current_floor) begin
                            elevator_direction <= UP;
                            state <= UP_S;
                        end else if (target < current_floor) begin
                            elevator_direction <= DOWN;
                            state <= DOWN_S;
                        end
                        delay <= 0;
                        door_state <= CLOSE;
                        destination <= target;
                    end
                end
                UP_S: begin
                    if (current_floor === target) begin
                        door_state <= OPEN;
                        state <= IDLE_S;
                    end else if (delay > DELAY_THRESHOLD) begin
                        current_floor <= current_floor + 1;
                        delay <= 0;
                    end else begin
                        delay <= delay + 1;
                    end
                end
                DOWN_S: begin
                    if (current_floor === target) begin
                        door_state <= OPEN;
                        state <= IDLE_S;
                    end else if (delay > DELAY_THRESHOLD) begin
                        current_floor <= current_floor - 1;
                        delay <= 0;
                    end else begin
                        delay <= delay + 1;
                    end
                end
            endcase
        end      
    end

endmodule : hax_elevator