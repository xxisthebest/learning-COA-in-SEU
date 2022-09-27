`timescale 1ns / 1ps

module BR(
    input clk,
    input rst,
    input [31:0]control_signals,//C6,               // MBR to BR
    input [15:0] mbr_br,    // data from MBR
    output reg [15:0] br_out = 0
    );

    always @(posedge clk )
    begin
//        if (~rst)
//            br_out <= 0;
        if (control_signals[7])
            br_out <= mbr_br;
    end

endmodule
