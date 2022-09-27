`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/13 17:52:46
// Design Name: 
// Module Name: memsim
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


module memsim(
    input clk,
 //   input rst,
 //   input [7:0] ir_cu,
 //   input [5:0] flags,      // CF,PF,AF,ZF,SF,OF
    output  [31:0] Control_signals
  //  output reg [3:0] CU_ALU=0
    );
//由于需要使用微指令，因此使用RAM作为Memory寄存器
reg [0:0]Wea=1'b0;
reg [31:0]dina=32'b0;
reg [7:0]addra=8'b0;
wire [31:0]control_signals;
MEMORY memory (
  .clka(clk),    // input wire clka
  .wea(Wea),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [7 : 0] addra
  .dina(dina),    // input wire [31 : 0] dina
  .douta(control_signals)  // output wire [31 : 0] douta
);  
assign Control_signals=control_signals;
always @(posedge clk)begin
    if (addra<=8'd255)
    addra=addra+1;
    else addra<=0;
end  
endmodule
