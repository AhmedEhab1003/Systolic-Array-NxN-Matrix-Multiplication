module systolic_array_tb;
    // Parameters
    parameter DATA_WIDTH = 8;
    parameter ARRAY_SIZE = 3;  // For a 3x3 systolic array
    parameter ACCUMULATOR_WIDTH = 2*DATA_WIDTH + $clog2(ARRAY_SIZE);  
    parameter MAX_VALUE = 9;  // Maximum value for random generation 
    parameter MIN_VALUE = 0;  // Minimum value for random generation
    
    // Testbench signals
    reg clk;
    reg rst_n;
    reg enable;
    reg [DATA_WIDTH-1:0] a_inputs [0:ARRAY_SIZE-1];
    reg [DATA_WIDTH-1:0] b_inputs [0:ARRAY_SIZE-1];
    wire [ACCUMULATOR_WIDTH-1:0] c_outputs [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    wire computation_done;
    
    // Storage for input and expected output matrices
    reg [DATA_WIDTH-1:0] matrix_a [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg [DATA_WIDTH-1:0] matrix_b [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    reg [ACCUMULATOR_WIDTH-1:0] expected_c [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];
    
    // Instantiate the systolic array
    systolic_array #(
        .DATA_WIDTH(DATA_WIDTH),
        .ARRAY_SIZE(ARRAY_SIZE),
        .ACCUMULATOR_WIDTH(ACCUMULATOR_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .a_inputs(a_inputs),
        .b_inputs(b_inputs),
        .c_outputs(c_outputs),
        .computation_done(computation_done)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock
    end
    
    // Function to generate random matrices with values 1-9
    function void generate_random_matrices();
        for (int i = 0; i < ARRAY_SIZE; i++) begin
            for (int j = 0; j < ARRAY_SIZE; j++) begin
                matrix_a[i][j] = $urandom_range(MIN_VALUE, MAX_VALUE);
                matrix_b[i][j] = $urandom_range(MIN_VALUE, MAX_VALUE);
            end
        end
    endfunction
    
    // Function to compute expected results (standard matrix multiplication)
    function void compute_expected_results();
        for (int i = 0; i < ARRAY_SIZE; i++) begin
            for (int j = 0; j < ARRAY_SIZE; j++) begin
                expected_c[i][j] = 0;
                for (int k = 0; k < ARRAY_SIZE; k++) begin
                    expected_c[i][j] = expected_c[i][j] + (matrix_a[i][k] * matrix_b[k][j]);
                end
            end
        end
    endfunction
    
    // Tasks to display matrices with different bit widths
    task display_input_matrix(input string name, input [DATA_WIDTH-1:0] matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1]);
        $display("%s (%0dx%0d):", name, ARRAY_SIZE, ARRAY_SIZE);
        for (int i = 0; i < ARRAY_SIZE; i++) begin
            $write("  ");
            for (int j = 0; j < ARRAY_SIZE; j++) begin
                $write("%0d ", matrix[i][j]);
            end
            $display("");
        end
    endtask
    
    task display_output_matrix(input string name, input [ACCUMULATOR_WIDTH-1:0] matrix [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1]);
        $display("%s (%0dx%0d):", name, ARRAY_SIZE, ARRAY_SIZE);
        for (int i = 0; i < ARRAY_SIZE; i++) begin
            $write("  ");
            for (int j = 0; j < ARRAY_SIZE; j++) begin
                $write("%0d ", matrix[i][j]);
            end
            $display("");
        end
    endtask
    
    // Task to initialize the system
    task initialize();
        rst_n = 0;
        enable = 0;
        
        // Initialize inputs to 0
        for (int i = 0; i < ARRAY_SIZE; i++) begin
            a_inputs[i] = 0;
            b_inputs[i] = 0;
        end
        
        // Release reset after 20ns
        #20;
        rst_n = 1;
        #10;
        enable = 1;
    endtask
    
    // Task to feed matrices into the systolic array
    task feed_matrices();
        // We feed the matrices in a skewed pattern
        for (int cycle = 0; cycle < 2*ARRAY_SIZE-1+1; cycle++) begin
            for (int i = 0; i < ARRAY_SIZE; i++) begin
                // For matrix A (feed from left side)
                if (cycle-i >= 0 && cycle-i < ARRAY_SIZE) begin
                    a_inputs[i] = matrix_a[i][cycle-i];
                end else begin
                    a_inputs[i] = 0;
                end
                
                // For matrix B (feed from top side)
                if (cycle-i >= 0 && cycle-i < ARRAY_SIZE) begin
                    b_inputs[i] = matrix_b[cycle-i][i];
                end else begin
                    b_inputs[i] = 0;
                end
            end
            #10; // Wait for one clock cycle
        end
    endtask
    
    // Task to verify results
    task verify_results();
        int errors = 0;
        
        $display("Verifying results...");
        for (int i = 0; i < ARRAY_SIZE; i++) begin
            for (int j = 0; j < ARRAY_SIZE; j++) begin
                if (c_outputs[i][j] !== expected_c[i][j]) begin
                    $display("Error at position [%0d][%0d]: Expected %0d, Got %0d", 
                            i, j, expected_c[i][j], c_outputs[i][j]);
                    errors++;
                end
            end
        end
        
        if (errors == 0) begin
            $display("Verification PASSED! All results match expected values.");
        end else begin
            $display("Verification FAILED! %0d errors found.", errors);
        end
    endtask
    
    // Main test sequence
    initial begin
        // Print parameter information
        $display("====================== TEST CONFIGURATION ======================");
        $display("DATA_WIDTH: %0d bits", DATA_WIDTH);
        $display("ARRAY_SIZE: %0d x %0d", ARRAY_SIZE, ARRAY_SIZE);
        $display("ACCUMULATOR_WIDTH: %0d bits", ACCUMULATOR_WIDTH);
        $display("Random values range: %0d to %0d", MIN_VALUE, MAX_VALUE);
        $display("==============================================================");
        
        // Generate random matrices
        generate_random_matrices();
        
        // Compute expected results
        compute_expected_results();
        
        // Display input matrices
        display_input_matrix("Matrix A", matrix_a);
        display_input_matrix("Matrix B", matrix_b);
        display_output_matrix("Expected Result (A×B)", expected_c);
        
        // Initialize the system
        initialize();
        
        // Feed matrices into the systolic array
        feed_matrices();
        
        // Wait for computation to complete
        wait(computation_done);
        #20;
        
        // Display and verify results
        display_output_matrix("Actual Result", c_outputs);
        verify_results();
        
        // End simulation
        #10;
        $finish;
    end
    
    // Monitor for status
    initial begin
        $monitor("Time=%0t, computation_done=%b", $time, computation_done);
    end
endmodule