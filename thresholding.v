module thresholding(
    clk,
    mode,
    input_byte,
    result
);
input clk;
input mode;
input [7:0]input_byte;
output [7:0]result;
reg [7:0]threshold;
reg [7:0] op;
always @( posedge clk) begin
    if(mode) begin
        threshold <= input_byte;
    end
    else begin
        if(input_byte > threshold) begin
            op <= input_byte;
        end
        else begin
            op <= 8'h00;
        end
    end
end

assign result = op;
endmodule