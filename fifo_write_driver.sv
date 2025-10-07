class fifo_write_driver extends uvm_driver #(fifo_write_seq_item);
    `uvm_component_utils(fifo_write_driver)
    fifo_write_seq_item req;

    virtual fifo_if vif;

    function new(string name = "fifo_write_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Virtual interface not found")
        end
    endfunction //build_phase


virtual task run_phase(uvm_phase phase);
super.run_phase(phase);
  if(!vif.wrst_n)begin// wait until reset is de-asserted then drive inputs
        vif.winc <= 1'b0; // Initialize write increment signal
				`uvm_info(get_type_name(),$sformatf("[%0t] DUT is in RESET=%0b !!!",$time,vif.wrst_n),UVM_LOW)
				@(posedge vif.wrst_n);
		end
    //  @(vif.wdrv_cb);
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(), $sformatf("Driving Write Transaction:\n%s", req.sprint()), UVM_HIGH)
      drive_write_item(req);
      // Update transaction with response
      // req.wfull = vif.wfull;
      $display("\n----------------------------Write Driver---------------------------");
      req.print();
      seq_item_port.item_done();
    end
  endtask

  task drive_write_item(fifo_write_seq_item req);
    vif.winc <= req.winc;
    if(req.winc && !vif.wfull) begin
      vif.wdata <= req.wdata;
    end 
    else if(req.winc && vif.wfull) begin
      `uvm_info(get_type_name(), "Write attempted but FIFO is FULL", UVM_MEDIUM)
    end
    else if(!req.winc) begin
      `uvm_info(get_type_name(), "No Write Operation (winc=0)", UVM_MEDIUM)
    end
    @(vif.wdrv_cb);
  endtask
  
endclass                            
