/*
* READ Interface
*/

`ifndef RD_IF_SV
`define RD_IF_SV

  interface rd_if(input bit clk);
    wire [7:0] data_out;
    wire rd_en;
    wire [7:0] rd_addr;

    //include a master clocking block
  endinterface
`endif
