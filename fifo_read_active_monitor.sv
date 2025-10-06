class fifo_read_active_monitor extends uvm_monitor;
  
  
  virtual fifo_if vif;
  uvm_analysis_port #(fifo_read_seq_item) item_collected_port;
  fifo_read_seq_item trans_collected;

  `uvm_component_utils(fifo_read_active_monitor)

  function new(string name = "fifo_read_active_monitor", uvm_component parent = null);
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
  @(posedge vif.rrst_n); // Wait for reset de-assertion
    
    forever begin
      @(vif.rmon_cb);

      if(vif.rinc) begin
        read_monitor_collect();
        item_collected_port.write(trans_collected);
      end
    end
  endtask


  task read_monitor_collect();
    trans_collected.rdata = vif.rdata;
    trans_collected.rinc = vif.rinc;
    trans_collected.rempty = vif.rempty;
    `uvm_info(get_type_name(), $sformatf("Read Monitor Collected: rdata=0x%0h, rinc=%0b, rempty=%0b", trans_collected.rdata, trans_collected.rinc, trans_collected.rempty), UVM_MEDIUM);
  endtask

endclass
