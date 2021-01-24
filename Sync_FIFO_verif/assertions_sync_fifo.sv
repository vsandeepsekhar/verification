
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
  
  initial begin 
    clk = 0;
    reset = 1'b1;
    write = 1'b0;
    read = 1'b0;
    data_in = 16'h0000;
    #100ns;
    $finish;
  end
  
  //Black Box Assertions
  //Assertions
  // When FIFO is reset, the FIFO empty flag should be set and the full flag should be reset
  property p1;
    @(posedge clk) if(reset) fifo_empty && (!fifo_full);
  endproperty
  
  assert property(p1);
  
  //IF the FIFO is full, and there is a write operation  without a simultaneous read operation, 
    // The full flag should not change
  property p2;
    @(posedge clk) disable iff(reset) (fifo_full && write && ~read) |=> fifo_full;
  endproperty
  
  assert property(p2);
    
  // if teh FIFO is full, and there is a write operation without a simultaneous read operation, the write pointer should not change  
  property p3;
    @(posedge clk) disable iff(reset) 
    
    (fifo_full && write && ~read) |=> $stable(wr_ptr); 
  endproperty
    
  assert property(p3);
    
  //White Box Assertions
  
  
endmodule 
