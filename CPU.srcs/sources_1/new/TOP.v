`timescale 1ns / 1ps

module TOP_sim(
    input CLK100MHZ,
    input rst,
    //input [4:0] BTN,
    output [6:0] SEG,
    output [7:0] AN,
    output DP
    //output [21:0] LED
);
    reg CLK50MHZ = 0;
    reg [22:0]cnt=23'h00000;
    parameter counter=5'd6;
    always @(posedge(CLK100MHZ)) 
    begin
        if(cnt==23'd9)
            cnt <= 0;
        else cnt <= cnt+1'b1;
    end
    always @(posedge(CLK100MHZ)) 
    begin
        if(cnt==23'd9)
            CLK50MHZ <= ~CLK50MHZ;
    end
    wire [15:0] SWout;
    wire [4:0] BTNout;
    wire [31:0]eightnum, control_signal;
    wire [31:0] num = 31'h00000000;
    wire [15:0] BR_ALU, ALU_MR, ALU_ACC, MBR_OUT, ACC_OUT, MR_OUT, RAM_OUT;
    wire [7:0] IR_OUT, PC_OUT, MAR_OUT;
    wire [5:0] flags;
    wire [3:0] CU_ALU;

    ACC acc(CLK50MHZ, CLK100MHZ, rst, control_signal, ALU_ACC, MBR_OUT, eightnum, ACC_OUT, num, SEG, AN, DP);

    ALU alu(CLK50MHZ, control_signal, CU_ALU, ACC_OUT, BR_ALU, eightnum, ALU_MR, ALU_ACC, flags);

    BR br(CLK50MHZ, rst, control_signal, MBR_OUT, BR_ALU);

    CU cu(CLK50MHZ, rst, IR_OUT, flags, control_signal, CU_ALU);

    IR ir(CLK50MHZ, rst, control_signal, MBR_OUT[15:8], IR_OUT);

    MAR mar(CLK50MHZ, rst, control_signal, PC_OUT, MBR_OUT[7:0], MAR_OUT);

    MBR mbr(CLK50MHZ, rst, control_signal, ACC_OUT, RAM_OUT, PC_OUT, MR_OUT, MBR_OUT);

    MR mr(CLK50MHZ, rst, control_signal, ALU_MR, MR_OUT);

    PC pc(CLK50MHZ, rst, control_signal, MBR_OUT[7:0], PC_OUT);

    RAM_mod ram_mod(CLK50MHZ, rst, control_signal, MAR_OUT, MBR_OUT, RAM_OUT);



endmodule // TOP_sim

module TOP_alu(
    input clk,
    input rst,
    input [15:0] control_signal, // control signals
    input [3:0] cu,
    input [15:0] MBR_ACC,
    input [15:0] mbr2br
);

    wire [15:0] br2alu, alu2mr, alu2acc, acc_out, mr_out;
    wire [5:0] flags;

    ALU alu(clk, control_signal, cu, acc_out, br2alu, alu2mr, alu2acc, flags);

    ACC acc(clk, rst, control_signal, alu2acc, MBR_ACC, acc_out);

    BR br(clk, rst, control_signal, mbr2br, br2alu);

    MR mr(clk, rst, control_signal, alu2mr, mr_out);

endmodule // TOP_alu