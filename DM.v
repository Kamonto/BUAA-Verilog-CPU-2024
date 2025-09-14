`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:57:53 10/29/2024 
// Design Name: 
// Module Name:    DM 
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
module DM(
    input clk,
    input reset,
    input WE,
    input [31:0] addr,
    input [31:0] WD,
    input [31:0] PC,
    output [31:0] data
    );
    
    reg [31:0] RAM [0:3071];
    
    wire [31:0] RAM_addr;
    
    integer i;

assign RAM_addr = (addr >> 2);

always@(posedge clk) begin
    if (reset) begin
        for (i = 0; i < 3072; i = i + 1) begin
            RAM[i] = 32'h00000000;
        end
    end
    else begin
        if (WE) begin
            RAM[RAM_addr] <= WD;
            $display("%d@%h: *%h <= %h", $time, PC, addr, WD);
            //$display("@%h: *%h <= %h", PC, addr, WD);
        end
    end
end

assign data = RAM[RAM_addr];

endmodule
