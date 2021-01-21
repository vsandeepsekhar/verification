//-----------------------------------------------------------------
//------------------------- Includes all the packages-------------

package environment_pkgs;

import uvm_pkg::*;
`include "uvm_macros.svh"

//Include all files
`include "dualport_ram_local.sv"
`include "env_package.sv"
`include "ram_agent_env_config.svh"
`include "ram_driver_seq_mon.svh"
`include "ram_rd_wr_sequences.sv"
`include "ram_rd_wr.sv"
`include "rd_if.sv"
`include "testbench.sv"
`include "ram_score_board.sv"


endpackage
