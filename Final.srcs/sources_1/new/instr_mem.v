`timescale 1ns / 1ps
(* dont_touch = "true" *)
module instr_mem (
    input  wire        clk,
    input  wire [31:0] addr,
    output wire [31:0] instr
);
    (* rom_style = "block" *)
    reg [31:0] mem [0:255];

    integer k;
    initial begin
        for (k = 0; k < 256; k = k + 1)
            mem[k] = 32'h00000013;
        $readmemh("D:/Xilink/SoC/GEMINI/project_1/project_1.sim/sim_1/behav/xsim/program.hex", mem);
    end

    assign instr = mem[addr[9:2]];
endmodule