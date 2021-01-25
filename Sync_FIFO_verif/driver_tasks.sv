/*
  Following are the driver tasks to FIFO
*/

//Initialize TB with clean values
task initialize_tb;
  clk = 0;
  reset = 1'b1;
  write = 1'b0;
  read = 1'b0;
  data_in = 16'h0000;
endtask


//A Single read task
task single_read_fifo;
  @(posedge clk);
  read = 1'b1;
  @(posedge clk);
  read = 1'b0;
endtask

//A Single write task
task single_write_fifo;
  @(posedge clk);
  write = 1'b1;
  data_in = $random;
  @(posedge clk);
  data_in = 16'h0000;
  write = 1'b0;
endtask


//Task to fill the FIFO
  task fill_fifo;
    int i;
    for(i=0;i<100;i++) begin
      @(posedge clk);
      write = 1'b1;
      data_in = i[31:0];
    end
  endtask

 //Task to empty the FIFO
 task empty_fifo;
   int i;
   for(i=0;i<100;i++) begin
     @(posedge clk);
     read = 1'b1;
   end
 endtask

//Create VCD dump
task create_wave_dump;
  $dumpfile("dump.vcd");
  $dumpvars(1,tb);
endtask

//

