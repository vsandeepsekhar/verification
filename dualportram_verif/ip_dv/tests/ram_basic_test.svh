//----------------Basic RAM Test
// To include everything from testbench

//
//
`ifndef RAM_BASIC_TEST_SVH
`define RAM_BASIC_TEST_SVH

class ram_base_test extends uvm_test;
	//Register with factory
	`uvm_component_utils(ram_base_test);

	ram_env env;
	ram_config cfg;
	virtual rd_if vif;

	function new(string name="ram_base_test", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	//Build phase - Construct the cfg and env class using the factory
	
	function void build_phase(uvm_phase phase);
		cfg = ram_config::type_id::create("cfg", this);
		env = ram_env::type_id::create("env", this);
		if(!uvm_config_db#(virtual rd_if)::get(this, "", "vif", vif)) begin
			`uvm_fatal("RAM_BASE_TEST/NOVIF","No Virtual interface specified in this test instance")
		end
		uvm_config_db#(virtual ram_rd)::set( this, "env", "vif", vif);
	endfunction



	task run_phase(uvm_phase phase);
		ram_base_seq ram_seq;
		ram_seq = ram_base_seq::type_id::create("ram_seq");

		phase.raise_objection(this, "Starting Base sequence Main Phase");
		$display("%t Starting the sequence ram_base_seq",$time);
		ram_seq.start(env.agt.sqr);

		#100ns

		phase.drop_objection(this, "Finished apb_seq in main phase");
	endtask: run_phase
endclass

`endif
