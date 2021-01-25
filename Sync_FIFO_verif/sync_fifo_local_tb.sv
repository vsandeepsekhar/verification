// Code your testbench here
// or browse Examples
`timescale 1ns/1ps
`define FIFO_WIDTH 16
`define FIFO_SIZE_BITS 5
`define FIFO_SIZE (1<<`FIFO_SIZE_BITS)

module tb;
  
  logic  reset;
  logic clk;
  logic write;
  logic read;   
  logic [`FIFO_WIDTH-1:0] data_in;
  logic [`FIFO_WIDTH-1:0] data_out;                  
  logic fifo_empty;
  logic fifo_full;      
  logic [`FIFO_SIZE_BITS-1:0] fifo_counter;
  
  sync_fifo s_fifo(.*);
  
  assign wr_ptr = s_fifo.wr_ptr;
  
    
  always #10 clk = ~clk;
  
  `include "driver_tasks.sv"
  `include "testbench_assert.sv"
  
  initial begin 
    initialize_tb();
    repeat(5) @(posedge clk);
    reset = 1'b0;
    fill_fifo();
    //Attempt to write to FIFO while full
    single_write_fifo();
    //Empty the FIFO
    empty_fifo();
    //Attempt to read the FIFO while empty
    single_read_fifo();
    #5000ns;
    $finish;
  end
  
  initial begin
    create_wave_dump();
    $monitor("FIFO Counter = %0d, FIFO Full = %0d",fifo_counter,fifo_full);
    $monitor("FIFO Counter = %0d, FIFO EMPTY = %0d",fifo_counter,fifo_empty);
  end
  
endmodule 
