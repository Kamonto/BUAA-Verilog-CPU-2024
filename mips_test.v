`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:30:48 10/29/2024
// Design Name:   mips
// Module Name:   D:/ISE/ISE_Projects/Verilog-CPU/mips_test.v
// Project Name:  Verilog-CPU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mips_test;

    // Inputs
    reg clk;
    reg reset;

    // Instantiate the Unit Under Test (UUT)
    mips uut (
        .clk(clk), 
        .reset(reset)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 0;

        // Wait 100 ns for global reset to finish
        #25;
        
        reset = 1;
        
        #50;
        
        reset = 0;
        
        #25;
        
        // Add stimulus here

    end
    
    always #10 clk = ~clk;
      
endmodule

