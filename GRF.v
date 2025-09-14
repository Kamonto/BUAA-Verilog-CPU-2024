`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:36:43 10/29/2024 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input clk,
    input reset,
    input WE,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    input [31:0] PC,
    output [31:0] RD1,
    output [31:0] RD2
    );
    
    reg [31:0] GRF [0:31];
    
    integer i;

always@(posedge clk) begin
    if (reset) begin
        for (i = 0; i < 32; i = i + 1) begin
            GRF[i] <= 32'h00000000;
        end
    end
    else begin
        if (WE) begin
            if (A3 != 5'b00000) begin
                GRF[A3] <= WD;
                $display("@%h: $%d <= %h", PC, A3, WD);
            end
        end
    end
end

assign RD1 = GRF[A1];
assign RD2 = GRF[A2];

endmodule
