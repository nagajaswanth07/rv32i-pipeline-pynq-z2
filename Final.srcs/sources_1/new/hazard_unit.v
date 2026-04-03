`timescale 1ns / 1ps
(* dont_touch = "true" *)
module hazard_unit (
    input  wire        id_ex_mem_read,
    input  wire [4:0]  id_ex_rd, if_id_rs1, if_id_rs2,
    output wire        stall
);
    assign stall = id_ex_mem_read &&
                   ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2));
endmodule