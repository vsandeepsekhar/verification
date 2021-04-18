//Reference : https://verificationacademy.com/forums/systemverilog/random-associative-array
module top;
  typedef enum bit[1:0] {A,B,C,D} t_e;
  
  class assoc;
    rand bit [7:0] aa[t_e] = '{default:0};
    
    constraint c {foreach (aa[ii]) aa[ii] < 10; };
  endclass
  
  assoc h;
  initial begin
    h = new();
    void'(h.randomize());
    $display("%p",h.aa);
    h.aa[A] = 89;//VV Imp point to note that an associative array does not allocate memory until it is initialized
    void'(h.randomize());
    $display("%p",h.aa); //you should see some random number < 10
  end
endmodule
