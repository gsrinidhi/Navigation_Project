module sun(
    pclk,
    psels,
    penables,
    pwrites,
    paddrs,
    pwdatas,
    prdatas,
    preadys,
    reset
);

input pclk;
input psels;
input penables;
input pwrites;
input reset;
input [31:0] paddrs;
input [31:0] pwdatas;
output [31:0] prdatas;
output preadys;
reg pready_temp;
reg [7:0] control;
reg [7:0] status;
reg [7:0] threshold;
reg [15:0] xmax;
reg [15:0] ymax;
reg [15:0] xcount;
reg [15:0] ycount;
reg [7:0] state;
reg [31:0] op_temp;
reg flag;

reg[31:0] sum_accum;
reg[31:0] I_Data;
reg[31:0] I_Data_temp;
always @(posedge reset) begin
    state <= 8'h01;
    control <= 8'h00;
    pready_temp <= 1'b0;
    flag = 1'b0;
end

always @(posedge pclk) begin
    if(psels == 1'b1) begin
        if(penables == 1'b1) begin
            if(state == 8'h02) begin
                if(paddrs[7:0] == 8'h00) begin
                    control <= pwdatas[7:0];
                    state <= 8'h00;
                end
                else if(paddrs[7:0] == 8'h01) begin
                    threshold <= pwdatas[7:0];
                    state <= 8'h61;
                end
                else if(paddrs[7:0] == 8'h02) begin
                    xmax <= pwdatas[7:0];
                    state <= 8'h61;
                end
                else if(paddrs[7:0] == 8'h03) begin
                    ymax <= pwdatas[7:0];
                    state <= 8'h61;
                end
                else if(paddrs[7:0] == 8'h04) begin
                    I_Data_temp <= pwdatas[7:0];
                    state <= 8'h04;
                end 
                else begin
                    state <= 8'h01;
                end
            end
            else if(state == 8'h03) begin
                if(paddrs[7:0] == 8'h05) begin
                    op_temp[7:0] <= status;
                end
                else if(paddrs[7:0] == 8'h06) begin
                    op_temp <= sum_accum;
                end
                else if(paddrs[7:0] == 8'h07) begin
                    op_temp[7:0] <= threshold;
                end
                state <= 8'h01;
            end
        end
        else begin
            if(state == 8'h02)
                state <= 8'h01;
            else if(state == 8'h03)
                state <= 8'h01;
        end
        if(state == 8'h01) begin 
            if(psels == 1'b1) begin
                if(pwrites == 1'b1) begin
                    state <= 8'h02;
                end
                else begin
                    state <= 8'h03;
                end
            end
        end
    end
        if(state == 8'h61) begin
            pready_temp <= 1'b1;
            state <= 8'h62;
        end
        else if(state == 8'h62) begin
            pready_temp <= 1'b0;
            state <= 8'h01;
        end
        // else if(state == 8'h01) begin 
        //     if(psels == 1'b1) begin
        //         if(pwrites == 1'b1) begin
        //             state <= 8'h02;
        //         end
        //         else begin
        //             state <= 8'h03;
        //         end
        //     end
        // end
        else if(state == 8'h00) begin
            if(control == 8'h01) begin
                sum_accum <= 32'h00000000;
                xcount <= 16'h0000;
                ycount <= 16'h0000;
                status <= 8'h01;
                state <= 8'h61;
            end
        end
        else if(state == 8'h04) begin
            I_Data <= (I_Data_temp > threshold) ? I_Data_temp: 8'h00;
            state <= 8'h05;
        end
        else if(state == 8'h05) begin
            sum_accum <= sum_accum + I_Data;
            state <= 8'h06;
        end
        else if(state == 8'h06) begin
            xcount <= xcount + 16'h0001;
            state <= 8'h07;
        end
        else if(state == 8'h07) begin
            if(xcount == xmax) begin
                status <= 8'h03;
            end
            else begin
                status <= 8'h02;
            end
            state <= 8'h61;
        end
    
end

// always @(posedge penables) begin
//     if(psels == 1'b1) begin
//         if(state == 8'h02) begin
//             if(paddrs == 32'h00000000) begin
//                 control <= pwdatas[7:0];
//                 state <= 8'h00;
//             end
//             else if(paddrs == 32'h00000001) begin
//                 threshold <= pwdatas[7:0];
//                 state <= 8'h61;
//             end
//             else if(paddrs == 32'h00000002) begin
//                 xmax <= pwdatas[7:0];
//                 state <= 8'h61;
//             end
//             else if(paddrs == 32'h00000003) begin
//                 ymax <= pwdatas[7:0];
//                 state <= 8'h61;
//             end
//             else if(paddrs == 32'h00000004) begin
//                 I_Data_temp <= pwdatas[7:0];
//                 state <= 8'h04;
//             end
            
//         end
//         else if(state == 8'h03) begin
//             if(paddrs == 32'h00000005) begin
//                 op_temp[7:0] <= status;
//             end
//             else if(paddrs == 32'h00000006) begin
//                 op_temp <= sum_accum;
//             end
//             state <= 8'h01;
//         end
//     end
// end

assign prdatas = op_temp;
assign preadys = pready_temp;

endmodule