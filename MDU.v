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
    input [4:0] type,
    input start,
    output [31:0] outputA,
    output busy
    );
    
    reg [31:0] HI;
    reg [31:0] LO;
    reg [3:0] round;
    reg [3:0] max_round;
    reg busy_reg;
    
    parameter MULT = 5'b10101,
              MULTU = 5'b10110,
              DIV = 5'b10111,
              DIVU = 5'b11000,
              MFHI = 5'b11001,
              MFLO = 5'b11010,
              MTHI = 5'b11011,
              MTLO = 5'b11100,
              NEWB = 5'b11101;

always@(posedge clk) begin
    if (reset) begin
        HI <= 32'h00000000;
        LO <= 32'h00000000;
        round <= 4'h0;
        max_round <= 4'h0;
        busy_reg <= 1'b0;
    end
    else begin
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
