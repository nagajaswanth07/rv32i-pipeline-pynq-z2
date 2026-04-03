`timescale 1ns / 1ps
(* dont_touch = "true" *)
module data_mem (
    input  wire        clk, mem_read, mem_write,
    input  wire [31:0] addr, wd,
    input  wire [2:0]  funct3,
    output reg  [31:0] rd
);
    (* ram_style = "block" *)
    reg [31:0] mem [0:255];

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 32'b0;
    end

    always @(posedge clk) begin
        if (mem_write) begin
            case (funct3)
                3'b000: mem[addr[9:2]] <= {mem[addr[9:2]][31:8],  wd[7:0]};
                3'b001: mem[addr[9:2]] <= {mem[addr[9:2]][31:16], wd[15:0]};
                3'b010: mem[addr[9:2]] <= wd;
                default: ;
            endcase
        end
    end

    always @(*) begin
        if (mem_read) begin
            case (funct3)
                3'b000: rd = {{24{mem[addr[9:2]][7]}},  mem[addr[9:2]][7:0]};
                3'b001: rd = {{16{mem[addr[9:2]][15]}}, mem[addr[9:2]][15:0]};
                3'b010: rd = mem[addr[9:2]];
                3'b100: rd = {24'b0, mem[addr[9:2]][7:0]};
                3'b101: rd = {16'b0, mem[addr[9:2]][15:0]};
                default: rd = 32'b0;
            endcase
        end else rd = 32'b0;
    end
endmodule