`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:07:45 11/30/2024 
// Design Name: 
// Module Name:    CP0 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module CP0(
    input clk,
    input reset,
    
    input WE,
    input [4:0] addr,
    input [31:0] WD,
    output [31:0] data,
    
    input [31:0] VPC,
    input BDIn,
    input [4:0] ExcCodeIn,
    input [5:0] HWInt,
    input EXLClr,
    output [31:0] EPCOut,
    output Req
    );
    
    wire [31:0] SR;
    wire [31:0] Cause;
    
    reg [15:10] SR_IM;
    reg [1:1] SR_EXL;
    reg [0:0] SR_IE;
    reg [31:31] Cause_BD;
    reg [15:10] Cause_IP;
    reg [6:2] Cause_ExcCode;
    reg [31:0] EPC;
    reg [31:0] PRId;
    
    assign SR = {16'h0000, SR_IM, 8'h00, SR_EXL, SR_IE};
    assign Cause = {Cause_BD, 15'b000000000000000, Cause_IP, 3'b000, Cause_ExcCode, 2'b00};
    
    
always@(posedge clk) begin
    if (reset) begin
        SR_IM <= 6'b000000;
        SR_EXL <= 1'b0;
        SR_IE <= 1'b0;
        Cause_BD <= 1'b0;
        Cause_IP <= 6'b000000;
        Cause_ExcCode <= 5'b00000;
        EPC <= 32'h00000000;
        PRId <= 32'hb87860c0;
    end
    else begin
        if (WE && ~Req) begin
            if (addr == 5'b01100) begin
                SR_IM <= WD[15:10];
                SR_EXL <= WD[1];
                SR_IE <= WD[0];
            end
            else if (addr == 5'b01101) begin
                Cause_BD <= WD[31];
                Cause_IP <= WD[15:10];
                Cause_ExcCode <= WD[6:2];
            end
            else if (addr == 5'b01110) begin
                EPC <= WD;
            end
        end
        if (Req) begin
            SR_EXL <= 1'b1;
            Cause_BD <= BDIn;
            Cause_ExcCode <= (~SR_EXL && SR_IE && (SR_IM & HWInt)) ? 5'b0 : ExcCodeIn;
            EPC <= (BDIn) ? (VPC - 32'h00000004) : VPC;
        end
        if (EXLClr) begin
            SR_EXL <= 1'b0;
        end
        Cause_IP <= HWInt;
    end
end

assign data = (addr == 5'b01100) ? SR : 
              (addr == 5'b01101) ? Cause : 
              (addr == 5'b01110) ? EPC : 
              (addr == 5'b01111) ? PRId : 32'h00000000;

assign EPCOut = EPC;

assign Req = (~SR_EXL && ((SR_IE && (SR_IM & HWInt)) || (ExcCodeIn)));

endmodule
