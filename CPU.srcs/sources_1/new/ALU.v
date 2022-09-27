`timescale 1ns / 1ps
// `include "params.v"
// TODO: addition overflow
/*
进位标志CF

进位标志CF主要用来反映运算是否产生进位。如果运算结果的最高位产生了一个进位（或借位），
那么，其值为1，否则其值为0。使用该标志位的情况有：多字(字节)数的加减运算，无符号数的大小比较运算，
移位操作，字(字节)之间移位，专门改变CF值的指令等。

奇偶标志PF

奇偶标志PF用于反映运算结果中"1"的个数的奇偶性。如果"1"的个数为偶数，则PF的值为1，否则其值为0。
利用PF可进行奇偶校验检查，或产生奇偶校验位。在数据传送过程中，为了提供传送的可靠性，如果采用
奇偶校验的方法，就可使用该标志位。

辅助进位标志AF

在发生下列情况时，辅助进位标志AF的值被置为1，否则其值为0：
(1)、在字操作时，发生低字节向高字节进位或借位时；
(2)、在字节操作时，发生低4位向高4位进位或借位时。
零标志ZF

零标志ZF用来反映运算结果是否为0。如果运算结果为0，则其值为1，否则其值为0。
符号标志SF

符号标志SF用来反映运算结果的符号位，它与运算结果的最高位相同。运算结果为正数时，SF的值为0，否则其值为1。
溢出标志OF

运算结果超过当前运算位数所能表示的范围，OF的值被置为1，否则，OF的值被清为0
*/
module ALU(
    input clk,
   // input C7,                   // ACC to ALU
    input [31:0]control_signals,//C14, BR to ALU
    input [3:0] cu_alu,         // signal from CU
    input [15:0] acc_alu,       // data from ACC
    input [15:0] br_alu,        // data from BR
    output reg [31:0] eightnum,
    output reg [15:0] alu2mr=0,   // data to MR
    output reg [15:0] alu2acc,  // data to ACC
    output reg [5:0] flags,      // 5CF,4PF,3AF,2ZF,1SF,0OF
    
    input [4:0] btn,
	input [15:0] sw,
	output [6:0] seg,
	output [7:0] an,
	output dp,
	output [21:0] led
    );

    // para for operation(cu2alu)
    parameter ADD = 4'd1;
    parameter SUB = 4'd2;
    parameter AND = 4'd3;
    parameter OR = 4'd4;
    parameter NOT = 4'd5;
    parameter SRL = 4'd6;
    parameter SRR = 4'd7;
    parameter MPY = 4'd8;
    parameter LOAD = 4'd9;
    
    reg [15:0] acc_in;
    reg [15:0] br_in;
    reg [31:0] exbr = 0, exacc = 0, temp = 0;
    integer i;

    always @(posedge clk)
    begin
        if (control_signals[18])
            acc_in <= acc_alu;
        if (control_signals[14])
            br_in <= br_alu;
        if (control_signals[9])
        alu2acc<=acc_in + br_in;
    end

    always @(posedge clk)
    begin
        eightnum[31:16]=alu2mr; 
        temp = 0;
        exbr = 0;
        exacc = 0;
        case (cu_alu)
            ADD: begin// ADD
                flags = 0;
                temp = acc_in + br_in;
                if (acc_in[15] == 0 && br_in[15] == 0 && temp[15] == 1) begin
                    flags[5] <= 1; // CF
                    temp[15] = 0;
                end
                alu2acc <= temp[15:0];
                eightnum[15:0]=alu2acc;
                flags[2] = !alu2acc; // ZF
                flags[1] = alu2acc[15]; // SF
            end
            SUB: begin// SUB
                flags = 0;
                temp = acc_in - br_in;
                if (acc_in[15] == 1 && br_in[15] == 0 && temp[31] == 0) begin
                    flags[5] <= 1; // CF
                    temp[15] = 1;
                end
                alu2acc <= temp[15:0];
                eightnum[15:0]=alu2acc;
                flags[2] = !alu2acc; // ZF
                flags[1] = alu2acc[15]; // SF
            end
            AND: begin// AND
                flags = 0;
                alu2acc <= acc_in & br_in;
                eightnum[15:0]=alu2acc;
                flags[2] = !alu2acc; // ZF
                flags[1] = alu2acc[15]; // SF
            end
            OR: begin// OR
                flags = 0;
                alu2acc <= acc_in | br_in;
                eightnum[15:0]=alu2acc;
                flags[2] = !alu2acc; // ZF
                flags[1] = alu2acc[15]; // SF
            end
            NOT: begin// NOT
                flags = 0;
                alu2acc <= ~br_in;
                eightnum[15:0]=alu2acc;
                flags[2] = !alu2acc; // ZF
                flags[1] = alu2acc[15]; // SF
            end
            SRL: begin// SRL
                flags = 0;
                temp = br_in << 1;
                if (br_in[15] == 0 && temp[15] == 1)
                    flags[5] <= 1; // CF
                alu2acc[15] <= br_in[15];
                alu2acc[14:0] <= temp[14:0];
                eightnum[15:0]=alu2acc;
                flags[2] = !alu2acc; // ZF
                flags[1] = alu2acc[15]; // SF
            end
            SRR: begin// SRR
                flags = 0;
                temp = br_in >> 1;
                if (br_in[15] == 0 && temp[15] == 1)
                    flags[5] <= 1; // CF
                alu2acc[15] <= br_in[15];
                alu2acc[14:0] <= temp[14:0];
                eightnum[15:0]=alu2acc; 
                flags[2] = !alu2acc; // ZF
                flags[1] = alu2acc[15]; // SF
            end
            MPY: // MPY
            begin
                flags = 0;

                // sign extend
                exbr[15:0] = br_in;
                exacc[15:0] = acc_in;
                for (i = 16; i < 32; i = i + 1) begin
                    exbr[i] = br_in[15];
                    exacc[i] = acc_in[15];
                end
                for (i = 0; i < 31; i = i + 1)
                begin
                    if (exbr[i])
                        temp = temp + (exacc << i);
                end
                temp[31]=br_in[15]+acc_in[15];
                alu2acc = temp[15:0];
                alu2mr = temp[31:16];
                eightnum[15:0]=temp[15:0];
                eightnum[31:16]=alu2mr;                
                flags[2] = !alu2acc; // ZF
                flags[1] = alu2acc[15]; // SF
            end
            LOAD:
                 eightnum[15:0]=acc_alu;
            default:
                begin
                alu2acc <= 0;
                eightnum[31:0]={16'h0000,alu2acc};
                end
        endcase
    end

endmodule
