`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/13 17:59:28
// Design Name: 
// Module Name: memsim_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module memsim_tb();
reg clk;
wire [31:0]Control_signals;
memsim test(
    .clk(clk),
    .Control_signals(Control_signals)
);
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end
endmodule
