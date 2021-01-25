
module rr_arbiter_tb();
  
  logic reset;
  logic clk;
  logic[3:0] req;
  logic[3:0] grant;
  
  rr_arbiter r_arb(.*);
  
  property p1;
    @(posedge clk) disable iff(reset) req |=> $onehot(grant);
  endproperty
  
  assert property(p1);
    
  sequence s1;
    req[0] ##[1:4] grant[0];
  endsequence
    
  sequence s2;
    req[1] ##[1:4] grant[1];
  endsequence
    
  sequence s3;
    req[2] ##[1:4] grant[2];
  endsequence
    
  
  sequence s4;
    req[3] ##[1:4] grant[3];
  endsequence
    
  property p2;
    @(posedge clk) disable iff(reset) s1 or s2 or s3 or s4;
  endproperty
  
  
  
endmodule 
