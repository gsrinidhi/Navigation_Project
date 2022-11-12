module sun(
    pclk,
    psels,
    penables,
    pwrites,
    paddrs,
    pwdatas,
    prdatas,
    preadys
);

input pclk;
input psels;
input penables;
input pwrites;
input [31:0] paddrs;
input [31:0] pwdatas;
output [31:0] prdatas;
output preadys;
reg pready_temp = 1'b0;
reg [7:0] control = 8'h00;
reg [7:0] status;
reg [7:0] threshold;
reg [15:0] xmax;
reg [15:0] ymax;
reg [15:0] xcount;
reg [15:0] ycount;
reg [7:0] access_state = 8'h01;
reg [7:0] calc_state = 8'h00;
reg [31:0] op_temp;

reg[31:0] sum_accum;
reg[31:0] I_Data;
reg[31:0] I_Data_temp;

always @(posedge pclk) begin
    if(psels == 1'b1) begin
        if(penables == 1'b1) begin
            if(access_state == 8'h02) begin
                if(paddrs[7:0] == 8'h00) begin
                    control <= pwdatas[7:0];
                    access_state <= 8'h61;
                    calc_state <= 8'h01;
                end
                else if(paddrs[7:0] == 8'h01) begin
                    threshold <= pwdatas[7:0];
                    access_state <= 8'h61;
                end
                else if(paddrs[7:0] == 8'h02) begin
                    xmax <= pwdatas[7:0];
                    access_state <= 8'h61;
                end
                else if(paddrs[7:0] == 8'h03) begin
                    ymax <= pwdatas[7:0];
                    access_state <= 8'h61;
                end
                else if(paddrs[7:0] == 8'h04) begin
                    I_Data_temp <= pwdatas[7:0];
                    access_state <= 8'h61;
                    calc_state <= 8'h04;
                end 
                else begin
                    access_state <= 8'h01;
                end
            end
            else if(access_state == 8'h03) begin
                if(paddrs[7:0] == 8'h05) begin
                    op_temp[7:0] <= status;
                end
                else if(paddrs[7:0] == 8'h06) begin
                    op_temp <= sum_accum;
                end
                else if(paddrs[7:0] == 8'h01) begin
                    op_temp[7:0] <= threshold;
                end
                access_state <= 8'h01;
            end
        end
        else begin
            if(access_state == 8'h02)
                access_state <= 8'h01;
            else if(access_state == 8'h03)
                access_state <= 8'h01;
        end
        if(access_state == 8'h01) begin 
            if(psels == 1'b1) begin
                if(pwrites == 1'b1) begin
                    access_state <= 8'h02;
                end
                else begin
                    access_state <= 8'h03;
                end
            end
        end
    end
        if(access_state == 8'h61) begin
            pready_temp <= 1'b1;
            access_state <= 8'h62;
        end
        else if(access_state == 8'h62) begin
            pready_temp <= 1'b0;
            access_state <= 8'h01;
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
        if(calc_state == 8'h01) begin
            if(control == 8'h01) begin
                sum_accum <= 32'h00000000;
                xcount <= 16'h0000;
                ycount <= 16'h0000;
                status <= 8'h01;
                calc_state <= 8'h00;
            end
        end
        else if(calc_state == 8'h04) begin
            I_Data <= (I_Data_temp > threshold) ? I_Data_temp: 8'h00;
            calc_state <= 8'h05;
        end
        else if(calc_state == 8'h05) begin
            sum_accum <= sum_accum + I_Data;
            calc_state <= 8'h06;
        end
        else if(calc_state == 8'h06) begin
            xcount <= xcount + 16'h0001;
            calc_state <= 8'h07;
        end
        else if(calc_state == 8'h07) begin
            if(xcount == xmax) begin
                calc_state <= 8'h03;
            end
            else begin
                status <= 8'h02;
            end
            calc_state <= 8'h00;
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