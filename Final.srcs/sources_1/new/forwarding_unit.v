`timescale 1ns / 1ps
(* dont_touch = "true" *)
module forwarding_unit (
    input  wire [4:0]  ex_mem_rd, mem_wb_rd,
    input  wire [4:0]  id_ex_rs1, id_ex_rs2,
    input  wire        ex_mem_reg_write, mem_wb_reg_write,
    output reg  [1:0]  forward_a, forward_b
);
    always @(*) begin
        if (ex_mem_reg_write && (ex_mem_rd != 5'b0) && (ex_mem_rd == id_ex_rs1))
            forward_a = 2'b10;
        else if (mem_wb_reg_write && (mem_wb_rd != 5'b0) && (mem_wb_rd == id_ex_rs1))
            forward_a = 2'b01;
        else forward_a = 2'b00;

        if (ex_mem_reg_write && (ex_mem_rd != 5'b0) && (ex_mem_rd == id_ex_rs2))
            forward_b = 2'b10;
        else if (mem_wb_reg_write && (mem_wb_rd != 5'b0) && (mem_wb_rd == id_ex_rs2))
            forward_b = 2'b01;
        else forward_b = 2'b00;
    end
endmodule