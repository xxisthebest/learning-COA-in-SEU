`timescale 1ns / 1ps

module IR(
    input clk,
    input rst,
    input [31:0]control_signals,//C4,               // MBR to IR
    input [7:0] mbr_ir,
    output reg [7:0] ir_out=0
);

    always @(posedge clk )
    begin
//        if (~rst)
//            ir_out <= 0;
//        else
//        begin
            if(control_signals[4])
                ir_out <= mbr_ir;
//        end
    end

endmodule // IR