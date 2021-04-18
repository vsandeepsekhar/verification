module tb;
  class dyn_assoc;
    int d_a[string][];
    
  endclass
  dyn_assoc dync_c;
  initial begin
    dync_c = new();
    
    dync_c.d_a["orange"] = new[2];
    dync_c.d_a["orange"] = {5,6};
    
    foreach(dync_c.d_a[item])
      foreach(dync_c.d_a[item][ii])
        $display("dync_c.d_a[%s][%0d] = %0d",item,ii,dync_c.d_a[item][ii]);
  end
endmodule 
