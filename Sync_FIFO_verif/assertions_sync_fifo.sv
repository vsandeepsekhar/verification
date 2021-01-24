// Code your testbench here
// or browse Examples

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
  
  //Task to fill the FIFO
  task fill_fifo;
    int i;
    reset = 1'b0;
    for(i=0;i<100;i++) begin
      @(posedge clk);
      write = 1'b1;
      data_in = i[31:0];
    end
  endtask
  
  initial begin 
    clk = 0;
    reset = 1'b1;
    write = 1'b0;
    read = 1'b0;
    data_in = 16'h0000;
    #100ns;
    fill_fifo();
    #5000ns;
    $finish;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1,tb);
    $monitor("FIFO Counter = %0d, FIFO Full = %0d",fifo_counter,fifo_full);
  end
  
  //Black Box Assertions
  //Assertions
  // When FIFO is reset, the FIFO empty flag should be set and the full flag should be reset
  property p1;
    @(posedge clk) if(reset) fifo_empty && (!fifo_full);
  endproperty
  
  assert property(p1);
  cover property(p1);
  
  //IF the FIFO is full, and there is a write operation  without a simultaneous read operation, 
    // The full flag should not change
  property p2;
    @(posedge clk) disable iff(reset) (fifo_full && write && ~read) |=> fifo_full;
  endproperty
  
  assert property(p2);
  cover property(p2);
    
  // if teh FIFO is full, and there is a write operation without a simultaneous read operation, the write pointer should not change  
  property p3;
    @(posedge clk) disable iff(reset) 
    (fifo_full && write && ~read) |=> $stable(wr_ptr); 
  endproperty
    
  assert property(p3);
  cover property(p3);  
    
  //White Box Assertions
  //if fifo_counter is greater then 31 then the FIFO is full 
  property p4;
    @(posedge clk) disable iff(reset)
    (fifo_counter > 31) |=> fifo_full;
  endproperty
    
  assert property(p4);
  cover property(p4);  
    
  //if fifo_counter is less than 32, the FIFO is not full 
  property p5;
    @(posedge clk) disable iff(reset)
    (fifo_counter < 32) |=> ~fifo_full;
  endproperty
    
  assert property(p5);
  cover property(p5);
      
  //if the word counter is 31 and there is a write operation without simultaneous read
  //the FIFO should go Full
    
  property p6;
    @(posedge clk) disable iff(reset)
    ((fifo_counter == 31) && write && ~read) |=> fifo_full;
  endproperty
    
  assert property(p6);
  cover property(p6);  
    
    
    
     
endmodule 
