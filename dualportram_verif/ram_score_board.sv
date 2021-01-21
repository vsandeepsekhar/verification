`ifndef RAM_SCOREBOARD_SV
`define RAM_SCOREBOARD_SV

`uvm_analysis_imp_decl(_rcvd_data_packet)
`uvm_analysis_imp_decl(_sent_data_packet)

class ram_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(ram_scoreboard);
   
    ram_rd_wr exp_txn_que[$];

    uvm_analysis_imp_rcvd_data_packet #(ram_rd_wr, ram_scoreboard) Rvr2sb_port;
    uvm_analysis_imp_sent_data_packet #(ram_rd_wr, ram_scoreboard) Drv2sb_port;

    function new(string name, uvm_component parent);
      super.new(name, parent);
      Rvr2sb_port = new("Rvr2sb", this);
      Drv2sb_port = new("Drv2sb", this);
    endfunction : new

    virtual function void write_rcvd_data_packet(input ram_rd_wr ram_txn);
      ram_rd_wr exp_pkt;

       if(exp_txn_que.size())
       begin
	 exp_pkt = exp_txn_que.pop_front();

	 if(ram_txn.compare(exp_pkt)) 
	   uvm_report_info(get_type_name(), $psprintf("Sent data and Received data matched"), UVM_LOW);
         else 
           uvm_report_error(get_type_name(), $psprintf("Sent data and Received data Mismatched"), UVM_LOW);
       end
       else begin
	   uvm_report_error(get_type_name(), $psprintf("No more packets are there in the expected queue to compare"), UVM_LOW);
       end
    endfunction

    virtual function void write_sent_data(input ram_rd_wr ram_txn);
      exp_txn_que.push_back(ram_txn);
    endfunction : write_sent_data
    
    virtual function void report();
      uvm_report_info(get_type_name(), $psprintf("Scoreboard Report \n", this.sprintf()), UVM_LOW);
    endfunction: report

endclass : ram_scoreboard


`endif
