`timescale 1ns / 1ps
(* dont_touch = "true" *)
module control_unit (
    input  wire [6:0] opcode, funct7,
    input  wire [2:0] funct3,
    output reg  [3:0] alu_op,
    output reg        alu_src, mem_read, mem_write,
                      reg_write, mem_to_reg
);
    always @(*) begin
        alu_op    = 4'b0; alu_src   = 1'b0;
        mem_read  = 1'b0; mem_write = 1'b0;
        reg_write = 1'b0; mem_to_reg= 1'b0;
        case (opcode)
            7'b0110011: begin
                reg_write = 1'b1;
                case ({funct7[5], funct3})
                    4'b0000: alu_op = 4'd0;
                    4'b1000: alu_op = 4'd1;
                    4'b0111: alu_op = 4'd2;
                    4'b0110: alu_op = 4'd3;
                    4'b0100: alu_op = 4'd4;
                    4'b0001: alu_op = 4'd5;
                    4'b0101: alu_op = 4'd6;
                    4'b1101: alu_op = 4'd7;
                    4'b0010: alu_op = 4'd8;
                    4'b0011: alu_op = 4'd9;
                    default: alu_op = 4'd0;
                endcase
            end
            7'b0010011: begin
                alu_src = 1'b1; reg_write = 1'b1;
                case (funct3)
                    3'b000: alu_op = 4'd0;
                    3'b111: alu_op = 4'd2;
                    3'b110: alu_op = 4'd3;
                    3'b100: alu_op = 4'd4;
                    3'b001: alu_op = 4'd5;
                    3'b101: alu_op = funct7[5] ? 4'd7 : 4'd6;
                    3'b010: alu_op = 4'd8;
                    3'b011: alu_op = 4'd9;
                    default: alu_op = 4'd0;
                endcase
            end
            7'b0000011: begin
                alu_src=1'b1; mem_read=1'b1;
                reg_write=1'b1; mem_to_reg=1'b1; alu_op=4'd0;
            end
            7'b0100011: begin
                alu_src=1'b1; mem_write=1'b1; alu_op=4'd0;
            end
            7'b0110111: begin
                alu_src=1'b1; reg_write=1'b1; alu_op=4'd10;
            end
            7'b0010111: begin
                alu_src=1'b1; reg_write=1'b1; alu_op=4'd0;
            end
            default: begin
                alu_op=4'd0; alu_src=1'b0;
                mem_read=1'b0; mem_write=1'b0;
                reg_write=1'b0; mem_to_reg=1'b0;
            end
        endcase
    end
endmodule