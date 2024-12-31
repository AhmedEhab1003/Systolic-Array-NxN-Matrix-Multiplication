//##################################################################################################################################################                                                                   Systolic Array 3X3                                                             #                                                         Eng.Ahmed Ehab and Eng.Youssef Nasser                                                    ###################################################################################################################################################*
//                                                                Processing Element Module                                                       //
//##################################################################################################################################################

module PE #(parameter data_width=8)
  (
    input  logic                      i_clk , i_rst,
    input  logic [data_width-1:0]     i_Left , i_Top,
    output logic [data_width-1:0]     o_right, o_down,
    output logic [(2*data_width):0]   o_Cell_Value
  );

  logic [(2*data_width)-1:0] mul;

  always @(posedge i_clk or posedge i_rst) 
    begin
      if(i_rst)
        begin
          o_right         <= 0;
          o_down          <= 0;
          o_Cell_Value    <= 0;
        end
      else 
        begin
          o_Cell_Value <= o_Cell_Value + mul;  //addition and storing 
          o_right      <= i_Left;              // shift new value
          o_down       <= i_Top;               // shift new value
        end

    end

  assign mul = i_Left * i_Top;           // mulitplication 

endmodule