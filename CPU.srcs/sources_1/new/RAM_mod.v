`timescale 1ns / 1ps

module RAM_mod(
    input clk,
    input rst,
    input [15:0]control_signals,
    //C0,               // MAR to RAM
  // input C12,              // MBR to RAM
    input [7:0] mar_ram, //MAR给RAM的地址
    input [15:0] mbr_ram, //MBR给RAM的数据
    output [15:0] ram_out
);
wire [15:0]douta;
wire [15:0]dina;
reg [7:0]addra;
reg [0:0]wea;


assign dina=mbr_ram;
//assign addra=mar_ram;
assign ram_out=douta;

RAM my_RAM (
  .clka(clk),    // input wire clka
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [7 : 0] addra
  .dina(dina),    // input wire [15 : 0] dina
  .douta(douta)  // output wire [15 : 0] douta
);


    always @(posedge clk ) begin  
//                 addra<=mar_ram;     
                    wea<=1'b0; 
            // sum 0 to 100
//            ram[8'h00] <= 16'h02A0; // LOAD A0
//            ram[8'h01] <= 16'h01A4; // STORE A4
//            ram[8'h02] <= 16'h02A2; // LOAD A2
//            ram[8'h03] <= 16'h01A3; // STORE A3
//            ram[8'h04] <= 16'h02A4; // LOOP:LOAD A4
//            ram[8'h05] <= 16'h03A3; // ADD A3
//            ram[8'h06] <= 16'h01A4; // STORE A4
//            ram[8'h07] <= 16'h02A3; // LOAD A3
//            ram[8'h08] <= 16'h04A1; // SUB A1
//            ram[8'h09] <= 16'h01A3; // STORE A3
//            ram[8'h0A] <= 16'h0504; // JMPGEZ LOOP
//            ram[8'h0B] <= 16'h02A4; // HALT
//            //A4=sum
//            ram[8'hA0] <= 16'h0000;
//            ram[8'hA1] <= 16'h0001;
//            ram[8'hA2] <= 16'h0064;
            
            /*
            
            // 6 * 5
            ram[8'h00] = 16'h02A0; // LOAD 6 from A0
            ram[8'h01] = 16'h08A1; // MPY 5 from A1
            ram[8'h02] = 16'h01A4; // STORE 30 to A4
            ram[8'h03] = 16'h09A5; // STOREMR 30 to A5
            
            // -6 * 5
            ram[8'h04] = 16'h02A2; // LOAD -6 from A2
            ram[8'h05] = 16'h08A1; // MPY 5 from A1
            ram[8'h06] = 16'h01A6; // STORE -30 to A6(ffe2)
            ram[8'h07] = 16'h09A7; // STOREMR -30 to A7(ffe2)
            // -6 * -5
            ram[8'h08] = 16'h02A2; // LOAD -6 from A2
            ram[8'h09] = 16'h08A3; // MPY -5 from A3
            ram[8'h0A] = 16'h01A8; // STORE 30 to A8
            ram[8'h0B] = 16'h09A9; // STOREMR 30 to A9
            ram[8'h0C] = 16'h02A4; // HALT

            ram[8'hA0] = 16'h0006;
            ram[8'hA1] = 16'h0005;
            ram[8'hA2] = 16'hFFFA; // -6
            ram[8'hA3] = 16'hFFFB; // -5
            */
//        end
//        else begin
//           if (control_signals[5])  
//            ram_out<=douta;
            if (control_signals[11]) 
            begin
                addra<=mar_ram;  
                if (control_signals[12])
                    wea<=1'b1;
            end
        end

endmodule // RAM_mod