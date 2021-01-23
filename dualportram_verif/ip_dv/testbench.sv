//------------------------------------------
//---------------Top level Test Module
// Includes all env component and sequences files

import environment_pkgs::*;

//Top Level module test instantiation just a physical RAM rd/wr interface
////Include RAM DUT
`timescale 1ns/1ps

module test;

  logic clock;
  logic [7:0] addr;

  dual_port_ram dut(*);//DUT Instantiated :TODO to include all the interface sigs 
   


  initial begin 
    clock = 0;
  end

  //Generate a clock

  always begin
    #10 clock = ~clock;
  end

  //Instantiate the physical interface
  rd_if rd_if(.clock(clock));

  initial begin
	  uvm_config_dn#(virtual ram_rd)::set( null, "uvm_test_top", "vif", rd_if);
          //for now make it work? :TODO or else add test name with +UVM_TEST
		  //on command line
	  run_test("ram_basic_rd_wr_test");
  end

endmodule 


