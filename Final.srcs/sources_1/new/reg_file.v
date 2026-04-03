`timescale 1ns / 1ps
(* dont_touch = "true" *)
module reg_file (
    input  wire        clk,
    input  wire        we,
    input  wire [4:0]  rs1, rs2, rd,
    input  wire [31:0] wd,
    output wire [31:0] rs1_data, rs2_data,
    output wire [31:0] reg3_out,
    output wire [31:0] reg4_out,
    output wire [31:0] reg5_out,
    output wire [31:0] reg6_out,
    output wire [31:0] reg7_out,
    output wire [31:0] reg8_out
);
    (* dont_touch = "true" *)
    reg [31:0] regs [0:31];

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'b0;
    end

    always @(posedge clk) begin
        if (we && rd != 5'b0)
            regs[rd] <= wd;
    end

    assign rs1_data = (rs1 == 5'b0) ? 32'b0 : regs[rs1];
    assign rs2_data = (rs2 == 5'b0) ? 32'b0 : regs[rs2];
    assign reg3_out = regs[3];
    assign reg4_out = regs[4];
    assign reg5_out = regs[5];
    assign reg6_out = regs[6];
    assign reg7_out = regs[7];
    assign reg8_out = regs[8];
endmodule