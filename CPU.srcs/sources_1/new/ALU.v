`timescale 1ns / 1ps
// `include "params.v"
// TODO: addition overflow
/*
��λ��־CF

��λ��־CF��Ҫ������ӳ�����Ƿ������λ����������������λ������һ����λ�����λ����
��ô����ֵΪ1��������ֵΪ0��ʹ�øñ�־λ������У�����(�ֽ�)���ļӼ����㣬�޷������Ĵ�С�Ƚ����㣬
��λ��������(�ֽ�)֮����λ��ר�Ÿı�CFֵ��ָ��ȡ�

��ż��־PF

��ż��־PF���ڷ�ӳ��������"1"�ĸ�������ż�ԡ����"1"�ĸ���Ϊż������PF��ֵΪ1��������ֵΪ0��
����PF�ɽ�����żУ���飬�������żУ��λ�������ݴ��͹����У�Ϊ���ṩ���͵Ŀɿ��ԣ��������
��żУ��ķ������Ϳ�ʹ�øñ�־λ��

������λ��־AF

�ڷ����������ʱ��������λ��־AF��ֵ����Ϊ1��������ֵΪ0��
(1)�����ֲ���ʱ���������ֽ�����ֽڽ�λ���λʱ��
(2)�����ֽڲ���ʱ��������4λ���4λ��λ���λʱ��
���־ZF

���־ZF������ӳ�������Ƿ�Ϊ0�����������Ϊ0������ֵΪ1��������ֵΪ0��
���ű�־SF

���ű�־SF������ӳ�������ķ���λ�����������������λ��ͬ��������Ϊ����ʱ��SF��ֵΪ0��������ֵΪ1��
�����־OF

������������ǰ����λ�����ܱ�ʾ�ķ�Χ��OF��ֵ����Ϊ1������OF��ֵ����Ϊ0
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
