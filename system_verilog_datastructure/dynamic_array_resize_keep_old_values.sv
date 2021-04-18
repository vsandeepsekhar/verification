//Dynamic array resizing keeping old values "AS IS"
//Reference from Many websites
//https://verificationguide.com/systemverilog/systemverilog-dynamic-array/
//https://verificationacademy.com/forums/systemverilog/random-associative-array

module top;
  class dynamic;
    rand bit [7:0] aa[];
    constraint c {foreach(aa[ii]) aa[ii] < 10;};
  endclass
  
  dynamic h;
 initial begin
   h = new();
   h.aa = new[2];
   void'(h.randomize());
   $display("First Randmization!");
   $display("%p",h.aa);
   h.aa = new[4](h.aa);//keeps old randomized values and then h.aa[2] and h.aa[3] with default values
   $display("%p",h.aa);
 end
                  
     
endmodule : top 
