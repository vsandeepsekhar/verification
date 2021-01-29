`ifndef RD_IF_SV
`define RD_IF_SV

  interface rd_if(input bit clk);
    wire [7:0] data_in; 
    wire [7:0] data_out; //out data
    wire wr_en; //Write Enable 
    wire [7:0] wr_addr; //Write Address 
    wire rd_en;
    wire [7:0] rd_addr;

    //include a master clocking block
    clocking master_cb @(posedge clk);
      output data_out;
      output wr_en;
      output wr_addr;
      output rd_addr;
      output rd_en;
      input data_in;
    endclocking: master_cb
    
    //include a Monitor clocking block
    clocking slave_cb @(posedge clk);
      input data_out;
      input  wr_en;
      input wr_addr;
      input  rd_addr;
      input rd_en;
      input data_in;
    endclocking: monitor_cb
    
    
    modport master(clocking master_cb);
    modport passive(clocking monitor_cb);
    //Include slave BFM if you need any responder
    
    
    
  endinterface
`endif
