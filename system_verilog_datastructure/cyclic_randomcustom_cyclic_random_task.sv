/*
  The function generate randc is a custom cyclic random task called from testbench
  This can be used in callbacks.
*/

class randc_var;
  rand bit[3:0] rand_var;  
endclass

class randomc_eg;
  randc_var var_c;
  int list[$];
  int i=0;
  bit match;
  
  task generate_randc();
    var_c = new();
    while(list.size() <= 8) begin 
      assert(var_c.randomize());
          
      for(i = 0; i<= list.size() && (match==0) && (list.size() <= 8); i++) begin 
        if(var_c.rand_var == list[i]) begin 
          match = 1;
          $display("** Got a duplicate entry ******");
          $display("Queue is %p",list);
          $display("****Entering another iteration*************");
          break;
        end
        else begin
          match = 0;
        end
      end
      if(match == 0) begin
        $display("Pushing new elements in queue");
       list.push_back(var_c.rand_var);
      end
      else begin 
        match =0;
      end
      
    end
  endtask
endclass

module tb;
  randomc_eg rand_g;
  
  initial begin
    rand_g = new();
    rand_g.generate_randc();
  end
  
endmodule  
