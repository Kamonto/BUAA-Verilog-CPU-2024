`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:20:24 10/29/2024 
// Design Name: 
// Module Name:    EXT 
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
module EXT(
    input [15:0] imm16,
    input ExtOp,
    output [31:0] ext32
    );
    
    wire [31:0] zero_ext;
    wire [31:0] sign_ext;

assign zero_ext = {16'h0000, imm16};
assign sign_ext = {{16{imm16[15]}}, imm16};

assign ext32 = (ExtOp) ? sign_ext : zero_ext;

endmodule
