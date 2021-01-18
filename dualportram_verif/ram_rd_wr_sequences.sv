//A few flavors of RAM READ and WRITE sequences

`ifdef RAM_RD_WR_SEQUENCES_SV
`define RAM_RD_WR_SEQUENCES_SV

class ram_rd_wr_sequences extends uvm_sequence#(ram_rd_wr);
  `uvm_object_utils(ram_rd_wr_sequences)

  function new(string name ="")
    super.new(name);
  endfunction

  //Main body method that gets executed once sequence is started
  task body();
    ram_rd_wr rw_trans;
    //Create 10 random Read and write transaction and send to driver
    repeat(10) begin
      rw_trans = ram_rd_wr::type_id::create(.name("rw_trans"),.contxt(get_full_name()));
      start_item(rw_trans);
      assert(rw_trans.randomize());
      finish_item(rw_trans);
    end
  endtask

endclass

`endif
