class fifo_environment extends uvm_env;

  fifo_write_active_agent write_agent;
  fifo_read_active_agent read_agent;
  fifo_scoreboard scoreboard;
  
  // fifo_virtual_sequencer virtual_seqr;

  `uvm_component_utils(fifo_environment)

  function new(string name = "fifo_environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    write_agent = fifo_write_active_agent::type_id::create("write_agent", this);
    read_agent = fifo_read_active_agent::type_id::create("read_agent", this);
    scoreboard = fifo_scoreboard::type_id::create("scoreboard", this);
    // virtual_seqr = fifo_virtual_sequencer::type_id::create("virtual_seqr", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // virtual_seqr.write_seqr = write_agent.sequencer;
    // virtual_seqr.read_seqr = read_agent.sequencer;
    write_agent.monitor.item_collected_port.connect(scoreboard.write_fifo.analysis_export);
    read_agent.monitor.item_collected_port.connect(scoreboard.read_fifo.analysis_export);
    
  endfunction
  
endclass
