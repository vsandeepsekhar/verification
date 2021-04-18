module tb;
  class dyn_assoc;
    int d_a[][string];
    
  endclass
  dyn_assoc dync_c;
  initial begin
    dync_c = new();
    
    dync_c.d_a = new[2];
    
    dync_c.d_a[0] = '{"boston":5, "portland":6};
    dync_c.d_a[1] = '{"sfo":7, "la": 8};
    
    foreach(dync_c.d_a[ii])
      foreach(dync_c.d_a[ii][item])
        $display("dync_c.d_a[%0d][%s] = %0d",ii,item,dync_c.d_a[ii][item]);
    
  end
endmodule 
