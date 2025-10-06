class fifo_read_driver extends uvm_driver #(fifo_read_seq_item);

    virtual fifo_if vif;
    `uvm_component_utils(fifo_read_driver)

function new(string name = "fifo_read_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction //new

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
        if(!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))begin
            `uvm_fatal(get_type_name(), "Virtual interface not found")
        end
endfunction //build_phase

 virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    if(!vif.rrst_n)begin// wait until reset is de-asserted then drive inputs
        vif.rinc <= 1'b0; // Initialize read increment signal
				`uvm_info(get_type_name(),$sformatf("[%0t] DUT is in RESET=%0b !!!",$time,vif.rrst_n),UVM_LOW)
				@(posedge vif.rrst_n);
		end
     @(vif.rdrv_cb);
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(), $sformatf("Driving Read Transaction:\n%s", req.sprint()), UVM_HIGH)
      drive_read_item(req);
      // Update transaction with response
      req.rempty = vif.rempty;
      $display("\n----------------------------Read Driver---------------------------");
      req.print();
      seq_item_port.item_done();
    end
  endtask
  
  task drive_read_item(fifo_read_seq_item trans);
  
    vif.rinc <= trans.rinc;
    if(trans.rinc && !vif.rempty) begin
      `uvm_info(get_type_name(), $sformatf("Read: Rinc=%0b, rempty=%0b", trans.rinc, vif.rempty), UVM_MEDIUM)
    end else if(trans.rinc && vif.rempty) begin
      `uvm_info(get_type_name(), "Read attempted but FIFO is EMPTY", UVM_MEDIUM)
    end
    @(vif.rdrv_cb);
  endtask
  
endclass
