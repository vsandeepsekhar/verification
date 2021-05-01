/*
  A Basic Packet class constructing 12 bytes packet structure including Parity.
  Contraints can be added based on packet structure
*/

class header_pkt;
  //Header Info in Bytes
  rand byte header[2];
  //Payload Info in Bytes
  rand byte payload[8];
  
  //2 HDR, 1 CRC HDR, 8 PYLD, 1 CRC PYLD
  byte packet[12];
  
  //CRC of the Header
  byte header_crc;
  //CRC of the Payload
  byte payload_crc; //Computed over Header and Packet Data
  
  //Put Header constraints here if any!
  
  //Put Payload constraints here if any!
  
  function void build_packet();
    for(int i=0;i<12;i++) begin 
      if(i<2)
        packet[i] = header[i];
      else if(i==2)
        packet[i] = header_crc;
      else if((i > 2) && (i<10))
        packet[i] = payload[i-3];
      else 
        packet[i] = 8'h00;
    end
  endfunction
  
  //Pre randomize method to see what the value of the random variables 
  function void pre_randomize();
    $display("Before Randomizations!");
    $display("header_crc = %0h",header_crc);
    $display("payload_crc = %0h",payload_crc);
  endfunction
  
  //Post Randomize function to calculate Header_CRC and Payload_CRC
  function void post_randomize();
    for(int i=0;i<2;i++) begin 
      header_crc = (header_crc ^ header[i]);
    end
    //Building packet with CRC
    build_packet();
    
    for(int i=0;i<11;i++) begin 
      payload_crc = payload_crc ^ packet[i];
    end
    packet[11] = payload_crc;
  endfunction
           
  function void display();
    for(int i=0;i<12;i++) begin 
      $display("Packet[%0d] = %0h",i,packet[i]);
    end
  endfunction
  
endclass
           
module tb();
  header_pkt pkt;
  
  initial begin
    pkt = new();
    assert(pkt.randomize());
    pkt.display();
  end
endmodule  
