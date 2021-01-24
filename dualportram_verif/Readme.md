<br> The Verification file data structure </br>

<pre><font color="#3465A4"><b>verification</b></font>
├── <font color="#3465A4"><b>dualportram_verif</b></font>
│   ├── <font color="#3465A4"><b>dut</b></font>
│   │   └── dualport_ram_local.sv
│   └── <font color="#3465A4"><b>ip_dv</b></font>
│       ├── env_package.sv
│       ├── <font color="#3465A4"><b>interface</b></font>
│       │   └── rd_if.sv
│       ├── <font color="#3465A4"><b>sequences</b></font>
│       │   ├── ram_rd_wr_sequences.sv
│       │   └── <font color="#3465A4"><b>seq_items</b></font>
│       │       └── ram_rd_wr.sv
│       ├── <font color="#3465A4"><b>tb_inf</b></font>
│       │   ├── ram_agent_env_config.svh
│       │   ├── ram_driver_seq_mon.svh
│       │   └── ram_score_board.sv
│       ├── testbench.sv
│       └── <font color="#3465A4"><b>tests</b></font>
│           └── ram_basic_test.svh
└── README.md
</pre>
