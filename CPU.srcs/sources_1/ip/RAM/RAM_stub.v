// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Fri Jun  3 19:22:42 2022
// Host        : DESKTOP-E321F6G running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/Users/Wangby/Desktop/CPU_with_TWO_ip_cores_with_button_v5/CPU_with_TWO_ip_cores_with_button_v5/CPU_with_ip_core_with_button_v5/CPU.srcs/sources_1/ip/RAM/RAM_stub.v
// Design      : RAM
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.1" *)
module RAM(clka, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[7:0],dina[15:0],douta[15:0]" */;
  input clka;
  input [0:0]wea;
  input [7:0]addra;
  input [15:0]dina;
  output [15:0]douta;
endmodule