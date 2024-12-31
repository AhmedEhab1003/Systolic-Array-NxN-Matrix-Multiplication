# Systolic Array Design

This repository contains the Verilog implementation of a systolic array, a specialized parallel computing architecture optimized for matrix operations. The design consists of **Processing Elements (PEs)** connected in a grid structure.

## Run on EDA Playground
 [EDA Playground]edaplayground.com/x/rvDL

## Overview

### Processing Element (PE)
The `PE` module performs:
- Multiplication of two inputs.
- Accumulation of multiplication results.
- Passing inputs to the next PE in the array.

#### Parameters:
- `data_width` (default: 8): Defines the bit width of the data processed.

#### Ports:
| Port Name       | Direction | Width             | Description                              |
|-----------------|-----------|-------------------|------------------------------------------|
| `i_clk`         | Input     | 1                 | Clock signal.                            |
| `i_rst`         | Input     | 1                 | Reset signal.                            |
| `i_Left`        | Input     | `data_width`      | Input from the left.                     |
| `i_Top`         | Input     | `data_width`      | Input from the top.                      |
| `o_right`       | Output    | `data_width`      | Output to the right.                     |
| `o_down`        | Output    | `data_width`      | Output to the bottom.                    |
| `o_Cell_Value`  | Output    | `(2 * data_width)`| Accumulated cell value.                  |

### Systolic Array
The `Systolic_Array` module integrates multiple `PE` instances to form a 3x3 systolic array.

#### Parameters:
- `data_width` (default: 8): Defines the bit width of the data processed.

#### Ports:
| Port Name       | Direction | Width             | Description                              |
|-----------------|-----------|-------------------|------------------------------------------|
| `i_clk`         | Input     | 1                 | Clock signal.                            |
| `i_rst`         | Input     | 1                 | Reset signal.                            |
| `i_Cell_A1`     | Input     | `data_width`      | Input to PE1 from the left.              |
| `i_Cell_A4`     | Input     | `data_width`      | Input to PE4 from the left.              |
| `i_Cell_A7`     | Input     | `data_width`      | Input to PE7 from the left.              |
| `i_Cell_B1`     | Input     | `data_width`      | Input to PE1 from the top.               |
| `i_Cell_B2`     | Input     | `data_width`      | Input to PE2 from the top.               |
| `i_Cell_B3`     | Input     | `data_width`      | Input to PE3 from the top.               |
| `o_cell_1`-`o_cell_9` | Output | `(2 * data_width)`| Outputs from the 9 PEs in the array.     |

### Connections
The 3x3 array connects PEs as follows:
- Inputs are fed to the first row and column of PEs.
- Outputs from each PE are passed to the next PE in the row and column.

## How to Use

1. Instantiate the `Systolic_Array` module in your testbench or top-level design.
2. Provide inputs (`i_Cell_A*` and `i_Cell_B*`) for matrix multiplication.
3. Simulate the design using your preferred simulator (e.g., ModelSim, Vivado, etc.).
4. Observe the outputs (`o_cell_*`) for results.

## Example Usage
```verilog
Systolic_Array #(8) uut (
  .i_clk(clk),
  .i_rst(rst),
  .i_Cell_A1(a1), .i_Cell_A4(a4), .i_Cell_A7(a7),
  .i_Cell_B1(b1), .i_Cell_B2(b2), .i_Cell_B3(b3),
  .o_cell_1(o1), .o_cell_2(o2), .o_cell_3(o3),
  .o_cell_4(o4), .o_cell_5(o5), .o_cell_6(o6),
  .o_cell_7(o7), .o_cell_8(o8), .o_cell_9(o9)
);
```

## Applications
This systolic array can be used in:
- Matrix multiplication.
- Signal processing.
- Machine learning hardware accelerators.

## License
This project is open-source and available under the MIT License.
