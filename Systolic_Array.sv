module systolic_array #(
    parameter DATA_WIDTH = 8,              // Width of data elements
    parameter ARRAY_SIZE = 4,              // Size of the systolic array (ARRAY_SIZE x ARRAY_SIZE)
    parameter ACCUMULATOR_WIDTH = 24       // Width of accumulator registers
) (
    input  wire                            clk,
    input  wire                            rst_n,
    input  wire                            enable,
    input  wire [DATA_WIDTH-1:0]           a_inputs [0:ARRAY_SIZE-1], // Input data from matrix A
    input  wire [DATA_WIDTH-1:0]           b_inputs [0:ARRAY_SIZE-1], // Input data from matrix B
    output wire [ACCUMULATOR_WIDTH-1:0]    c_outputs [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1], // Result matrix C
    output wire                            computation_done            // Indicates when computation is complete
);

    // Declare connections between PEs
    wire [DATA_WIDTH-1:0] a_connections [0:ARRAY_SIZE-1][0:ARRAY_SIZE];
    wire [DATA_WIDTH-1:0] b_connections [0:ARRAY_SIZE][0:ARRAY_SIZE-1];
    
    // Counter for computation done signal
    reg [$clog2(2*ARRAY_SIZE):0] counter;
    assign computation_done = (counter >= (2*ARRAY_SIZE + 1));
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
        end else if (enable) begin
            if (counter <= (2*ARRAY_SIZE + 1))
                counter <= counter + 1;
        end
    end
    
    // Connect inputs to first row and column
    genvar i, j;
    generate
        for (i = 0; i < ARRAY_SIZE; i = i + 1) begin
            // Connect A inputs to leftmost column of the array
            assign a_connections[i][0] = a_inputs[i];
            
            // Connect B inputs to top row of the array
            assign b_connections[0][i] = b_inputs[i];
        end
    endgenerate
    
    // Generate the 2D array of processing elements
    generate
        for (i = 0; i < ARRAY_SIZE; i = i + 1) begin
            for (j = 0; j < ARRAY_SIZE; j = j + 1) begin
                processing_element #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH)
                ) pe_inst (
                    .clk(clk),
                    .rst_n(rst_n),
                    .enable(enable),
                    .a_in(a_connections[i][j]),
                    .b_in(b_connections[i][j]),
                    .a_out(a_connections[i][j+1]),
                    .b_out(b_connections[i+1][j]),
                    .c_out(c_outputs[i][j])
                );
            end
        end
    endgenerate

endmodule