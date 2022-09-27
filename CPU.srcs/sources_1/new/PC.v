`timescale 1ns / 1ps

module PC(
    input clk,
    input rst,
    input [31:0]control_signals,//C3,               // MBR to PC
   // input C15,              // PC ++
    input [7:0] mbr_pc,
    output reg [7:0] pc_out=0
);

    always @(posedge clk )
    begin
//        if (~rst)
//            pc_out <= 0;
//        else
//        begin
            if(control_signals[13])
                pc_out <= mbr_pc;
            else if(control_signals[6])
                pc_out <= pc_out + 1;
//        end
    end

endmodule // PC