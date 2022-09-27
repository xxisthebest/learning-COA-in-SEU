`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/05 13:31:28
// Design Name: 
// Module Name: seg7
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seg7(
    input clk,
    input clk_seg,
    input rst,
    input [31:0] eightnum,//目前仅取ACC的低16位
    output reg [6:0] seg,
    output reg [7:0] an,
    output wire dp
    );
    
    wire [2:0] s; // select digit
    reg [3:0] digit;
    wire [7:0] aen;
    reg [19:0] clkdiv = 0;
    wire [31:0] num;
    assign num[31:0]=eightnum[31:0];
    assign dp  = 1; // 不输出小数点
    assign s   = clkdiv[19:17];
    assign aen = 8'b11111111; // all turned off initially
    integer i;
//    always @(posedge clk ) begin
//        num[31:0]=eightnum[31:0];
//    end
    always @(posedge clk_seg ) begin
//        if (~rst)begin
//            case (0)
//                0: num =    32'h1E2FF123;
//                1: num =    32'h56000000;
//                2: num =    32'h66600000;
//                3: num =    32'h06660000;
//                4: num =    32'h00666000;
//                5: num =    32'h00066600;
//                6: num =    32'h00006660;
//                7: num =    32'h00000666;
//                8: num =    32'h00000067;
//                9: num =    32'h0000001A;
//                10: num =   32'h00000111;
//                11: num =   32'h00001110;
//                12: num =   32'h00011100;
//                13: num =   32'h00111000;
//                14: num =   32'h01110000;
//                15: num =   32'h11100000;     //???这一段啥玩意儿
//            endcase  
//            case(digit)       
//                   0:seg   = 7'b1111111;////0000                                         
//                   1:seg   = 7'b0010010;//S                                          
//                   2:seg   = 7'b1000001;//U                                 
//                   3:seg   = 7'b0000011;//b                            
//                   4:seg   = 7'b1000111;////0100                              
//                   5:seg   = 7'b1100111;////0101             
//                   7:seg   = 7'b1110011;////0111
//                   8:seg   = 7'b1110001;////1000
//                   9:seg   = 7'b1111000;////1001
//                   'hA:seg = 7'b1111100;
//                   'hB:seg = 7'b0100011;//o
//                   'hC:seg = 7'b0101111;//r
//                   'hD:seg = 7'b0101111;//r
//                   'hE:seg = 7'b0000110;//E
//                   'hF:seg = 7'b0111111;//-
//                   default: seg = 7'b0000000; // U
//               endcase      
//        end
        //else begin
            

        //end
            case(s)//每一个digit对应一个数码管，因此每一个num只能对应一个0-9的10个数字，不停的扫描
                0:digit = num[3:0]; // s is 00 -->0 ;  digit gets assigned 4 bit value assigned to num[3:0]
                1:digit = num[7:4]; // s is 01 -->1 ;  digit gets assigned 4 bit value assigned to num[7:4]
                2:digit = num[11:8]; // s is 10 -->2 ;  digit gets assigned 4 bit value assigned to num[11:8
                3:digit = num[15:12]; // s is 11 -->3 ;  digit gets assigned 4 bit value assigned to num[15:12]
                4:digit = num[19:16]; // s is 00 -->0 ;  digit gets assigned 4 bit value assigned to num[3:0]
                5:digit = num[23:20]; // s is 01 -->1 ;  digit gets assigned 4 bit value assigned to num[7:4]
                6:digit = num[27:24]; // s is 10 -->2 ;  digit gets assigned 4 bit value assigned to num[11:8
                7:digit = num[31:28]; // s is 11 -->3 ;  digit gets assigned 4 bit value assigned to num[15:12]
                default:digit = num[3:0];
            endcase
             case(digit)
                   // 0 is lit // 1 is unlit //
                   //////////<---MSB-LSB<---
                   //////////////gfedcba////////////////////////////////////////////            
                   0:seg   = 7'b1000000;////0000                                             
                   1:seg   = 7'b1111001;////0001                                           
                   2:seg   = 7'b0100100;////0010                                        
                   3:seg   = 7'b0110000;////0011                                   
                   4:seg   = 7'b0011001;////0100                                    
                   5:seg   = 7'b0010010;////0101                                
                   6:seg   = 7'b0000010;////0110                                   
                   7:seg   = 7'b1111000;////0111
                   8:seg   = 7'b0000000;////1000
                   9:seg   = 7'b0010000;////1001
                   'hA:seg = 7'b0001000;
                   'hB:seg = 7'b0000011;
                   'hC:seg = 7'b1000110;
                   'hD:seg = 7'b0100001;
                   'hE:seg = 7'b0000110;
                   'hF:seg = 7'b0001110;               
                   default: seg = 7'b0111_111; 
            endcase                    
    end
    
    always @(*)
        begin
           an = 8'b11111111;
           if (aen[s] == 1)
               an[s] = 0;
    end
           
       //clkdiv
           
    always @(posedge clk_seg) begin
        clkdiv = clkdiv+1;
    end
endmodule
