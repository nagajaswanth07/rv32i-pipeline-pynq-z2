`timescale 1ns / 1ps
module tb_rv32i;
    reg        clk, rst;
    reg  [1:0] sw;
    wire [3:0] led;

    rv32i_pipeline DUT (
        .clk(clk), .rst(rst),
        .sw(sw), .led(led)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("rv32i.vcd");
        $dumpvars(0, tb_rv32i);
        rst = 1; sw = 2'b00;
        #50; rst = 0;
        #50000;
        sw = 2'b00; #200;
        $display("SW=00 led=%b x3=%0d (sum,   expect 8)", led, DUT.RF.regs[3]);
        sw = 2'b01; #200;
        $display("SW=01 led=%b x4=%0d (diff,  expect 2)", led, DUT.RF.regs[4]);
        sw = 2'b10; #200;
        $display("SW=10 led=%b x5=%0d (and,   expect 1)", led, DUT.RF.regs[5]);
        sw = 2'b11; #200;
        $display("SW=11 led=%b x6=%0d (or,    expect 7)", led, DUT.RF.regs[6]);
        $display("x7=%0d (xor=6) x8=%0d (sll=10)", DUT.RF.regs[7], DUT.RF.regs[8]);
        $finish;
    end
endmodule