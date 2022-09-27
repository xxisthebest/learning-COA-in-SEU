`timescale 1ns / 1ps

module MAR(
    input clk,
    input rst,
    input [31:0]control_signals,//C2,           // PC to MAR
   // input C8,           // MBR to MAR
    input [7:0] pc_mar,
    input [7:0] mbr_mar,

    output reg [7:0] mar_out
);
reg t=0;
    always @(posedge clk )//
    begin
//        if (~rst)
//            mar_out <= 0;
//        else
//        begin
            if(control_signals[5])
                mar_out <= mbr_mar;
            else if(control_signals[10])
                mar_out <= pc_mar;
//        end
    end

endmodule // MAR