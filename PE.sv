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

endmodule