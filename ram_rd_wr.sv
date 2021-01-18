`ifdef RAM_RW_SV
`define RAM_RW_SV
/****
* Idea is to have a sequence item which has the READ/WRITE Operation 
*/
import uvm_pkg::*;

class ram_rd_wr extends uvm_sequence_item;

  typedef enum {READ,WRITE} kind_e;
  rand bit [7:0] addr;
  rand bit [7:0] data;
  rand bit wr_en;
  rand bit rd_en;
  rand kind_e operation;

  //register with factory for dynamic creation
  `uvm_object_utils(ram_rd_wr);

  function new(string name="ram_rd_wr");
    super.new(name);
  endfunction

  function string convert2string();
    return $psprintf("kind=%s addr=%0h data=%0h",operation,addr,data);
  endfunction

endclass
`endif
