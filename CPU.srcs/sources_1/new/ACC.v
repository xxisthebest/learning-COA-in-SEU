`timescale 1ns / 1ps

module ACC(
    input clk,
    input clk_seg,
    input rst,
    input [31:0]control_signals,//C9,               // ALU to ACC
    //input C10,              // MBR to ACC
    input [15:0] alu_acc,    // data from ALU
    input [15:0] mbr_acc,    // data from MBR
    input [31:0] Eightnum,
    output reg [15:0] acc_out=0,
    output [31:0] num,
	output [6:0] seg,
	output [7:0] an,
	output dp

    );

    always @(posedge clk )
    begin
        if (control_signals[27])
            acc_out = alu_acc;
        else if (control_signals[15])
            acc_out = mbr_acc;
         else if (control_signals[8])
            acc_out = 0;   
    end
    seg7 display( clk, clk_seg, rst, Eightnum, seg, an, dp );
    
endmodule
