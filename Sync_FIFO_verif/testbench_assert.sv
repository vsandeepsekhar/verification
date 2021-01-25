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
