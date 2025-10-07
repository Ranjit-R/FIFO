class fifo_environment extends uvm_env;
  fifo_write_active_agent write_agent;
  fifo_read_active_agent  read_agent;
  fifo_scoreboard         scoreboard;
  fifo_cov                cov;
  
  `uvm_component_utils(fifo_environment)
  
  function new(string name = "fifo_environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    write_agent = fifo_write_active_agent::type_id::create("write_agent", this);
    read_agent  = fifo_read_active_agent::type_id::create("read_agent", this);
    scoreboard  = fifo_scoreboard::type_id::create("scoreboard", this);
    cov         = fifo_cov::type_id::create("cov", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // Connect agents to scoreboard
    write_agent.monitor.item_collected_port.connect(scoreboard.write_fifo.analysis_export);
    read_agent.monitor.item_collected_port.connect(scoreboard.read_fifo.analysis_export);
    
    // Connect write monitor to coverage
    write_agent.monitor.item_collected_port.connect(cov.write_export);
    
    // Connect read monitor to coverage
    read_agent.monitor.item_collected_port.connect(cov.read_export);
  endfunction
  
endclass
