`timescale 1ns/1ns

`include "sun.v"


module sun_tb();

reg pclk;
reg psels;
reg penables;
reg pwrites;
reg [31:0] paddrs;
reg [31:0] pwdatas;
wire [31:0] prdatas;
wire preadys;
reg state;

always #10 pclk = ~pclk;

always @(posedge preadys) begin
    state <= 1;
end

sun test(pclk,psels,penables,pwrites,paddrs,pwdatas,prdatas,preadys);

initial begin

    $dumpfile("Sun_Sensor.vcd");
    $dumpvars(0,sun_tb);

    pclk = 1'b0;
    psels = 1'b0;
    penables = 1'b0;
    pwrites = 1'b0;
    paddrs = 32'h00000000;
    pwdatas = 32'h00000000;
    state = 1'b0;
    
    #5;

    #10;
    //Setting control register
    pwdatas = 32'h00000001;

    #15;
    psels = 1'b1;
    pwrites = 1'b1;

    #20;
    penables = 1'b1;

    #20;
    penables = 1'b0;
    psels = 1'b0;
    #100;
    //Reading status register
    psels = 1'b1;
    paddrs = 32'h00000005;
    pwrites = 1'b0;

    #20;

    penables = 1'b1;

    #20;
    penables = 1'b0;
    psels = 1'b0;
    #40
    //Setting threshold as 0x0f
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
    //Reading threshold register
    pwrites = 1'b0;
    psels = 1'b1;
    #20;
    penables = 1'b1;
    #20;
    penables = 1'b0;
    psels = 1'b0;
    #40;
    //Setting xmax
    paddrs = 32'h00000002;
    pwdatas = 8'h02;
    pwrites = 1'b1;
    psels = 1'b1;
    #20;
    penables = 1'b1;
    #20;
    penables = 1'b0;
    psels = 1'b0;
    #40;
    //Setting ymax
    paddrs = 32'h00000003;
    pwdatas = 8'h02;
    pwrites = 1'b1;
    psels = 1'b1;
    #20;
    penables = 1'b1;
    #20;
    penables = 1'b0;
    psels = 1'b0;
    #40;
    //state = 1'b0;
    //Sending first data
    paddrs = 32'h00000004;
    pwdatas = 8'h10;
    pwrites = 1'b1;
    psels = 1'b1;
    #20;
    penables = 1'b1;
    #20;
    penables = 1'b0;
    psels = 1'b0;
    #200
    //Sending second data
    paddrs = 32'h00000004;
    pwdatas = 8'h10;
    pwrites = 1'b1;
    psels = 1'b1;
    #20;
    penables = 1'b1;
    #20;
    penables = 1'b0;
    psels = 1'b0;
    #200
    //Sending third data
    paddrs = 32'h00000004;
    pwdatas = 8'h10;
    pwrites = 1'b1;
    psels = 1'b1;
    #20;
    penables = 1'b1;
    #20;
    penables = 1'b0;
    psels = 1'b0;
    #200
    //Sending fourth data
    paddrs = 32'h00000004;
    pwdatas = 8'h10;
    pwrites = 1'b1;
    psels = 1'b1;
    #20;
    penables = 1'b1;
    #20;
    penables = 1'b0;
    psels = 1'b0;
    #200;
    //Reading status register
    paddrs = 32'h00000005;
    pwrites = 1'b0;
    psels = 1'b1;
    #20;
    penables = 1'b1;
    #20;
    penables = 1'b0;
    psels = 1'b0;
    #40;
    //Reading h register
    paddrs = 32'h00000008;
    pwrites = 1'b0;
    psels = 1'b1;
    #20;
    penables = 1'b1;
    #20;
    penables = 1'b0;
    psels = 1'b0;
    #40;
    //Reading k register
    paddrs = 32'h00000009;
    pwrites = 1'b0;
    psels = 1'b1;
    #20;
    penables = 1'b1;
    #20;
    penables = 1'b0;
    psels = 1'b0;
    #40;
    #200;

    #10;
    #100;

    $display("Sun sensor tested");
    $finish;



end




endmodule