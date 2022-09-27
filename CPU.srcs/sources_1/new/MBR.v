`timescale 1ns / 1ps

module MBR(
    input clk,
    input rst,
    input [31:0]control_signals,//C1,               //  PC to MBR
//    input C5,               // RAM to MBR
//    input C11,              // ACC to MBR
//    input C13,              // MR to MBR
    input [15:0] acc_mbr,
    input [15:0] ram_mbr,
    input [7:0] pc_mbr,
    input [15:0] mr_mbr,
    
    output reg [15:0] mbr_out=0
);

    always @(posedge clk )
    begin
//        if (~rst)
//            mbr_out <= 0;
//        else
//        begin
            if(control_signals[3])
                mbr_out <= ram_mbr;
            else if(control_signals[17])
                mbr_out <= acc_mbr;
            else if(control_signals[28])
                mbr_out <= mr_mbr;
            else if(control_signals[16])
            begin
                mbr_out[7:0] <= pc_mbr;
                mbr_out[15:8] <= 0;
            end
//        end
    end

endmodule // MBR