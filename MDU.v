`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:10:54 11/22/2024 
// Design Name: 
// Module Name:    MDU 
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
module MDU(
    input clk,
    input reset,
    input [31:0] inputA,
    input [31:0] inputB,
    input [5:0] type,
    input start,
    input Req,
    output [31:0] outputA,
    output busy
    );
    
    reg [31:0] HI;
    reg [31:0] LO;
    reg [3:0] round;
    reg [3:0] max_round;
    reg busy_reg;
    
    parameter MULT = 6'b010101,
              MULTU = 6'b010110,
              DIV = 6'b010111,
              DIVU = 6'b011000,
              MFHI = 6'b011001,
              MFLO = 6'b011010,
              MTHI = 6'b011011,
              MTLO = 6'b011100,
              NEWB = 6'b100001;
              
always@(posedge clk) begin
    if (reset) begin
        HI <= 32'h00000000;
        LO <= 32'h00000000;
        round <= 4'h0;
        max_round <= 4'h0;
        busy_reg <= 1'b0;
    end
    else if (~Req) begin
        if (type == MTHI) begin
            HI <= inputA;
        end
        else if (type == MTLO) begin
            LO <= inputA;
        end
        else if (type == MULT) begin
            {HI, LO} <= $signed(inputA) * $signed(inputB);
        end
        else if (type == MULTU) begin
            {HI, LO} <= inputA * inputB;
        end
        else if (type == DIV) begin
            if (inputB != 32'h00000000) begin
                HI <= $signed(inputA) % $signed(inputB);
                LO <= $signed(inputA) / $signed(inputB);
            end
        end
        else if (type == DIVU) begin
            if (inputB != 32'h00000000) begin
                HI <= inputA % inputB;
                LO <= inputA / inputB;
            end
        end
        
        if (start) begin
            if (type == MULT || type == MULTU) begin
                round <= 4'h1;
                max_round <= 4'h5;
                busy_reg <= 1'b1;
            end
            else if (type == DIV || type == DIVU) begin
                round <= 4'h1;
                max_round <= 4'ha;
                busy_reg <= 1'b1;
            end
        end
        
        if (busy) begin
            if (round != max_round) begin
                round <= round + 4'h1;
            end
            else begin
                busy_reg <= 1'b0;
                round <= 4'h0;
                max_round <= 4'h0;
            end
        end
    end
end

assign outputA = (type == MFHI) ? HI : 
                 (type == MFLO) ? LO : 32'h00000000;

assign busy = busy_reg;

endmodule
