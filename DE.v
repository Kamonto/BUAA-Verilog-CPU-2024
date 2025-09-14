`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:49:13 11/21/2024 
// Design Name: 
// Module Name:    DE 
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
module DE(
    input [31:0] addr,
    input [31:0] data,
    input [5:0] type,
    output [31:0] fixed_data
    );
    
    parameter LW = 6'b000011,
              LH = 6'b010010,
              LB = 6'b010001,
              NEWB = 6'b100001;

    wire [1:0] addr_tail;
    wire [15:0] half_data;
    wire [7:0] byte_data;
    
assign addr_tail = addr[1:0];

assign half_data = (type == LH && addr_tail[1] == 1'b0) ? data[15:0] : 
                   (type == LH && addr_tail[1] == 1'b1) ? data[31:16] : 
                   16'h0000;

assign byte_data = (type == LB && addr_tail == 2'b00) ? data[7:0] : 
                   (type == LB && addr_tail == 2'b01) ? data[15:8] : 
                   (type == LB && addr_tail == 2'b10) ? data[23:16] : 
                   (type == LB && addr_tail == 2'b11) ? data[31:24] :
                   8'h00;                       
                       
assign fixed_data = (type == LW) ? data :
                    (type == LH) ? {{16{half_data[15]}}, half_data} : 
                    (type == LB) ? {{24{byte_data[7]}}, byte_data} : 
                    32'h00000000;

endmodule
