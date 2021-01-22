//---------------------------------------------
// The file contains the RAM Driver, Sequencer and Monitor

`ifndef ram_driver_seq_mon_svh
`define ram_driver_seq_mon_svh

typedef ram_config;
typedef ram_agent;


//----------------------
//RAM Master  ----------

class ram_master_drv extends uvm_driver(ram_rd_wr);
  `uvm_component_utils(ram_master_drv)
  
   virtual rd_if vif;
   ram_config cfg;
   
   //Important here since this contributes to expected data queue
   uvm_analysis_port #(ram_rd_wr) Drv2sb_port;

   function new(string name,uvm_component parent=null);
     super.new(name,parent);
   endfunction

   //Build Phase
   //Get the virtual interface handle from the agent (parent) or from
   //config_db
   function void build_phase(uvm_phase phase);
     ram_agent agent;
     super.build_phase(phase);
     
     Drv2sb_port = new("Drv2sb", this);

     if($cast(agent, get_parent()) && agent != null) begin
       vif = agent.vif;
     end
     else begin
       if(!uvm_config_db#(virtual rd_if)::get(this,"","vif",vif)) begin
               `uvm_fatal("RAM/DRV/NOVIF", "No Virtual interface specified for this driver instance")
       end
     end
   endfunction

   //Run Phase
   //Implement the driver sequencer API to get an Item
   //Based on if it is Read/Write - driver on RD or WR interface the
   //corresponding pins
   virtual task run_phase(uvm_phase phase);
     super.run_phase(phase);
     forever begin
       ram_rd_wr txn;
       @(this.vif.master_cb);
       //First get an item from the sequencer
       seq_item_port.get_next_item(txn);

       //Writing to scoreboard analysis port for expected data 
       Drv2sb_port.write(txn);

       @(this.vif.master_cb);
       uvm_report_info("RAM DRIVER", $psprintf("Got Transaction %s",txn.convert2string()));
       //Decode the command and call their Read/write function
       case(txn.operation)
	       ram_rd_wr::READ: ram_read(txn.addr, txn.rd_en);//:TODO - provision to convert to AXI RAM(May Be!)
	       ram_rd_wr::WRITE: ram_write(txn.addr, txn.wr_en, txn.data);//:TODO 
       endcase
       //Handshake done back to the sequencer
       seq_item_port.item_done();
     end

     virtual protected task ram_read();
     //TODO
     endtask
     
     virtual protected task ram_write();
     //TODO
     endtask

   endtask: run_phase



endclass

//--------------------------------------------
//RAM Sequencer class

class ram_sequencer extends uvm_sequencer #(ram_rd_wr)
  `uvm_component_utils(ram_sequencer)

  function new(input string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction
endclass : ram_sequencer


//----------------------------------------------------
//RAM Monitor class

class ram_monitor extends uvm_monitor;
  virtual rd_if.passive vif;

  //Analysis port parametrized to ram_rd_wr transaction
  //Monitor wtites transaction objects to this port once detected on interface
  //This will contribute to scoreboard
  uvm_analysis_port#(ram_rd_wr) Rvr2sb_port;


  //config class handle
  ram_config cfg;

  `uvm_component_utils(ram_monitor)

  function new(string name,uvm_component parent = null);
    super.new(name,parent;
    Rvr2sb_port = new("Rvr2sb",this));
  endfunction


 //get handle to virtual interface from agent/config_db
  virtual function void build_phase(uvm_phase phase);
  //:TODO
  ram_agent agent;

  if($cast(agent, get_parent()) && agent != null) begin
    vif = agent.vif;
  end
  else begin
   virtual rd_if vif;
   if(!uvm_config_db#(virtual rd_if)::get(this, "", "rd_if", vif)) begin
     `uvm_fatal("RAM/MON/NOVIF", "No Virtual interface specified for this monitor instance")
   end
   vif = tmp;
  end
  endfunction 


  virtual task run_phase()
    //:TODO convert signal level activity into transactions
    super.run_phase(phase);

    forever begin 
      ram_rd_wr  txn;
      //Wait for the SETUP cycle
      @(this.vif.monitor_cb);
      //Create a transaction object
      txn = ram_rd_wr::type_id::create("txn", this);

      //Populate fields based on values seen on interface
      txn.operation = (this.vif.monitor_cb.rd_en_d) ? ram_rd_wr::WRITE : ram_rd_wr::READ;
      txn.addr = this.vif.monitor_cb.rd_addr; // How would you get this?

      @(this.vif.monitor_cb);
      //Check for enable like APB else error it out
      
      txn.data = this.vif.monitor_cb.data_out; // How would you get this?

      uvm_report_info("RAM MONITOR", $psprintf("Got Transaction %s",txn.convert2string()));

      //Write to Analysis Port to be written to actual data queue for
      //scoreboard comparision
      Rvr2sb_port.write(txn);
    end
  endtask: run_phase


endclass: ram_monitor

`endif
