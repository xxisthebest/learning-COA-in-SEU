`timescale 1ns / 1ps
// `include "params.v"

module CU(
    input clk,
    input rst,
    input [7:0] ir_cu,
    input [5:0] flags,      // CF,PF,AF,ZF,SF,OF
    output  [31:0] Control_signals,
    output reg [3:0] CU_ALU=0
);
//C0,               // MAR to RAM
//C1,               //  PC to MBR
//C2,           // PC to MAR
//C3,               // MBR to PC
//C4,               // MBR to IR
//C5,               // RAM to MBR
//C6,               // MBR to BR
//C7,                   // ACC to ALU
//C8,           // MBR to MAR
//C9,               // ALU to ACC
//C10,              // MBR to ACC
//C11,              // ACC to MBR
//C12,              // MBR to RAM
//C13,              // MR to MBR
//C14,              //BR to ALU
//C15,              // PC ++
reg [3:0] stat=0;
reg [7:0] opcode=0;
reg [3:0] cycle=0;

// para for opcode(ir2cu)
parameter STOREX    = 8'b00000001;
parameter LOADX     = 8'b00000010;
parameter ADDX      = 8'b00000011;
parameter SUBX      = 8'b00000100;
parameter JMPGEZX   = 8'b00000101;
parameter JMPX      = 8'b00000110;
parameter HALT      = 8'b00000111;//7

parameter MPYX      = 8'b00001000;
parameter STOREMR   = 8'b00001001;
parameter ANDX      = 8'b00001010;
parameter ORX       = 8'b00001011;//b
parameter NOTX      = 8'b00001100;//
parameter SHIFTR    = 8'b00001101;
parameter SHIFTL    = 8'b00001110;

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
//para for 
//由于需要使用微指令，因此使用RAM作为Memory寄存器
reg [0:0]Wea=1'b0;
reg [31:0]dina=32'b0;
reg [7:0]addra=8'b0;
wire [31:0]control_signals;
MEMORY memory (
  .clka(clk),    // input wire clka
  .wea(Wea),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [7 : 0] addra
  .dina(dina),    // input wire [31 : 0] dina
  .douta(control_signals)  // output wire [31 : 0] douta
);
assign Control_signals=control_signals;

always @(posedge clk ) begin // TODO: posedge clk?
    opcode<=ir_cu;
    if (control_signals[0]==1) addra<=addra+1;
    if (control_signals[19]==1) CU_ALU <= ADD;
    if (control_signals[20]==1) CU_ALU <= SUB;
    if (control_signals[21]==1) CU_ALU <= MPY;
    if (control_signals[22]==1) CU_ALU <= AND;
    if (control_signals[23]==1) CU_ALU <= OR;
    if (control_signals[24]==1) CU_ALU <= NOT;
    if (control_signals[25]==1) CU_ALU <= SRR;
    if (control_signals[26]==1) CU_ALU <= SRL;
    if (control_signals[1]==1) begin
        case(opcode)
            STOREX: begin
                addra <= 8'h0f;
            end
            LOADX: begin
                addra <= 8'h1f;
                CU_ALU <= LOAD;
            end 
            ADDX: begin
                addra <= 8'h2f;
            end
            SUBX: begin
                addra <= 8'h3f;
            end            
            JMPGEZX: begin
                if (flags[1]==0) addra <= 8'h4f;
                else addra <= 8'h51;
            end
            JMPX: begin
                addra <= 8'h5f;
            end
            HALT: begin
                addra <= 8'h6f;
            end 
            MPYX: begin
                addra <= 8'h7f;
            end   
            STOREMR: begin
                addra <= 8'h8f;
            end 
            ANDX: begin
                addra <= 8'h9f;
            end 
            ORX: begin
                addra <= 8'haf;
            end 
            NOTX: begin
                addra <= 8'hbf;
            end 
            SHIFTR: begin
                addra <= 8'hcf;
            end 
            SHIFTL: begin
                addra <= 8'hdf;
            end                                
        endcase
    end
    if (control_signals[2]==1) addra<=0;
//////////////////原程序
//        control_signals <= 0;
//        case (stat)
//            4'd0: begin
//                control_signals[2] <= 1; // get addr from PC to MAR
//                stat <= stat + 1;
//            end
//            4'd1: begin
//                control_signals[0] <= 1; // notify RAM
//                control_signals[15] <= 1; // PC++
//                stat <= stat + 1;
//            end
//            4'd2: begin

//                stat <= stat + 1;
//            end
//            4'd3: begin

//                stat <= stat + 1;
//            end                        
//            4'd4: begin
//                control_signals[5] <= 1; // get data from RAM to MBR
//                stat <= stat + 1;
//            end
//            4'd5: begin
//                control_signals[4] <= 1; // get data from MBR to IR
//                stat <= stat + 1;
//            end
//            4'd6: begin
//                // wait for opcode
//                stat <= stat + 1;
//            end
//            4'd7: begin
//                opcode = ir_cu;
//                case (opcode)
//                    STOREX: begin
//                        case (cycle)
//                            3'd0: begin
//                                control_signals[8] <= 1; // get addr from MBR to MAR 
//                                cycle <= cycle + 1;
//                            end
//                            3'd1: begin
//                                control_signals[11] <= 1; // get data from ACC to MBR
//                                cycle <= cycle + 1;
//                            end
////-----------------------modified------------------------------                            
//                            3'd2: begin
//                                control_signals[0] <= 1; // notify RAM
//                                control_signals[12] <= 1; // get data from MBR to RAM
//                                cycle <= cycle + 1;
//                            end
//                            3'd3: begin
//                                cycle <= cycle + 1;
//                            end
//                            3'd4: begin
//                                stat <= stat + 1;
//                                cycle <= 0;
//                            end
////-------------------------------------------------------------                                                        
//                        endcase
//                    end
//                    LOADX: begin
//                        case (cycle)
//                            3'd0: begin
//                                control_signals[8] <= 1; // get addr from MBR to MAR 
//                                cycle <= cycle + 1;
//                            end
////------------------------modified-----------------------                             
//                            3'd1: begin
//                                control_signals[0] <= 1; // notify RAM
//                                cycle <= cycle + 1;
//                            end                           
//                            3'd2: begin
//                                cycle <= cycle + 1;
//                            end
//                            3'd3: begin
//                                cycle <= cycle + 1;
//                            end  
////-------------------------------------------------------                                                                                
//                            3'd4: begin
//                                control_signals[5] <= 1; // get data from RAM to MBR
//                                cycle <= cycle + 1;
//                            end                                                                                
//                            3'd5: begin
//                                control_signals[10] <= 1; // get data from MBR to ACC
//                                stat <= stat + 1;
//                                cycle <= 0;
//                            end
//                        endcase
//                    end
//                    ADDX: begin
//                        case (cycle)
//                            3'd0: begin
//                                control_signals[8] <= 1; // get addr from MBR to MAR 
//                                cycle <= cycle + 1;
//                            end
////------------------------modified-----------------------                             
//                            3'd1: begin
//                                control_signals[0] <= 1; // notify RAM
//                                cycle <= cycle + 1;
//                            end                           
//                            3'd2: begin
//                                cycle <= cycle + 1;
//                            end
//                            3'd3: begin
//                                cycle <= cycle + 1;
//                            end  
////------------------------------------------------------- 
////----------------------modified--------------------------                                                                                  
//                            3'd4: begin
//                                control_signals[5] <= 1; // get data from RAM to MBR
//                                cycle <= cycle + 1;
//                            end
////---------------------------------------------------------                                                          
//                            3'd5: begin
//                                control_signals[6] <= 1; // get data from MBR to BR
//                                cycle <= cycle + 1;
//                            end
//                            4'd6: begin
//                                control_signals[7] <= 1; // send ACC to ALU
//                                control_signals[14] <= 1; // send BR to ALU
//                                CU_ALU <= ADD; // do calculation
//                                cycle <= cycle + 1;
//                            end
//                            4'd7: begin
//                                // wait for alu
//                                cycle <= cycle + 1;
//                            end
//                            4'd8: begin
//                                control_signals[9] <= 1; // get data from ALU to ACC
//                                stat <= stat + 1;
//                                cycle <= 0;
//                            end
//                        endcase
//                    end
//                    SUBX: begin
//                        case (cycle)
//                            3'd0: begin
//                                control_signals[8] <=  1; // get addr from MBR to MAR 
//                                cycle <= cycle + 1;
//                            end
////------------------------modified-----------------------                             
//                            3'd1: begin
//                                control_signals[0] <= 1; // notify RAM
//                                cycle <= cycle + 1;
//                            end                           
//                            3'd2: begin
//                                cycle <= cycle + 1;
//                            end
//                            3'd3: begin
//                                cycle <= cycle + 1;
//                            end  
////------------------------------------------------------- 
////----------------------modified--------------------------                                                                                  
//                            3'd4: begin
//                                control_signals[5] <= 1; // get data from RAM to MBR
//                                cycle <= cycle + 1;
//                            end
//                            3'd5: begin
//                                cycle <= cycle + 1;
//                            end
//                            3'd6: begin
//                                cycle <= cycle + 1;
//                            end 
////---------------------------------------------------------  
//                            3'd7: begin
//                                control_signals[6] <= 1; // get data from MBR to BR
//                                cycle <= cycle + 1;
//                            end
//                            4'd8: begin
//                                control_signals[7] <= 1; // send ACC to ALU
//                                control_signals[14] <= 1; // send BR to ALU
//                                CU_ALU <= SUB; // do calculation
//                                cycle <= cycle + 1;
//                            end
//                            4'd9: begin
//                                // wait for alu
//                                cycle <= cycle + 1;
//                            end
//                            4'd10: begin
//                                control_signals[9] <= 1; // get data from ALU to ACC
//                                stat <= stat + 1;
//                                cycle <= 0;
//                            end
//                        endcase
//                    end
//                    JMPGEZX: begin
//                        if (flags[1]==0) begin// ACC>=0
//                            control_signals[3] <= 1; // get addr from MBR to PC
//                             cycle <= cycle + 1;
//                            stat <= stat + 1;
//                        end
//                        else begin
//                            control_signals[15] <= 1; // PC++
//                            stat <= stat + 1;
//                        end
//                    end

//                    JMPX: begin
//                        control_signals[3] <= 1; // get addr from MBR to PC
//                        stat <= stat + 1;
//                    end
//                    HALT: begin
//                        stat <= stat + 1;
//                    end
//                    MPYX: begin
//                        case (cycle)
//                            3'd0: begin
//                                control_signals[8] <= 1; // get addr from MBR to MAR 
//                                cycle <= cycle + 1;
//                            end
// //------------------------modified-----------------------                             
//                            3'd1: begin
//                                control_signals[0] <= 1; // notify RAM
//                                cycle <= cycle + 1;
//                            end                           
//                            3'd2: begin
//                                cycle <= cycle + 1;
//                            end
//                            3'd3: begin
//                                cycle <= cycle + 1;
//                            end  
////------------------------------------------------------- 
////----------------------modified--------------------------                                                                                  
//                            3'd4: begin
//                                control_signals[5] <= 1; // get data from RAM to MBR
//                                cycle <= cycle + 1;
//                            end
////---------------------------------------------------------  
//                            3'd5: begin
//                                control_signals[6] <= 1; // get data from MBR to BR
//                                cycle <= cycle + 1;
//                            end
//                            4'd6: begin
//                                control_signals[7] <= 1; // send ACC to ALU
//                                control_signals[14] <= 1; // send BR to ALU
//                                CU_ALU <= MPY; // do calculation
//                                cycle <= cycle + 1;
//                            end
//                            4'd7: begin
//                                // wait for alu
//                                cycle <= cycle + 1;
//                            end
//                            4'd8: begin
//                                control_signals[9] <= 1; // get data from ALU to ACC
//                                stat <= stat + 1;
//                            end
//                        endcase
//                    end
//                    STOREMR: begin
//                        case (cycle)
//                            3'd0: begin
//                                control_signals[8] <= 1; // get addr from MBR to MAR 
//                                cycle <= cycle + 1;
//                            end
//                            3'd1: begin
//                                control_signals[13] <= 1; // get data from MR to MBR
//                                cycle <= cycle + 1;
//                            end
//                            3'd2: begin
//                                control_signals[0] <= 1; // refreash RAM
//                                control_signals[12] <= 1; // get data from MBR to RAM
//                                cycle <= cycle + 1;
//                            end
//                            3'd3: begin
//                                cycle <= cycle + 1;
//                            end
//                            3'd4: begin
                                
//                                stat <= stat + 1;
//                            end                              
//                        endcase
//                    end
//                    ANDX: begin
//                        case (cycle)
//                            3'd0: begin
//                                control_signals[8] <= 1; // get addr from MBR to MAR 
//                                cycle <= cycle + 1;
//                            end
//                            3'd1: begin
//                                control_signals[0] <= 1; // refreash RAM
//                                cycle <= cycle + 1;
//                            end
//                            3'd2: begin
//                                cycle <= cycle + 1;
//                            end
//                            3'd3: begin
//                                cycle <= cycle + 1;
//                            end                                                         
//                            3'd4: begin
//                                control_signals[5] <= 1; // get data from ROM to MBR
//                                cycle <= cycle + 1;
//                            end
//                            3'd5: begin
//                                control_signals[6] <= 1; // get data from MBR to BR
//                                cycle <= cycle + 1;
//                            end
//                            3'd6: begin
//                                control_signals[7] <= 1; // send ACC to ALU
//                                control_signals[14] <= 1; // send BR to ALU
//                                CU_ALU <= AND; // do calculation
//                                cycle <= cycle + 1;
//                            end
//                            3'd7: begin
//                                // wait for alu
//                                cycle <= cycle + 1;
//                            end
//                            4'd8: begin
//                                control_signals[9] <= 1; // get data from ALU to ACC
//                                stat <= stat + 1;
//                            end
//                        endcase
//                    end
//                    ORX: begin
//                        case (cycle)
//                            3'd0: begin
//                                control_signals[8] <= 1; // get addr from MBR to MAR 
//                                cycle <= cycle + 1;
//                            end
//                            3'd1: begin
//                                control_signals[0] <= 1; // notify RAM
//                                cycle <= cycle + 1;
//                            end
//                            3'd2: begin
//                                cycle <= cycle + 1;
//                            end
//                            3'd3: begin
//                                cycle <= cycle + 1;
//                            end                             
//                            3'd4: begin
//                                control_signals[5] <= 1; // get data from ROM to MBR
//                                cycle <= cycle + 1;
//                            end
//                            3'd5: begin
//                                control_signals[6] <= 1; // get data from MBR to BR
//                                cycle <= cycle + 1;
//                            end
//                            3'd6: begin
//                                control_signals[7] <= 1; // send ACC to ALU
//                                control_signals[14] <= 1; // send BR to ALU
//                                CU_ALU <= OR; // do calculation
//                                cycle <= cycle + 1;
//                            end
//                            3'd7: begin
//                                // wait for alu
//                                cycle <= cycle + 1;
//                            end
//                            4'd8: begin
//                                control_signals[9] <= 1; // get data from ALU to ACC
//                                stat <= stat + 1;
//                            end
//                        endcase
//                    end
//                    NOTX: begin
//                        case (cycle)
//                            3'd0: begin
//                                control_signals[8] <= 1; // get addr from MBR to MAR 
//                                cycle <= cycle + 1;
//                            end
//                            3'd1: begin
//                                control_signals[0] <= 1; // notify RAM
//                                cycle <= cycle + 1;
//                            end
//                            3'd2: begin
//                                cycle <= cycle + 1;
//                            end
//                            3'd3: begin
//                                cycle <= cycle + 1;
//                            end                             
//                            3'd4: begin
//                                control_signals[5] <= 1; // get data from ROM to MBR
//                                cycle <= cycle + 1;
//                            end
//                            3'd5: begin
//                                control_signals[6] <= 1; // get data from MBR to BR
//                                cycle <= cycle + 1;
//                            end
//                            3'd6: begin
//                                control_signals[14] <= 1; // send BR to ALU
//                                CU_ALU <= NOT; // do calculation
//                                cycle <= cycle + 1;
//                            end
//                            3'd7: begin
//                                // wait for alu
//                                cycle <= cycle + 1;
//                            end
//                            4'd8: begin
//                                control_signals[9] <= 1; // get data from ALU to ACC
//                                stat <= stat + 1;
//                            end
//                        endcase
//                    end
//                    SHIFTR: begin
//                        case (cycle)
//                            3'd0: begin
//                                control_signals[8] <= 1; // get addr from MBR to MAR 
//                                cycle <= cycle + 1;
//                            end
//                            3'd1: begin
//                                control_signals[0] <= 1; // notify RAM
//                                cycle <= cycle + 1;
//                            end
//                            3'd2: begin
//                                cycle <= cycle + 1;
//                            end
//                            3'd3: begin
//                                cycle <= cycle + 1;
//                            end                             
//                            3'd4: begin
//                                control_signals[5] <= 1; // get data from ROM to MBR
//                                cycle <= cycle + 1;
//                            end
//                            3'd5: begin
//                                control_signals[6] <= 1; // get data from MBR to BR
//                                cycle <= cycle + 1;
//                            end
//                            3'd6: begin
//                                control_signals[14] <= 1; // send BR to ALU
//                                CU_ALU <= SRR; // do calculation
//                                cycle <= cycle + 1;
//                            end
//                            3'd7: begin
//                                // wait for alu
//                                cycle <= cycle + 1;
//                            end
//                            4'd8: begin
//                                control_signals[9] <= 1; // get data from ALU to ACC
//                                stat <= stat + 1;
//                            end
//                        endcase
//                    end
//                    SHIFTL: begin
//                        case (cycle)
//                            3'd0: begin
//                                control_signals[8] <= 1; // get addr from MBR to MAR 
//                                cycle <= cycle + 1;
//                            end
//                            3'd1: begin
//                                control_signals[0] <= 1; // notify RAM
//                                cycle <= cycle + 1;
//                            end
//                            3'd2: begin
//                                cycle <= cycle + 1;
//                            end
//                            3'd3: begin
//                                cycle <= cycle + 1;
//                            end                             
//                            3'd4: begin
//                                control_signals[5] <= 1; // get data from ROM to MBR
//                                cycle <= cycle + 1;
//                            end
//                            3'd5: begin
//                                control_signals[6] <= 1; // get data from MBR to BR
//                                cycle <= cycle + 1;
//                            end
//                            3'd6: begin
//                                control_signals[14] <= 1; // send BR to ALU
//                                CU_ALU <= SRL; // do calculation
//                                cycle <= cycle + 1;
//                            end
//                            3'd7: begin
//                                // wait for alu
//                                cycle <= cycle + 1;
//                            end
//                            4'd8: begin
//                                control_signals[9] <= 1; // get data from ALU to ACC
//                                stat <= stat + 1;
//                            end
//                        endcase
//                    end
//                    default: begin
                        
//                    end
//                endcase
//            end

//            4'd8: begin
//                opcode <= 0;
//                cycle <= 0;
//                stat <= 0;
//            end
//        endcase

end

endmodule // CU