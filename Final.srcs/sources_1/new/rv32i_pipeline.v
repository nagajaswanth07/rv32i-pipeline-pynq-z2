`timescale 1ns / 1ps
(* dont_touch = "true" *)
module rv32i_pipeline (
    input  wire        clk,
    input  wire        rst,
    input  wire [1:0]  sw,
    output wire [3:0]  led
);

(* dont_touch = "true" *) reg [31:0] IF_ID_PC, IF_ID_IR;
(* dont_touch = "true" *) reg [31:0] ID_EX_PC, ID_EX_RS1, ID_EX_RS2, ID_EX_IMM;
(* dont_touch = "true" *) reg [4:0]  ID_EX_RD, ID_EX_RS1_ADDR, ID_EX_RS2_ADDR;
(* dont_touch = "true" *) reg [3:0]  ID_EX_ALU_OP;
(* dont_touch = "true" *) reg        ID_EX_ALU_SRC, ID_EX_MEM_READ, ID_EX_MEM_WRITE;
(* dont_touch = "true" *) reg        ID_EX_REG_WRITE, ID_EX_MEM_TO_REG;
(* dont_touch = "true" *) reg [2:0]  ID_EX_FUNCT3;
(* dont_touch = "true" *) reg [31:0] EX_MEM_ALU_RES, EX_MEM_RS2;
(* dont_touch = "true" *) reg [4:0]  EX_MEM_RD;
(* dont_touch = "true" *) reg        EX_MEM_MEM_READ, EX_MEM_MEM_WRITE;
(* dont_touch = "true" *) reg        EX_MEM_REG_WRITE, EX_MEM_MEM_TO_REG;
(* dont_touch = "true" *) reg [2:0]  EX_MEM_FUNCT3;
(* dont_touch = "true" *) reg        EX_MEM_ZERO;
(* dont_touch = "true" *) reg [31:0] MEM_WB_MEM_DATA, MEM_WB_ALU_RES;
(* dont_touch = "true" *) reg [4:0]  MEM_WB_RD;
(* dont_touch = "true" *) reg        MEM_WB_REG_WRITE, MEM_WB_MEM_TO_REG;

wire [31:0] pc_out, pc_next, pc_plus4;
wire [31:0] instr;
wire [31:0] rs1_data, rs2_data, imm_ext;
wire [31:0] alu_in_b, alu_result;
wire [31:0] mem_read_data;
wire [31:0] wb_data;
wire [31:0] reg3_out, reg4_out, reg5_out, reg6_out, reg7_out, reg8_out;
wire        alu_zero;
wire [3:0]  alu_ctrl;
wire        alu_src_ctrl, mem_read_ctrl, mem_write_ctrl;
wire        reg_write_ctrl, mem_to_reg_ctrl;
wire [1:0]  forward_a, forward_b;
wire        stall;
wire [4:0]  rd_id, rs1_id, rs2_id;
wire [2:0]  funct3;
wire [6:0]  opcode, funct7;

assign opcode = IF_ID_IR[6:0];
assign rd_id  = IF_ID_IR[11:7];
assign funct3 = IF_ID_IR[14:12];
assign rs1_id = IF_ID_IR[19:15];
assign rs2_id = IF_ID_IR[24:20];
assign funct7 = IF_ID_IR[31:25];

// ============================================================
// IF Stage
// ============================================================
pc_reg PC (
    .clk(clk), .rst(rst), .stall(stall),
    .pc_next(pc_next), .pc_out(pc_out)
);
assign pc_plus4 = pc_out + 32'd4;
assign pc_next  = pc_plus4;

instr_mem IMEM (
    .clk(clk), .addr(pc_out), .instr(instr)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        IF_ID_PC <= 32'b0;
        IF_ID_IR <= 32'h00000013;
    end else if (!stall) begin
        IF_ID_PC <= pc_out;
        IF_ID_IR <= instr;
    end
end

// ============================================================
// ID Stage
// ============================================================
reg_file RF (
    .clk(clk),
    .rs1(rs1_id), .rs2(rs2_id),
    .rd(MEM_WB_RD), .wd(wb_data), .we(MEM_WB_REG_WRITE),
    .rs1_data(rs1_data), .rs2_data(rs2_data),
    .reg3_out(reg3_out), .reg4_out(reg4_out),
    .reg5_out(reg5_out), .reg6_out(reg6_out),
    .reg7_out(reg7_out), .reg8_out(reg8_out)
);

imm_gen IMMGEN (
    .instr(IF_ID_IR), .imm(imm_ext)
);

control_unit CU (
    .opcode(opcode), .funct3(funct3), .funct7(funct7),
    .alu_op(alu_ctrl), .alu_src(alu_src_ctrl),
    .mem_read(mem_read_ctrl), .mem_write(mem_write_ctrl),
    .reg_write(reg_write_ctrl), .mem_to_reg(mem_to_reg_ctrl)
);

hazard_unit HU (
    .id_ex_mem_read(ID_EX_MEM_READ),
    .id_ex_rd(ID_EX_RD),
    .if_id_rs1(rs1_id), .if_id_rs2(rs2_id),
    .stall(stall)
);

always @(posedge clk or posedge rst) begin
    if (rst || stall) begin
        ID_EX_RS1       <= 32'b0;
        ID_EX_RS2       <= 32'b0;
        ID_EX_IMM       <= 32'b0;
        ID_EX_RD        <= 5'b0;
        ID_EX_RS1_ADDR  <= 5'b0;
        ID_EX_RS2_ADDR  <= 5'b0;
        ID_EX_ALU_OP    <= 4'b0;
        ID_EX_ALU_SRC   <= 1'b0;
        ID_EX_MEM_READ  <= 1'b0;
        ID_EX_MEM_WRITE <= 1'b0;
        ID_EX_REG_WRITE <= 1'b0;
        ID_EX_MEM_TO_REG<= 1'b0;
        ID_EX_FUNCT3    <= 3'b0;
        ID_EX_PC        <= 32'b0;
    end else begin
        ID_EX_PC        <= IF_ID_PC;
        ID_EX_RS1       <= rs1_data;
        ID_EX_RS2       <= rs2_data;
        ID_EX_IMM       <= imm_ext;
        ID_EX_RD        <= rd_id;
        ID_EX_RS1_ADDR  <= rs1_id;
        ID_EX_RS2_ADDR  <= rs2_id;
        ID_EX_ALU_OP    <= alu_ctrl;
        ID_EX_ALU_SRC   <= alu_src_ctrl;
        ID_EX_MEM_READ  <= mem_read_ctrl;
        ID_EX_MEM_WRITE <= mem_write_ctrl;
        ID_EX_REG_WRITE <= reg_write_ctrl;
        ID_EX_MEM_TO_REG<= mem_to_reg_ctrl;
        ID_EX_FUNCT3    <= funct3;
    end
end

// ============================================================
// EX Stage
// ============================================================
forwarding_unit FU (
    .ex_mem_rd(EX_MEM_RD), .mem_wb_rd(MEM_WB_RD),
    .id_ex_rs1(ID_EX_RS1_ADDR), .id_ex_rs2(ID_EX_RS2_ADDR),
    .ex_mem_reg_write(EX_MEM_REG_WRITE),
    .mem_wb_reg_write(MEM_WB_REG_WRITE),
    .forward_a(forward_a), .forward_b(forward_b)
);

wire [31:0] fwd_rs1 = (forward_a == 2'b10) ? EX_MEM_ALU_RES :
                      (forward_a == 2'b01) ? wb_data : ID_EX_RS1;
wire [31:0] fwd_rs2 = (forward_b == 2'b10) ? EX_MEM_ALU_RES :
                      (forward_b == 2'b01) ? wb_data : ID_EX_RS2;

assign alu_in_b = ID_EX_ALU_SRC ? ID_EX_IMM : fwd_rs2;

alu ALU (
    .a(fwd_rs1), .b(alu_in_b),
    .alu_ctrl(ID_EX_ALU_OP),
    .result(alu_result), .zero(alu_zero)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        EX_MEM_ALU_RES   <= 32'b0;
        EX_MEM_RS2       <= 32'b0;
        EX_MEM_RD        <= 5'b0;
        EX_MEM_ZERO      <= 1'b0;
        EX_MEM_MEM_READ  <= 1'b0;
        EX_MEM_MEM_WRITE <= 1'b0;
        EX_MEM_REG_WRITE <= 1'b0;
        EX_MEM_MEM_TO_REG<= 1'b0;
        EX_MEM_FUNCT3    <= 3'b0;
    end else begin
        EX_MEM_ALU_RES   <= alu_result;
        EX_MEM_RS2       <= fwd_rs2;
        EX_MEM_RD        <= ID_EX_RD;
        EX_MEM_MEM_READ  <= ID_EX_MEM_READ;
        EX_MEM_MEM_WRITE <= ID_EX_MEM_WRITE;
        EX_MEM_REG_WRITE <= ID_EX_REG_WRITE;
        EX_MEM_MEM_TO_REG<= ID_EX_MEM_TO_REG;
        EX_MEM_FUNCT3    <= ID_EX_FUNCT3;
        EX_MEM_ZERO      <= alu_zero;
    end
end

// ============================================================
// MEM Stage
// ============================================================
data_mem DMEM (
    .clk(clk),
    .addr(EX_MEM_ALU_RES), .wd(EX_MEM_RS2),
    .mem_read(EX_MEM_MEM_READ), .mem_write(EX_MEM_MEM_WRITE),
    .funct3(EX_MEM_FUNCT3), .rd(mem_read_data)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        MEM_WB_MEM_DATA   <= 32'b0;
        MEM_WB_ALU_RES    <= 32'b0;
        MEM_WB_RD         <= 5'b0;
        MEM_WB_REG_WRITE  <= 1'b0;
        MEM_WB_MEM_TO_REG <= 1'b0;
    end else begin
        MEM_WB_MEM_DATA   <= mem_read_data;
        MEM_WB_ALU_RES    <= EX_MEM_ALU_RES;
        MEM_WB_RD         <= EX_MEM_RD;
        MEM_WB_REG_WRITE  <= EX_MEM_REG_WRITE;
        MEM_WB_MEM_TO_REG <= EX_MEM_MEM_TO_REG;
    end
end

// ============================================================
// WB Stage
// ============================================================
assign wb_data = MEM_WB_MEM_TO_REG ? MEM_WB_MEM_DATA : MEM_WB_ALU_RES;

// ============================================================
// LED Display with Switch Selection
// SW1 SW0 | Register | Value | LED
//  0   0  | x3 sum   |  8    | 1000
//  0   1  | x4 diff  |  2    | 0010
//  1   0  | x5 and   |  1    | 0001
//  1   1  | x6 or    |  7    | 0111
// ============================================================
reg [31:0] selected_reg;
always @(*) begin
    case (sw)
        2'b00: selected_reg = reg3_out;
        2'b01: selected_reg = reg4_out;
        2'b10: selected_reg = reg5_out;
        2'b11: selected_reg = reg6_out;
        default: selected_reg = reg3_out;
    endcase
end

assign led = selected_reg[3:0];

endmodule