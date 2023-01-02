`include "types.sv"

module hex_display(input floor_t value, output logic [6:0] hex);
    always_comb begin
        case (value)
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
endmodule : hex_display