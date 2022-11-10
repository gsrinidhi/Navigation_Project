`timescale 1ns/1ns
`include "thresholding.v"

module thresholding_tb;

reg [7:0] in;
reg mode,clk;
wire [7:0] out;

always #5 clk = ~clk;

thresholding thresh(clk,mode,in,out);

initial begin
    $dumpfile("thresholding.vcd");
    $dumpvars(0,thresholding_tb);
    clk = 1'b0;
    in = 8'h0F;
    mode = 1'b1;
    #20;

    in = 8'h08;
    mode = 1'b0;
    #20;

    in = 8'h25;
    #20;
    
    in = 8'h05;
    #20;

    in = 8'h50;
    #20;

    in = 8'h88;
    #20;

    $display("Thresholding tb done");
    $finish;
end
endmodule