
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "defines.sv"
`include "fifo_if.sv"
`include "FIFO.v"
  `include "fifo_seq_item.sv"
  `include "fifo_sequence.sv"
  `include "fifo_sequencer.sv"
  `include "fifo_write_driver.sv"
  `include "fifo_read_driver.sv"
  `include "fifo_write_active_monitor.sv"
  `include "fifo_read_active_monitor.sv"
  `include "fifo_write_active_agent.sv"
  `include "fifo_read_active_agent.sv"		
  `include "fifo_scoreboard.sv"
  `include "fifo_func_cov.sv"
  `include "fifo_environment.sv"
  `include "fifo_test.sv"
//   `include "fifo_bind.sv"
//   `include "fifo_assertions.sv"

module top;
  	bit wclk,rclk;
  	bit wrst_n,rrst_n;

  	
  	initial wclk = 1'b0;
  	always #5 wclk = ~ wclk;

  	initial rclk = 1'b0;
  	always #10 rclk = ~ rclk;

  	initial begin
    wrst_n = 1'b0; 
    rrst_n = 1'b0;

// intf.rinc = 1'b0;
// intf.winc = 1'b0;

    #20 wrst_n = 1'b1;
    rrst_n = 1'b1;
    end

    // initial begin
    // rrst_n = 1'b0;
    // #15 rrst_n = 1'b1;
    // end

   //#( .DATA_WIDTH(`DATA_WIDTH), .ADDR_WIDTH(`ADDR_WIDTH) )

  fifo_if  intf (wclk, rclk, wrst_n, rrst_n);

  FIFO #( .DSIZE(`DATA_WIDTH), .ASIZE(`ADDR_WIDTH)) DUV (
                                                        .rdata(intf.rdata),     
                                                        .wfull(intf.wfull),                   
                                                        .rempty(intf.rempty),                  
                                                        .wdata(intf.wdata),        
                                                        .winc(intf.winc), 
                                                        .wclk(wclk), 
                                                        .wrst_n(wrst_n),       
                                                        .rinc(intf.rinc), 
                                                        .rclk(rclk), 
                                                        .rrst_n(rrst_n)        
                                                        );

  initial begin
    uvm_config_db#(virtual fifo_if)::set(null,"*","vif",intf); 
  end
  
  initial begin
    run_test("fifo_write_read_test");
    #100; $finish;
  end
endmodule
