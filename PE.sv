module processing_element #(
    parameter DATA_WIDTH = 8,              // Width of data elements
    parameter ACCUMULATOR_WIDTH = 24       // Width of accumulator registers
) (
    input  wire                         clk,
    input  wire                         rst_n,
    input  wire                         enable,
    input  wire [DATA_WIDTH-1:0]        a_in,   // Input from left
    input  wire [DATA_WIDTH-1:0]        b_in,   // Input from above
    output reg  [DATA_WIDTH-1:0]        a_out,  // Output to right
    output reg  [DATA_WIDTH-1:0]        b_out,  // Output to below
    output wire [ACCUMULATOR_WIDTH-1:0] c_out   // Output result
);

<<<<<<< HEAD
    // Internal accumulator register
    reg [ACCUMULATOR_WIDTH-1:0] accumulator;
    assign c_out = accumulator;
    
    // Registers for data propagation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_out <= 0;
            b_out <= 0;
        end else if (enable) begin
            a_out <= a_in;
            b_out <= b_in;
=======
module PE #(parameter data_width=8) // comment
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
>>>>>>> e7b8732ebaf2e22147239848c1f3c2f2f5025820
        end
    end
    
    // Multiply-accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 0;
        end else if (enable) begin
            // Perform multiply-accumulate operation
            accumulator <= accumulator + (a_in * b_in);
        end
    end

<<<<<<< HEAD
endmodule
=======
  assign mul = i_Left * i_Top;           // mulitplication 

endmodule
>>>>>>> e7b8732ebaf2e22147239848c1f3c2f2f5025820
