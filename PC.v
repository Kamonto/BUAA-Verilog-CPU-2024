`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:37:23 10/29/2024 
// Design Name: 
// Module Name:    PC 
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
module PC(
    input clk,
    input en,
    input reset,
    input [31:0] inputPC,
    output [31:0] outputPC
    );
    
    reg [31:0] PC;

always@(posedge clk) begin
    if (reset) begin
        PC <= 32'h00000000;
    end
    else begin
        if (en) begin
            PC <= (inputPC ^ 32'h00003000);
        end
    end
end

assign outputPC = (PC ^ 32'h00003000);

endmodule
