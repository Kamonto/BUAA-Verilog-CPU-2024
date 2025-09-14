`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:35:47 11/21/2024 
// Design Name: 
// Module Name:    BE 
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
module BE(
    input [31:0] addr,
    input [31:0] data,
    input [5:0] type,
    input Req,
    output [3:0] byteen,
    output [31:0] fixed_data
    );
    
    parameter SW = 6'b000100,
              SH = 6'b010100,
              SB = 6'b010011,
              NEWB = 6'b100001;

    wire [1:0] addr_tail;
    
assign addr_tail = addr[1:0];
    
assign byteen = (Req) ? 4'b0000 :
                (type == SW) ? 4'b1111 :
                (type == SH && addr_tail[1] == 1'b0) ? 4'b0011 : 
                (type == SH && addr_tail[1] == 1'b1) ? 4'b1100 : 
                (type == SB && addr_tail == 2'b00) ? 4'b0001 : 
                (type == SB && addr_tail == 2'b01) ? 4'b0010 : 
                (type == SB && addr_tail == 2'b10) ? 4'b0100 : 
                (type == SB && addr_tail == 2'b11) ? 4'b1000 : 
                4'b0000;
   
assign fixed_data = (type == SW) ? data :
                    (type == SH && addr_tail[1] == 1'b0) ? {16'h0000, data[15:0]} : 
                    (type == SH && addr_tail[1] == 1'b1) ? {data[15:0], 16'h0000} : 
                    (type == SB && addr_tail == 2'b00) ? {24'h000000, data[7:0]} : 
                    (type == SB && addr_tail == 2'b01) ? {16'h0000, data[7:0], 8'h00} : 
                    (type == SB && addr_tail == 2'b10) ? {8'h00, data[7:0], 16'h0000} : 
                    (type == SB && addr_tail == 2'b11) ? {data[7:0], 24'h000000} : 
                    32'h00000000;

endmodule
