/* A Synchronous dual port RAM
* 1 port : READ
* 1 port : WRITE
* Depth of Memory : 256
* Width of Memory : 8 bits
*/

module dual_port_ram(
  input logic clk, //clock
  input logic [7:0] data_in, //input data
  output logic [7:0] data_out, //output data
  input logic wr_en, //1 => Write port enabled
  input logic [7:0] wr_addr, //Memory Write port Address
  input logic rd_en, //1=> read port enabled
  input logic [7:0] rd_addr //Memory Read Address
);


//Memory Array
logic [7:0] mem_array [255:0];

//Write to the memeory of write enabled

always@(posedge clock) begin 
  if(wr_en) begin  //WRITE port
    mem_array[wr_addr] = data_in; 
  end
  if(rd_en) begin //READ port 
    data_out = mem_array[rd_addr];
  end  
end

endmodule 


