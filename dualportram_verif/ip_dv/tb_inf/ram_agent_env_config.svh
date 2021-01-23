//--------------------------------------------------------------------------
//This file contains ram config, ram_agent and ram_env class components
//--------------------------------------------------------------------------

`ifdef RAM_AGENT_ENV_CFG__SV
`define RAM_AGENT_ENV_CFG__SV

//--------------------------
// RAM Config class

class ram_config extends uvm_object;
  `uvm_object_utils(ram_config)
  virtual rd_if rd_vif;

  function new(string name="ram_config")
    super.new(name);
  endfunction

endclass 

//---------------------------
// ram Agent Class

class ram_agent extends uvm_agent;

//Agent will have the sequencer, driver and monitor components for the
//RAM interface

  ram_rd_wr_sequncer sqr;
  ram_master_drv drv;
  ram_monitor mon;

  virtual rd_if rd_vif;
  
  //Registers the sequencer, driver and Monitor with UVM factory
  `uvm_component_utils_begin(ram_agent)
    `uvm_field_object(sqr, UVM_ALL_ON)
    `uvm_field_object(drv, UVM_ALL_ON)
    `uvm_field_object(mon, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name, uvm_component parent = null);
    super.new(name,parent);
  endfunction

  //Build phase of Agent - Construct Sequencer, driver and Monitor

 virtual function void build_phase(uvm_phase phase);
   sqr = ram_rd_wr_sequncer::type_id::create("sqr", this);
   drv = ram_master_drv::type_id::create("drv", this);
   mon = ram_monitor::type_id::create("mon", this);

   if(!uvm_config_db#(virtual rd_vif)::get(this, "", "vif", rd_vif)) begin
     `uvm_fatal("RAM/NOVIF", "No Virtual Interface specified for this agent interface");
   end

   uvm_config_db#(virtual rd_vif)::set(this, "sqr", "vif", rd_vif);
   uvm_config_db#(virtual rd_vif)::set(this, "drv", "vif", rd_vif);
   uvm_config_db#(virtual rd_vif)::set(this, "mon", "vif", rd_vif);

 endfunction: build_phase

 //Connect - driver and sequencer port to export
 virtual function void connect_phase(uvm_phase phase);
   drv.seq_item_port.connect(sqr.seq_item_export);
   uvm_report_info("ram_agent::","connect phase, Connected driver to sequencer");
 endfunction 

endclass : ram_agent

//---------------------------------------------------------------------------------
// RAM Env class

class ram_env extends uvm_env;
  
  `uvm_component_utils(ram_env);
  //Env Class will have agent as its sub component
  ram_agent agt;

  //virtual interface for RAM RD Interface
  virtual rd_if rd_vif;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction 

  //Build Phase - Construct agent and get virtual interface froim test and
  //pass it down to agent
  function void build_phase(uvm_phase phase);
    agt = ram_agent::type_id::create("agt", this);
    if(!uvm_config_db#(virtual rd_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("ENV/NOVIF", "No Virtual Interface specified for this env instance");
    end
    uvm_config_db#(virtual rd_vif)::set(this, "agt", "vif", rd_vif);
  endfunction
endclass

`endif
