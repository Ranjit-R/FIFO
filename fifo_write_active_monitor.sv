class fifo_write_active_monitor extends uvm_monitor;
  
  virtual fifo_if vif;
  uvm_analysis_port #(fifo_write_seq_item) item_collected_port;
  fifo_write_seq_item trans_collected;
  
  `uvm_component_utils(fifo_write_active_monitor)

  function new(string name = "fifo_write_active_monitor", uvm_component parent = null);
    super.new(name, parent);
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Virtual interface not found")
  endfunction
  
  task run_phase(uvm_phase phase);
  @(posedge vif.wrst_n); // Wait for reset de-assertion
    
    forever begin
      @(vif.wmon_cb);
     
      if(vif.winc) begin
        write_monitor_collect();
        item_collected_port.write(trans_collected);
      end
    end
  endtask


  task write_monitor_collect();
 
    trans_collected.wdata = vif.wdata;
    trans_collected.winc = vif.winc;
    trans_collected.wfull = vif.wfull;
    `uvm_info(get_type_name(), $sformatf("Write Monitor Collected: wdata=0x%0h, winc=%0b, wfull=%0b", trans_collected.wdata, trans_collected.winc, trans_collected.wfull), UVM_MEDIUM);
  endtask

endclass
