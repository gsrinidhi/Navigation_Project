`include "thresholding.v"

module x_accum (
    clk,
    input_data,
    output_data
);

input clk;
input [7:0] input_data;
output [15:0] output_data;
reg [15:0] op;
reg [15:0] x;
wire [7:0] t_op;
reg [7:0] ip_byte;
reg mode;
thresholding tp(clk,mode,ip_byte,t_op);
initial begin
    x = 16'h0000;
    ip_byte = 8'h0F;
    op = 18'h0000;
    mode = 1'b1;
    #10;
    mode = 1'b0;
end
always @(posedge clk) begin
    ip_byte <= input_data;
    if(t_op) begin
        op <= op + x;
    end
    x <= x + 1;
end
assign output_data = op;
endmodule