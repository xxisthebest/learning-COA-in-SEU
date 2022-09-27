`timescale 1ns / 1ps

module MR(
    input clk,
    input rst,
    input [31:0]control_signals,//C9,               // ALU to ACC
    input [15:0] alu_mr,    // data from ALU
    output reg [15:0] mr_out = 0
);

    always @(posedge clk )
    begin
//        if (~rst)
//            mr_out <= 0;
        if (control_signals[27])
            mr_out <= alu_mr; 
    end

endmodule // MR