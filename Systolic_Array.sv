

// ##################################################################################################################################################
//                                                             Systolic Array Module                                                               //
//##################################################################################################################################################

module Systolic_Array #(parameter data_width=8) (

  input  logic                      i_clk     , i_rst,
  input  logic [data_width-1:0]     i_Cell_A1 , i_Cell_A4,i_Cell_A7,
  input  logic [data_width-1:0]     i_Cell_B1 , i_Cell_B2,i_Cell_B3,
  output logic [(data_width*2):0]   o_cell_1  , o_cell_2 , o_cell_3 , o_cell_4 , o_cell_5, o_cell_6 , o_cell_7, o_cell_8, o_cell_9

);

  logic [data_width-1:0] A12 , A23 , A45 , A56 , A78 , A89;
  logic [data_width-1:0] B14 , B47 , B25 , B58 , B36 , B69;

  //referabce 
  //PE ports(i_clk,i_rst,i_Left,i_Top,o_right,o_down,o_Cell_Value);

  PE PE1(i_clk,i_rst,i_Cell_A1,i_Cell_B1,A12,B14,o_cell_1);
  PE PE2(i_clk,i_rst,A12,i_Cell_B2,A23,B25,o_cell_2);
  PE PE3(i_clk,i_rst,A23,i_Cell_B3,,B36,o_cell_3);
  PE PE4(i_clk,i_rst,i_Cell_A4,B14,A45,B47,o_cell_4);
  PE PE5(i_clk,i_rst,A45,B25,A56,B58,o_cell_5);
  PE PE6(i_clk,i_rst,A56,B36,,B69,o_cell_6);
  PE PE7(i_clk,i_rst,i_Cell_A7,B47,A78,,o_cell_7);
  PE PE8(i_clk,i_rst,A78,B58,A89,,o_cell_8);
  PE PE9(i_clk,i_rst,A89,B69,,,o_cell_9);

endmodule