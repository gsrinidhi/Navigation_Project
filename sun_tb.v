`timescale 1ns/1ns

`include "sun.v"


module sun_tb();

reg pclk;
reg psels;
reg penables;
reg pwrites;
reg reset;
reg [31:0] paddrs;
reg [31:0] pwdatas;
wire [31:0] prdatas;
wire preadys;
reg state;

always #10 pclk = ~pclk;

always @(posedge preadys) begin
    state <= 1;
end

sun test(pclk,psels,penables,pwrites,paddrs,pwdatas,prdatas,preadys,reset);

initial begin

    $dumpfile("Sun_Sensor.vcd");
    $dumpvars(0,sun_tb);

    pclk = 1'b0;
    psels = 1'b0;
    penables = 1'b0;
    pwrites = 1'b0;
    reset = 1'b0;
    paddrs = 32'h00000000;
    pwdatas = 32'h00000000;
    state = 1'b0;
    
    #5;

    reset = 1'b1;

    #10;

    pwdatas = 32'h00000001;

    #15;
    psels = 1'b1;
    pwrites = 1'b1;

    #20;
    penables = 1'b1;

    #20;
    penables = 1'b0;
    psels = 1'b0;

    // while(preadys == 1'b0) begin
    //     pwdatas = 1'b0;
    // end
    #100;
    psels = 1'b1;
    paddrs = 32'h00000005;
    pwrites = 1'b0;

    #20;

    penables = 1'b1;

    #20;
    penables = 1'b0;
    psels = 1'b0;
    #40
    paddrs = 32'h00000001;
    pwdatas = 8'h0F;
    pwrites = 1'b1;
    psels = 1'b1;
    #20;
    penables = 1'b1;
    #20;
    penables = 1'b0;
    psels = 1'b0;
    #40;
    pwrites = 1'b0;
    psels = 1'b1;
    #20;
    penables = 1'b1;
    #20;
    penables = 1'b0;
    psels = 1'b0;
    #40;
    paddrs = 32'h00000002;
    pwdatas = 8'hFF;
    pwrites = 1'b1;
    psels = 1'b1;
    #20;
    penables = 1'b1;
    #20;
    penables = 1'b0;
    psels = 1'b0;
    #40;
    paddrs = 32'h00000003;
    pwdatas = 8'hFF;
    pwrites = 1'b1;
    psels = 1'b1;
    #20;
    penables = 1'b1;
    #20;
    penables = 1'b0;
    psels = 1'b0;
    #40;
    //state = 1'b0;
    paddrs = 32'h00000004;
    pwdatas = 8'h0A;
    pwrites = 1'b1;
    psels = 1'b1;
    #20;
    penables = 1'b1;
    #20;
    penables = 1'b0;
    psels = 1'b0;
    // while(state == 1'b0) begin
    //     psels = 0;
    // end
    state = 1'b0;
    pwdatas = 8'h88;
    #200;

    #10;
    #100;

    $display("Sun sensor tested");
    $finish;



end




endmodule