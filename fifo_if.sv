interface fifo_if  (input bit wclk, input bit rclk, input bit wrst_n, input bit rrst_n);

// #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 4 )
 // Write interface signalsvim 
  logic [`DATA_WIDTH-1:0] wdata;
  logic winc;
  bit wfull;
  logic [`ADDR_WIDTH:0] wptr;
  
  // Read interface signals
  logic [`DATA_WIDTH-1:0] rdata;
  logic rinc;
  logic rempty;
  logic [`ADDR_WIDTH:0] rptr;

  // Clocking blocks for synchronization
  clocking wdrv_cb @(posedge wclk);
    // default input #0 output #0;
    output wdata;
    output winc;
    input wfull;
    // input wptr;
  endclocking
  
  clocking rdrv_cb @(posedge rclk);
    // default input #0 output #0;
    output rinc;
    input rempty;
    // input rptr;
  endclocking
  
  // Monitor clocking blocks
  clocking wmon_cb @(posedge wclk);
    default input #0;
    input wdata;
    input winc;
    input wfull;
    input wptr;
  endclocking
  
  clocking rmon_cb @(posedge rclk);
    default input #0;
    input rdata;
    input rinc;
    input rempty;
    input rptr;
  endclocking

property p1;
    @(posedge wclk) disable iff (!wrst_n)
      winc |-> !($isunknown(wdata));
  endproperty
      
  wdata_check:
    assert property (p1)
      $info("ASSERTION-1 PASSED: WDATA CHECK");
    else
      $error("ASSERTION-1 FAILED: WDATA CHECK");
      

  property p2;
    @(posedge wclk) disable iff (!wrst_n)
      (winc && wfull) |-> $stable(wdata);
  endproperty
        
  wdata_stability_check:
    assert property (p2)
      $info("ASSERTION-2 PASSED: WDATA STABILITY CHECK");
    else
      $error("ASSERTION-2 FAILED: WDATA STABILITY CHECK");
      

  property p3;
    @(posedge rclk) disable iff (!rrst_n)
      (rinc && !rempty) |-> !($isunknown(rdata));
  endproperty
   
  rdata_check:
    assert property (p3)
      $info("ASSERTION-3 PASSED: RDATA CHECK");
    else
      $error("ASSERTION-3 FAILED: RDATA CHECK");
      
  
  property p4;
    @(posedge rclk) disable iff (!rrst_n)
      !(rempty && wfull);
  endproperty
 

  
  // // Modports for drivers
  // modport wdrv_mp (
  //   clocking wdrv_cb,
  // );
  
  // modport rdrv_mp (
  //   clocking rdrv_cb,
  // );
  
  // // Modports for monitors
  // modport wmon_mp (
  //   clocking wmon_cb,
  // );
  
  // modport rmon_mp (
  //   clocking rmon_cb,
  // );
  
endinterface
