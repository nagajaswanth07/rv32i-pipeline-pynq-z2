`timescale 1ns / 1ps
(* dont_touch = "true" *)
module alu (
    input  wire [31:0] a, b,
    input  wire [3:0]  alu_ctrl,
    output reg  [31:0] result,
    output wire        zero
);
    always @(*) begin
        case (alu_ctrl)
            4'd0:  result = a + b;
            4'd1:  result = a - b;
            4'd2:  result = a & b;
            4'd3:  result = a | b;
            4'd4:  result = a ^ b;
            4'd5:  result = a << b[4:0];
            4'd6:  result = a >> b[4:0];
            4'd7:  result = $signed(a) >>> b[4:0];
            4'd8:  result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            4'd9:  result = (a < b) ? 32'd1 : 32'd0;
            4'd10: result = b;
            default: result = 32'b0;
        endcase
    end
    assign zero = (result == 32'b0);
endmodule